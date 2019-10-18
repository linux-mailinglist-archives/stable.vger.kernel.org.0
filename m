Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D833DD3DE
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394190AbfJRWVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:21:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731590AbfJRWGa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:06:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2C1D222D1;
        Fri, 18 Oct 2019 22:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436389;
        bh=XeF4E6O1xicOpd4lFV31Ksy7SWvxr50/96ido8NDdcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xzNP+71ZJX4UXxJ++NE/PWOMm4nspRZN6avr0RNBdwJ7e6eHAioI7NAovsEtOVa6c
         AyHKyXph3nhi7lLUUIO+RmpPQ4iR+Tf13y2d8jBzFsnDfyRXTl+CR6y7atkCHiX9eH
         HnRhIgUg+s9RxlCJENT8R2+QrcBOFPXiCdbfGmuE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 041/100] cifs: add credits from unmatched responses/messages
Date:   Fri, 18 Oct 2019 18:04:26 -0400
Message-Id: <20191018220525.9042-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
@@ -1059,6 +1079,7 @@ cifs_demultiplex_thread(void *p)
 			} else if (server->ops->is_oplock_break &&
 				   server->ops->is_oplock_break(bufs[i],
 								server)) {
+				smb2_add_credits_from_hdr(bufs[i], server);
 				cifs_dbg(FYI, "Received oplock break\n");
 			} else {
 				cifs_dbg(VFS, "No task to wake, unknown frame "
@@ -1070,6 +1091,7 @@ cifs_demultiplex_thread(void *p)
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

