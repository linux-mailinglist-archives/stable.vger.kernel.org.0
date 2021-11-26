Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A05545E4A1
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 03:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357725AbhKZCfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:35:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:47858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357710AbhKZCdn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:33:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E5F961157;
        Fri, 26 Nov 2021 02:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637893831;
        bh=psvaYODCTHeAeAhhw7j+HQYH7wgiqo5qVzONu8A+lHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LCJafoMNZZQyP6E4Zlw34MsbAqvHjwBKRKKeP/q/i4c5C/xbg3p8KeSvgEMuj6p/j
         XBVJ/ftN2do7BPKytKLXnAzKAz4bd5gfDa+l5mE3Wakn02vphcuIOurnTdPxzkAmG5
         4CDGN99+96sIjx9Mz0SdZFPJYHtcJ+jX8vwqh2OkLfV4j+GH0mH7mUfuvjIoc/vVGu
         2T/Ve+TxZlOwgiB6Mo2L4fvvo3+NIuOHALDY1BrAKBIUMBOfMT4AFMmWg0xD407YEd
         tdFDTrKb63YZDMGBEFYJ+vxFNVonRIvwYiZcLj0z++d0PzrhaktRrPCtQf8E8FLHjn
         2zqGbIo2q/GvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>,
        Paulo Alcantara <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.15 5/7] cifs: nosharesock should not share socket with future sessions
Date:   Thu, 25 Nov 2021 21:30:04 -0500
Message-Id: <20211126023006.440839-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023006.440839-1-sashal@kernel.org>
References: <20211126023006.440839-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit c9f1c19cf7c50949885fa5afdb2cb242d61a7fac ]

Today, when a new mount is done with nosharesock, we ensure
that we don't select an existing matching session. However,
we don't mark the connection as nosharesock, which means that
those could be shared with future sessions.

Fixed it with this commit. Also printing this info in DebugData.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifs_debug.c | 2 ++
 fs/cifs/cifsglob.h   | 1 +
 fs/cifs/connect.c    | 8 +++++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index de2c12bcfa4bc..905a901f7f80b 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -358,6 +358,8 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 			seq_printf(m, " signed");
 		if (server->posix_ext_supported)
 			seq_printf(m, " posix");
+		if (server->nosharesock)
+			seq_printf(m, " nosharesock");
 
 		if (server->rdma)
 			seq_printf(m, "\nRDMA ");
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index dea4c929d3f46..3e5b8e177cfa7 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -592,6 +592,7 @@ struct TCP_Server_Info {
 	struct list_head pending_mid_q;
 	bool noblocksnd;		/* use blocking sendmsg */
 	bool noautotune;		/* do not autotune send buf sizes */
+	bool nosharesock;
 	bool tcp_nodelay;
 	unsigned int credits;  /* send no more requests at once */
 	unsigned int max_credits; /* can override large 32000 default at mnt */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index e757ee52cc777..d26703a05c6b4 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1217,7 +1217,13 @@ static int match_server(struct TCP_Server_Info *server, struct smb3_fs_context *
 {
 	struct sockaddr *addr = (struct sockaddr *)&ctx->dstaddr;
 
-	if (ctx->nosharesock)
+	if (ctx->nosharesock) {
+		server->nosharesock = true;
+		return 0;
+	}
+
+	/* this server does not share socket */
+	if (server->nosharesock)
 		return 0;
 
 	/* If multidialect negotiation see if existing sessions match one */
-- 
2.33.0

