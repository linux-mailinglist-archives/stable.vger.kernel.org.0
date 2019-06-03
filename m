Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD0F532C09
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbfFCJOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:14:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728967AbfFCJOO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:14:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7B2D27ED4;
        Mon,  3 Jun 2019 09:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553253;
        bh=iiiQ/w7bDO3+K3ZoIcH7I7ymiXEuXiarUgk1wffJPo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RqxQC2OXHWyt40Hx9G7y/86juce1H1NWJgLGyBeBCenAXEwYqdeZNFgn6nMKiYqfA
         LeayPDSzSp3qJFo4EsJS7HS0R/uMsYXDiU85UbUc7i8Xp5SlsfGffSeorWDkHwM4U+
         yHmjf7IgHdJ2V3tzGKTfw8wlFrWvcvDGO+CX91Vs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 33/40] selftests/tls: add test for sleeping even though there is data
Date:   Mon,  3 Jun 2019 11:09:26 +0200
Message-Id: <20190603090524.555722482@linuxfoundation.org>
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

[ Upstream commit 043556d0917a1a5ea58795fe1656a2bce06d2649 ]

Add a test which sends 15 bytes of data, and then tries
to read 10 byes twice.  Previously the second read would
sleep indifinitely, since the record was already decrypted
and there is only 5 bytes left, not full 10.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/tls.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -442,6 +442,21 @@ TEST_F(tls, multiple_send_single_recv)
 	EXPECT_EQ(memcmp(send_mem, recv_mem + send_len, send_len), 0);
 }
 
+TEST_F(tls, single_send_multiple_recv_non_align)
+{
+	const unsigned int total_len = 15;
+	const unsigned int recv_len = 10;
+	char recv_mem[recv_len * 2];
+	char send_mem[total_len];
+
+	EXPECT_GE(send(self->fd, send_mem, total_len, 0), 0);
+	memset(recv_mem, 0, total_len);
+
+	EXPECT_EQ(recv(self->cfd, recv_mem, recv_len, 0), recv_len);
+	EXPECT_EQ(recv(self->cfd, recv_mem + recv_len, recv_len, 0), 5);
+	EXPECT_EQ(memcmp(send_mem, recv_mem, total_len), 0);
+}
+
 TEST_F(tls, recv_partial)
 {
 	char const *test_str = "test_read_partial";


