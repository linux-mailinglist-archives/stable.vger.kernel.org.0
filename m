Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2733BC04B
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbhGEPfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:35:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233057AbhGEPeM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:34:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63BAF619B3;
        Mon,  5 Jul 2021 15:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499067;
        bh=lSfJF6GAWok9ndKgaHe/W5GtGfCcKUVUStrb5YyW1GE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DAREVoZ2fEl6MLCPtrhSZ6xhHAR+KntkgKTmkPst9TurttwNUQXG13TdELTsYGL13
         0kd8XrxgJbUButCEmOO1UPDabuVkRYN0GxyTZJYszzJnawJEQwvV5Kcko3TERpz1M3
         1XOj/bwWjPHsa/LxjOOaLLextOUNK6dlHJtPCt/w5bhFOPdDONm0QWiepU+fEHKx0Q
         GYaHbn0RLgDhN/CjzFZY3BH/+7oFnSKclX1plGGnxyuqZ4n+gVuBNQvKoUsMFVKlnW
         bkvKk41/bYjyQ13AUSELIHuCh2GKMNt2KrKCKgaTFHVS+xBiuA0a619WP6nnJ7aJit
         kFHa2CI1ky2pA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.4 22/26] cifs: fix missing spinlock around update to ses->status
Date:   Mon,  5 Jul 2021 11:30:35 -0400
Message-Id: <20210705153039.1521781-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153039.1521781-1-sashal@kernel.org>
References: <20210705153039.1521781-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

