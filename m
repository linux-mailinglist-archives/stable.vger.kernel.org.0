Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB378C829
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729305AbfHNCRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:17:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727804AbfHNCRJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:17:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE021208C2;
        Wed, 14 Aug 2019 02:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749028;
        bh=I+Et8CHLaDHb5aVf7jBfwWjMAQP/TDM5XArmZyBJHiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TCSmyQhHTutR1NAlh2ukJxUmwySfUv2zCNIVweA5/Cxn8MF0XPwFoHobpet53Wd/K
         jmT7u0TJjLXyjsFzcnuFnrRefkJqdOYowP/uZHAISz3oC1AE2/BVuwRGmZNkubW5sY
         9tFfMvXHQtWZQCpNvrxofiZezlV3mQDhwQLe/teM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 46/68] SMB3: Fix potential memory leak when processing compound chain
Date:   Tue, 13 Aug 2019 22:15:24 -0400
Message-Id: <20190814021548.16001-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021548.16001-1-sashal@kernel.org>
References: <20190814021548.16001-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Shilovsky <pshilov@microsoft.com>

[ Upstream commit 3edeb4a4146dc3b54d6fa71b7ee0585cb52ebfdf ]

When a reconnect happens in the middle of processing a compound chain
the code leaks a buffer from the memory pool. Fix this by properly
checking for a return code and freeing buffers in case of error.

Also maintain a buf variable to be equal to either smallbuf or bigbuf
depending on a response buffer size while parsing a chain and when
returning to the caller.

Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 0ccf8f9b63a2e..97fdbec54db97 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3121,7 +3121,6 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 {
 	int ret, length;
 	char *buf = server->smallbuf;
-	char *tmpbuf;
 	struct smb2_sync_hdr *shdr;
 	unsigned int pdu_length = server->pdu_size;
 	unsigned int buf_size;
@@ -3151,18 +3150,15 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 		return length;
 
 	next_is_large = server->large_buf;
- one_more:
+one_more:
 	shdr = (struct smb2_sync_hdr *)buf;
 	if (shdr->NextCommand) {
-		if (next_is_large) {
-			tmpbuf = server->bigbuf;
+		if (next_is_large)
 			next_buffer = (char *)cifs_buf_get();
-		} else {
-			tmpbuf = server->smallbuf;
+		else
 			next_buffer = (char *)cifs_small_buf_get();
-		}
 		memcpy(next_buffer,
-		       tmpbuf + le32_to_cpu(shdr->NextCommand),
+		       buf + le32_to_cpu(shdr->NextCommand),
 		       pdu_length - le32_to_cpu(shdr->NextCommand));
 	}
 
@@ -3191,12 +3187,21 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 		pdu_length -= le32_to_cpu(shdr->NextCommand);
 		server->large_buf = next_is_large;
 		if (next_is_large)
-			server->bigbuf = next_buffer;
+			server->bigbuf = buf = next_buffer;
 		else
-			server->smallbuf = next_buffer;
-
-		buf += le32_to_cpu(shdr->NextCommand);
+			server->smallbuf = buf = next_buffer;
 		goto one_more;
+	} else if (ret != 0) {
+		/*
+		 * ret != 0 here means that we didn't get to handle_mid() thus
+		 * server->smallbuf and server->bigbuf are still valid. We need
+		 * to free next_buffer because it is not going to be used
+		 * anywhere.
+		 */
+		if (next_is_large)
+			free_rsp_buf(CIFS_LARGE_BUFFER, next_buffer);
+		else
+			free_rsp_buf(CIFS_SMALL_BUFFER, next_buffer);
 	}
 
 	return ret;
-- 
2.20.1

