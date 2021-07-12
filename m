Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA11A3C4D83
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239151AbhGLHNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:13:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242372AbhGLHGn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:06:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C468610FA;
        Mon, 12 Jul 2021 07:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073432;
        bh=Ky6Rv/816TnbKMyPZfariJoAXgkJyHCGWLh6Ik51jzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zYXsbTASLDAlPoOD2R252Hbxn7KbXlGuhjd0UOtd2UhXlHflRAzFz3saYkUM6wIFl
         m/UA73/ivhnaEAEJSPcYLBJwFugqWEt20rSq4Z/W6qIPx8/fAgZRPX5pHYYEgeXB1y
         4f0RMttbYuD5Ci1XHKMQyVpW4/k3XTXhkxq5kTfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 240/700] cifs: fix missing spinlock around update to ses->status
Date:   Mon, 12 Jul 2021 08:05:23 +0200
Message-Id: <20210712061000.881215515@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index ec824ab8c5ca..723b97002d8d 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -896,7 +896,7 @@ struct cifs_ses {
 	struct mutex session_mutex;
 	struct TCP_Server_Info *server;	/* pointer to server info */
 	int ses_count;		/* reference counter */
-	enum statusEnum status;
+	enum statusEnum status;  /* updates protected by GlobalMid_Lock */
 	unsigned overrideSecFlg;  /* if non-zero override global sec flags */
 	char *serverOS;		/* name of operating system underlying server */
 	char *serverNOS;	/* name of network operating system of server */
@@ -1783,6 +1783,7 @@ require use of the stronger protocol */
  *	list operations on pending_mid_q and oplockQ
  *      updates to XID counters, multiplex id  and SMB sequence numbers
  *      list operations on global DnotifyReqList
+ *      updates to ses->status
  *  tcp_ses_lock protects:
  *	list operations on tcp and SMB session lists
  *  tcon->open_file_lock protects the list of open files hanging off the tcon
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 3d62d52d730b..09a3939f25bf 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1639,9 +1639,12 @@ void cifs_put_smb_ses(struct cifs_ses *ses)
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



