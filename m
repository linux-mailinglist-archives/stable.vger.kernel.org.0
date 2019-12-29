Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF14012C8E2
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387477AbfL2R6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:58:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:49128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387469AbfL2R6K (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:58:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F696208C4;
        Sun, 29 Dec 2019 17:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642290;
        bh=psl8kJoeKTkFyv9dkoUnqIpetpwk3tdC55aWKYKxqUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hZrgJ9GAXsrk/I5CGO6P/WOV5X18X5asQ8Su8HgvlmTmitKzQWAAREpXi/K7B4YA2
         ztZZGIpQXHfhYFSi5MOpok375WX3eMKYkSpRLgghUX1lB0O7StLV22gB9oLawquTqk
         JsckQ39ymAfYLYgnifpW4P7qcrAHVPnVGP9sStZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Pisati <paolo.pisati@canonical.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 378/434] selftests: net: tls: remove recv_rcvbuf test
Date:   Sun, 29 Dec 2019 18:27:11 +0100
Message-Id: <20191229172727.211163615@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

[ Upstream commit 6dd504b0fd1039c6e5d391e97cf5c4ee592aefcb ]

This test only works when [1] is applied, which was rejected.

Basically, the errors are reported and cleared. In this particular case of
tls sockets, following reads will block.

The test case was originally submitted with the rejected patch, but, then,
was included as part of a different patchset, possibly by mistake.

[1] https://lore.kernel.org/netdev/20191007035323.4360-2-jakub.kicinski@netronome.com/#t

Thanks Paolo Pisati for pointing out the original patchset where this
appeared.

Fixes: 65190f77424d (selftests/tls: add a test for fragmented messages)
Reported-by: Paolo Pisati <paolo.pisati@canonical.com>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tls.c | 28 ----------------------------
 1 file changed, 28 deletions(-)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 13e5ef615026..0ea44d975b6c 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -722,34 +722,6 @@ TEST_F(tls, recv_lowat)
 	EXPECT_EQ(memcmp(send_mem, recv_mem + 10, 5), 0);
 }
 
-TEST_F(tls, recv_rcvbuf)
-{
-	char send_mem[4096];
-	char recv_mem[4096];
-	int rcv_buf = 1024;
-
-	memset(send_mem, 0x1c, sizeof(send_mem));
-
-	EXPECT_EQ(setsockopt(self->cfd, SOL_SOCKET, SO_RCVBUF,
-			     &rcv_buf, sizeof(rcv_buf)), 0);
-
-	EXPECT_EQ(send(self->fd, send_mem, 512, 0), 512);
-	memset(recv_mem, 0, sizeof(recv_mem));
-	EXPECT_EQ(recv(self->cfd, recv_mem, sizeof(recv_mem), 0), 512);
-	EXPECT_EQ(memcmp(send_mem, recv_mem, 512), 0);
-
-	if (self->notls)
-		return;
-
-	EXPECT_EQ(send(self->fd, send_mem, 4096, 0), 4096);
-	memset(recv_mem, 0, sizeof(recv_mem));
-	EXPECT_EQ(recv(self->cfd, recv_mem, sizeof(recv_mem), 0), -1);
-	EXPECT_EQ(errno, EMSGSIZE);
-
-	EXPECT_EQ(recv(self->cfd, recv_mem, sizeof(recv_mem), 0), -1);
-	EXPECT_EQ(errno, EMSGSIZE);
-}
-
 TEST_F(tls, bidir)
 {
 	char const *test_str = "test_read";
-- 
2.20.1



