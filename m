Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99C5E111FC5
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbfLCWi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:38:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:47544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727989AbfLCWi1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:38:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4516120684;
        Tue,  3 Dec 2019 22:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412706;
        bh=OctZyAQ5oT6et3iOr6pcJzgVHWL+2dgefaniPGCIhEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nd7CmYGKyWA6t3DrZNGF+jyzW1Abftz5XXErXT7T+6giZkquG6Vvf62mCYBRk2Ezb
         gtPopFe/IHDDH7J2joI0fv7Jvn5Hx3cU0rpS4BSGk32TDeoZTjm9b9StJnrtLWgWJ2
         IaaCJICQ6Svxw6hcuJDoEEFwo+dI5uufGZ3lrgC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 32/46] selftests/tls: add a test for fragmented messages
Date:   Tue,  3 Dec 2019 23:35:52 +0100
Message-Id: <20191203212749.716161553@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203212705.175425505@linuxfoundation.org>
References: <20191203212705.175425505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 65190f77424d7b82c4aad7326c9cce6bd91a2fcc ]

Add a sendmsg test with very fragmented messages. This should
fill up sk_msg and test the boundary conditions.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/tls.c |   60 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -268,6 +268,38 @@ TEST_F(tls, sendmsg_single)
 	EXPECT_EQ(memcmp(buf, test_str, send_len), 0);
 }
 
+#define MAX_FRAGS	64
+#define SEND_LEN	13
+TEST_F(tls, sendmsg_fragmented)
+{
+	char const *test_str = "test_sendmsg";
+	char buf[SEND_LEN * MAX_FRAGS];
+	struct iovec vec[MAX_FRAGS];
+	struct msghdr msg;
+	int i, frags;
+
+	for (frags = 1; frags <= MAX_FRAGS; frags++) {
+		for (i = 0; i < frags; i++) {
+			vec[i].iov_base = (char *)test_str;
+			vec[i].iov_len = SEND_LEN;
+		}
+
+		memset(&msg, 0, sizeof(struct msghdr));
+		msg.msg_iov = vec;
+		msg.msg_iovlen = frags;
+
+		EXPECT_EQ(sendmsg(self->fd, &msg, 0), SEND_LEN * frags);
+		EXPECT_EQ(recv(self->cfd, buf, SEND_LEN * frags, MSG_WAITALL),
+			  SEND_LEN * frags);
+
+		for (i = 0; i < frags; i++)
+			EXPECT_EQ(memcmp(buf + SEND_LEN * i,
+					 test_str, SEND_LEN), 0);
+	}
+}
+#undef MAX_FRAGS
+#undef SEND_LEN
+
 TEST_F(tls, sendmsg_large)
 {
 	void *mem = malloc(16384);
@@ -694,6 +726,34 @@ TEST_F(tls, recv_lowat)
 	EXPECT_EQ(memcmp(send_mem, recv_mem + 10, 5), 0);
 }
 
+TEST_F(tls, recv_rcvbuf)
+{
+	char send_mem[4096];
+	char recv_mem[4096];
+	int rcv_buf = 1024;
+
+	memset(send_mem, 0x1c, sizeof(send_mem));
+
+	EXPECT_EQ(setsockopt(self->cfd, SOL_SOCKET, SO_RCVBUF,
+			     &rcv_buf, sizeof(rcv_buf)), 0);
+
+	EXPECT_EQ(send(self->fd, send_mem, 512, 0), 512);
+	memset(recv_mem, 0, sizeof(recv_mem));
+	EXPECT_EQ(recv(self->cfd, recv_mem, sizeof(recv_mem), 0), 512);
+	EXPECT_EQ(memcmp(send_mem, recv_mem, 512), 0);
+
+	if (self->notls)
+		return;
+
+	EXPECT_EQ(send(self->fd, send_mem, 4096, 0), 4096);
+	memset(recv_mem, 0, sizeof(recv_mem));
+	EXPECT_EQ(recv(self->cfd, recv_mem, sizeof(recv_mem), 0), -1);
+	EXPECT_EQ(errno, EMSGSIZE);
+
+	EXPECT_EQ(recv(self->cfd, recv_mem, sizeof(recv_mem), 0), -1);
+	EXPECT_EQ(errno, EMSGSIZE);
+}
+
 TEST_F(tls, bidir)
 {
 	char const *test_str = "test_read";


