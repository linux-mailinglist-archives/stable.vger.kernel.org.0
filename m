Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69993106D18
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730683AbfKVK5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:57:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:46512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730680AbfKVK5e (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:57:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DE0320718;
        Fri, 22 Nov 2019 10:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420253;
        bh=6mgRnQfaykb8JmlmvCmBvxQ1eh9Cxc7VpaUNmu09KsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cVrSEePE+gS2OXITR/C1DiwtTp+T26jvK21V8w98A+vSGj4lMj0IRcYuNwXPfjNkP
         kByIFxcWte755YyAhqz5ueHWQ+F/+TDSWy2oXcd+A7zc9H/+20TdvE/jAPeu4s7TLt
         F8I0IUH0ekXpTFGRznTJa8/mhlYXs+sso6K52068=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vakul Garg <vakul.garg@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 045/220] selftests/tls: Fix recv(MSG_PEEK) & splice() test cases
Date:   Fri, 22 Nov 2019 11:26:50 +0100
Message-Id: <20191122100915.481492952@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vakul Garg <vakul.garg@nxp.com>

[ Upstream commit 0ed3015c9964dab7a1693b3e40650f329c16691e ]

TLS test cases splice_from_pipe, send_and_splice &
recv_peek_multiple_records expect to receive a given nummber of bytes
and then compare them against the number of bytes which were sent.
Therefore, system call recv() must not return before receiving the
requested number of bytes, otherwise the subsequent memcmp() fails.
This patch passes MSG_WAITALL flag to recv() so that it does not return
prematurely before requested number of bytes are copied to receive
buffer.

Signed-off-by: Vakul Garg <vakul.garg@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tls.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 8fdfeafaf8c00..7549d39ccafff 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -288,7 +288,7 @@ TEST_F(tls, splice_from_pipe)
 	ASSERT_GE(pipe(p), 0);
 	EXPECT_GE(write(p[1], mem_send, send_len), 0);
 	EXPECT_GE(splice(p[0], NULL, self->fd, NULL, send_len, 0), 0);
-	EXPECT_GE(recv(self->cfd, mem_recv, send_len, 0), 0);
+	EXPECT_EQ(recv(self->cfd, mem_recv, send_len, MSG_WAITALL), send_len);
 	EXPECT_EQ(memcmp(mem_send, mem_recv, send_len), 0);
 }
 
@@ -322,13 +322,13 @@ TEST_F(tls, send_and_splice)
 
 	ASSERT_GE(pipe(p), 0);
 	EXPECT_EQ(send(self->fd, test_str, send_len2, 0), send_len2);
-	EXPECT_NE(recv(self->cfd, buf, send_len2, 0), -1);
+	EXPECT_EQ(recv(self->cfd, buf, send_len2, MSG_WAITALL), send_len2);
 	EXPECT_EQ(memcmp(test_str, buf, send_len2), 0);
 
 	EXPECT_GE(write(p[1], mem_send, send_len), send_len);
 	EXPECT_GE(splice(p[0], NULL, self->fd, NULL, send_len, 0), send_len);
 
-	EXPECT_GE(recv(self->cfd, mem_recv, send_len, 0), 0);
+	EXPECT_EQ(recv(self->cfd, mem_recv, send_len, MSG_WAITALL), send_len);
 	EXPECT_EQ(memcmp(mem_send, mem_recv, send_len), 0);
 }
 
@@ -516,17 +516,17 @@ TEST_F(tls, recv_peek_multiple_records)
 	len = strlen(test_str_second) + 1;
 	EXPECT_EQ(send(self->fd, test_str_second, len, 0), len);
 
-	len = sizeof(buf);
+	len = strlen(test_str_first);
 	memset(buf, 0, len);
-	EXPECT_NE(recv(self->cfd, buf, len, MSG_PEEK), -1);
+	EXPECT_EQ(recv(self->cfd, buf, len, MSG_PEEK | MSG_WAITALL), len);
 
 	/* MSG_PEEK can only peek into the current record. */
-	len = strlen(test_str_first) + 1;
+	len = strlen(test_str_first);
 	EXPECT_EQ(memcmp(test_str_first, buf, len), 0);
 
-	len = sizeof(buf);
+	len = strlen(test_str) + 1;
 	memset(buf, 0, len);
-	EXPECT_NE(recv(self->cfd, buf, len, 0), -1);
+	EXPECT_EQ(recv(self->cfd, buf, len, MSG_WAITALL), len);
 
 	/* Non-MSG_PEEK will advance strparser (and therefore record)
 	 * however.
@@ -543,9 +543,9 @@ TEST_F(tls, recv_peek_multiple_records)
 	len = strlen(test_str_second) + 1;
 	EXPECT_EQ(send(self->fd, test_str_second, len, 0), len);
 
-	len = sizeof(buf);
+	len = strlen(test_str) + 1;
 	memset(buf, 0, len);
-	EXPECT_NE(recv(self->cfd, buf, len, MSG_PEEK), -1);
+	EXPECT_EQ(recv(self->cfd, buf, len, MSG_PEEK | MSG_WAITALL), len);
 
 	len = strlen(test_str) + 1;
 	EXPECT_EQ(memcmp(test_str, buf, len), 0);
-- 
2.20.1



