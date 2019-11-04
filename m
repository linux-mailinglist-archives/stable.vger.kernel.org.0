Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30F06EEF5C
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730755AbfKDV6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:58:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:55836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730739AbfKDV6r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:58:47 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FE8720650;
        Mon,  4 Nov 2019 21:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904727;
        bh=d1+D2WbtCi048YV1rKTlYg7OIfGww8vt5fBXO1vSNng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TiEloVjFsrfcI7R6Mb91S/n16QO3XRqvf2AzRyHiZ2oC+eu0qp2l6nZAUaqBAThp8
         KvCocJjT7shUMZqtN4bQkVPZeIaVe1fijhzmamm+awfggxxb5LCFOedMDzdQmR9S6D
         Qi61tIvkg15dLtE4Naqs1S2ckJi2uK1xZSE1sKxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 049/149] cifs: add credits from unmatched responses/messages
Date:   Mon,  4 Nov 2019 22:44:02 +0100
Message-Id: <20191104212139.553840698@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit eca004523811f816bcfca3046ab54e1278e0973b ]

We should add any credits granted to us from unmatched server responses.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c  | 22 ++++++++++++++++++++++
 fs/cifs/smb2misc.c |  7 -------
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 966e493c82e57..7e85070d010f4 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -930,6 +930,26 @@ cifs_handle_standard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	return 0;
 }
 
+static void
+smb2_add_credits_from_hdr(char *buffer, struct TCP_Server_Info *server)
+{
+	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)buffer;
+
+	/*
+	 * SMB1 does not use credits.
+	 */
+	if (server->vals->header_preamble_size)
+		return;
+
+	if (shdr->CreditRequest) {
+		spin_lock(&server->req_lock);
+		server->credits += le16_to_cpu(shdr->CreditRequest);
+		spin_unlock(&server->req_lock);
+		wake_up(&server->request_q);
+	}
+}
+
+
 static int
 cifs_demultiplex_thread(void *p)
 {
@@ -1059,6 +1079,7 @@ next_pdu:
 			} else if (server->ops->is_oplock_break &&
 				   server->ops->is_oplock_break(bufs[i],
 								server)) {
+				smb2_add_credits_from_hdr(bufs[i], server);
 				cifs_dbg(FYI, "Received oplock break\n");
 			} else {
 				cifs_dbg(VFS, "No task to wake, unknown frame "
@@ -1070,6 +1091,7 @@ next_pdu:
 				if (server->ops->dump_detail)
 					server->ops->dump_detail(bufs[i],
 								 server);
+				smb2_add_credits_from_hdr(bufs[i], server);
 				cifs_dump_mids(server);
 #endif /* CIFS_DEBUG2 */
 			}
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 0a7ed2e3ad4f2..e311f58dc1c82 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -659,13 +659,6 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 	if (rsp->sync_hdr.Command != SMB2_OPLOCK_BREAK)
 		return false;
 
-	if (rsp->sync_hdr.CreditRequest) {
-		spin_lock(&server->req_lock);
-		server->credits += le16_to_cpu(rsp->sync_hdr.CreditRequest);
-		spin_unlock(&server->req_lock);
-		wake_up(&server->request_q);
-	}
-
 	if (rsp->StructureSize !=
 				smb2_rsp_struct_sizes[SMB2_OPLOCK_BREAK_HE]) {
 		if (le16_to_cpu(rsp->StructureSize) == 44)
-- 
2.20.1



