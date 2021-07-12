Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8BF93C451A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233712AbhGLGXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:23:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234395AbhGLGWc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:22:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B4176113A;
        Mon, 12 Jul 2021 06:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070769;
        bh=lSfJF6GAWok9ndKgaHe/W5GtGfCcKUVUStrb5YyW1GE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UIbyGa2ElLGt/pcSQ4FM0I6HbIPO6CQzaW3Rr6zmVSRzH7s9aJeWzAEYgkbbx7405
         zXzxQoaRlHXSLxqIlHJ3SVEtxtB1YtW7mwP0I3afD6BfiocBjqXRD132589r2iRAqM
         HQjk5RTIdePfXUoy+VbmWXfl4P1v9Qf2lx1zirmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 133/348] cifs: fix missing spinlock around update to ses->status
Date:   Mon, 12 Jul 2021 08:08:37 +0200
Message-Id: <20210712060718.921117721@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 0060a4f28a9ef45ae8163c0805e944a2b1546762 ]

In the other places where we update ses->status we protect the
updates via GlobalMid_Lock. So to be consistent add the same
locking around it in cifs_put_smb_ses where it was missing.

Addresses-Coverity: 1268904 ("Data race condition")
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsglob.h | 3 ++-
 fs/cifs/connect.c  | 5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index b16c994414ab..9c0e348cb00f 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -964,7 +964,7 @@ struct cifs_ses {
 	struct mutex session_mutex;
 	struct TCP_Server_Info *server;	/* pointer to server info */
 	int ses_count;		/* reference counter */
-	enum statusEnum status;
+	enum statusEnum status;  /* updates protected by GlobalMid_Lock */
 	unsigned overrideSecFlg;  /* if non-zero override global sec flags */
 	char *serverOS;		/* name of operating system underlying server */
 	char *serverNOS;	/* name of network operating system of server */
@@ -1814,6 +1814,7 @@ require use of the stronger protocol */
  *	list operations on pending_mid_q and oplockQ
  *      updates to XID counters, multiplex id  and SMB sequence numbers
  *      list operations on global DnotifyReqList
+ *      updates to ses->status
  *  tcp_ses_lock protects:
  *	list operations on tcp and SMB session lists
  *  tcon->open_file_lock protects the list of open files hanging off the tcon
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ab9eeb5ff8e5..da0720f41ebc 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3049,9 +3049,12 @@ void cifs_put_smb_ses(struct cifs_ses *ses)
 		spin_unlock(&cifs_tcp_ses_lock);
 		return;
 	}
+	spin_unlock(&cifs_tcp_ses_lock);
+
+	spin_lock(&GlobalMid_Lock);
 	if (ses->status == CifsGood)
 		ses->status = CifsExiting;
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&GlobalMid_Lock);
 
 	cifs_free_ipc(ses);
 
-- 
2.30.2



