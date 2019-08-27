Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57BB39E1CE
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbfH0H4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:56:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729696AbfH0H4R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:56:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C78B206BA;
        Tue, 27 Aug 2019 07:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892575;
        bh=i5Jgkpqf/Im+tbDi/BtnbwcDMMNHSPeIWGCo8ndierY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZVQNB7Co3t951hpU/HvM96AjJNnY/sit4ZriAN5q978uLUVvIi9K9g3kXKYIWoNTC
         JaRE7yr4/2WG2A4Q61hCokfki8iYZVnN7QV3Dg00uXbAoOzp8HTGMK49Clb2zZkQR4
         wWVs5H7RHfkX6/brxODoNkN/WwlcONti8kdInQE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/98] SMB3: Fix potential memory leak when processing compound chain
Date:   Tue, 27 Aug 2019 09:50:18 +0200
Message-Id: <20190827072720.252611874@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



