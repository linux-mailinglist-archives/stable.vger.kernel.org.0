Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47573C5419
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351329AbhGLH5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:57:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240075AbhGLHwh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:52:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FBC36117A;
        Mon, 12 Jul 2021 07:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076188;
        bh=Guh+s9liG/aVqNGwwFFHnMbyYB8Vwl30wTT8M6R8xZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bCWjZ4ZhYWO9g6AlarsJ61p5KXDfAc9eNG+5WWxSpCuZbSAUpR/9N2TOEOKZ83WEW
         j/gsWFK/xqfJ6m62PctdlzFH8Nc+96p9hKoLmWItjk2ZVk6HDbiEhdgBjhnhzlDLMg
         bAG4aKqSUP+XDIfx1MCEGoIGQdhlhjb1fEV1Cbuc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 519/800] selftests: tls: clean up uninitialized warnings
Date:   Mon, 12 Jul 2021 08:09:02 +0200
Message-Id: <20210712061022.465034304@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit baa00119d69e3318da8d99867fc1170ebddf09ce ]

A bunch of tests uses uninitialized stack memory as random
data to send. This is harmless but generates compiler warnings.
Explicitly init the buffers with random data.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Vadim Fedorenko <vfedorenko@novek.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tls.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 426d07875a48..58fea6eb588d 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -25,6 +25,18 @@
 #define TLS_PAYLOAD_MAX_LEN 16384
 #define SOL_TLS 282
 
+static void memrnd(void *s, size_t n)
+{
+	int *dword = s;
+	char *byte;
+
+	for (; n >= 4; n -= 4)
+		*dword++ = rand();
+	byte = (void *)dword;
+	while (n--)
+		*byte++ = rand();
+}
+
 FIXTURE(tls_basic)
 {
 	int fd, cfd;
@@ -308,6 +320,8 @@ TEST_F(tls, recv_max)
 	char recv_mem[TLS_PAYLOAD_MAX_LEN];
 	char buf[TLS_PAYLOAD_MAX_LEN];
 
+	memrnd(buf, sizeof(buf));
+
 	EXPECT_GE(send(self->fd, buf, send_len, 0), 0);
 	EXPECT_NE(recv(self->cfd, recv_mem, send_len, 0), -1);
 	EXPECT_EQ(memcmp(buf, recv_mem, send_len), 0);
@@ -588,6 +602,8 @@ TEST_F(tls, recvmsg_single_max)
 	struct iovec vec;
 	struct msghdr hdr;
 
+	memrnd(send_mem, sizeof(send_mem));
+
 	EXPECT_EQ(send(self->fd, send_mem, send_len, 0), send_len);
 	vec.iov_base = (char *)recv_mem;
 	vec.iov_len = TLS_PAYLOAD_MAX_LEN;
@@ -610,6 +626,8 @@ TEST_F(tls, recvmsg_multiple)
 	struct msghdr hdr;
 	int i;
 
+	memrnd(buf, sizeof(buf));
+
 	EXPECT_EQ(send(self->fd, buf, send_len, 0), send_len);
 	for (i = 0; i < msg_iovlen; i++) {
 		iov_base[i] = (char *)malloc(iov_len);
@@ -634,6 +652,8 @@ TEST_F(tls, single_send_multiple_recv)
 	char send_mem[TLS_PAYLOAD_MAX_LEN * 2];
 	char recv_mem[TLS_PAYLOAD_MAX_LEN * 2];
 
+	memrnd(send_mem, sizeof(send_mem));
+
 	EXPECT_GE(send(self->fd, send_mem, total_len, 0), 0);
 	memset(recv_mem, 0, total_len);
 
-- 
2.30.2



