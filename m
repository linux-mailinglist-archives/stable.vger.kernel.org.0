Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D29461F5F
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380391AbhK2Sqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:46:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50136 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380182AbhK2Soa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:44:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7866B8164B;
        Mon, 29 Nov 2021 18:41:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C10C53FC7;
        Mon, 29 Nov 2021 18:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211270;
        bh=psvaYODCTHeAeAhhw7j+HQYH7wgiqo5qVzONu8A+lHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hZWapBBZo3nSwpp24PQjGMAvin5Ffl00Be/GycPGAvI/8FV1vY8oPIIX6DLu7YU6N
         ZyVJzCSdcfAIUSBpMtmIkQcco5GvyfgUPDGmUHz0Y6sOL6xbsQO43rGLZ9V8nCq42F
         Zkn6XX1BV3zJs2wG30hoWLxidIEjFrc7RTyR4Sd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 164/179] cifs: nosharesock should not share socket with future sessions
Date:   Mon, 29 Nov 2021 19:19:18 +0100
Message-Id: <20211129181724.337330115@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



