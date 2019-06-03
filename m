Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8276232C04
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbfFCJNz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:13:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728164AbfFCJNw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:13:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B00621952;
        Mon,  3 Jun 2019 09:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553232;
        bh=8Az0AwzX3b9nGOZ0VZTWq+bLJqd5hRLz7w6L96IVQRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=roSy1h4c2vLItvn8AkKdrJheDKEg7AM0MaN7xX0E18CA05ah9kBGLKWgYXm61su6A
         GN+7Wr3+o55Uu28nZltXL6R6YUiQz1djYVSycTrh3/vfSdQu9M90R3RZZMuoeUrmYC
         4pyD1IDhH3kt4pvCN4sotoaKQENd91jcCfRxVsUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 31/40] selftests/tls: test for lowat overshoot with multiple records
Date:   Mon,  3 Jun 2019 11:09:24 +0200
Message-Id: <20190603090524.461355889@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090522.617635820@linuxfoundation.org>
References: <20190603090522.617635820@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 7718a855cd7ae9fc27a2aa1532ee105d52eb7634 ]

Set SO_RCVLOWAT and test it gets respected when gathering
data from multiple records.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/tls.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -575,6 +575,25 @@ TEST_F(tls, recv_peek_large_buf_mult_rec
 	EXPECT_EQ(memcmp(test_str, buf, len), 0);
 }
 
+TEST_F(tls, recv_lowat)
+{
+	char send_mem[10] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };
+	char recv_mem[20];
+	int lowat = 8;
+
+	EXPECT_EQ(send(self->fd, send_mem, 10, 0), 10);
+	EXPECT_EQ(send(self->fd, send_mem, 5, 0), 5);
+
+	memset(recv_mem, 0, 20);
+	EXPECT_EQ(setsockopt(self->cfd, SOL_SOCKET, SO_RCVLOWAT,
+			     &lowat, sizeof(lowat)), 0);
+	EXPECT_EQ(recv(self->cfd, recv_mem, 1, MSG_WAITALL), 1);
+	EXPECT_EQ(recv(self->cfd, recv_mem + 1, 6, MSG_WAITALL), 6);
+	EXPECT_EQ(recv(self->cfd, recv_mem + 7, 10, 0), 8);
+
+	EXPECT_EQ(memcmp(send_mem, recv_mem, 10), 0);
+	EXPECT_EQ(memcmp(send_mem, recv_mem + 10, 5), 0);
+}
 
 TEST_F(tls, pollin)
 {


