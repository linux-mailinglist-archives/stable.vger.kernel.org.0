Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726DA272F8F
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729768AbgIUQ6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:58:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728380AbgIUQmN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:42:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05B7A23976;
        Mon, 21 Sep 2020 16:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706532;
        bh=E2UGo2sQGtP/cvqzed6Qm48vWtNdhAPdX997cI1qKDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HHlV0FKMOqKJUpBwCkk1oOLxsGr5o8g4/whxJgpH7VBCznWGGUwr3t3bZG/8p9SCe
         Ui69Rsf7EZvONaBWig2f7EtDvE2mD2WWo8784lN69OCiqNTxVt+GDM/zLJRVlALhFV
         5aLYUhvmeCfrBZEYf0d1gtgjo3eAhFSYt+wOxlD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 14/49] spi: spi-loopback-test: Fix out-of-bounds read
Date:   Mon, 21 Sep 2020 18:27:58 +0200
Message-Id: <20200921162035.286175398@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162034.660953761@linuxfoundation.org>
References: <20200921162034.660953761@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit 837ba18dfcd4db21ad58107c65bfe89753aa56d7 ]

The "tx/rx-transfer - crossing PAGE_SIZE" test always fails when
len=131071 and rx_offset >= 5:

 spi-loopback-test spi0.0: Running test tx/rx-transfer - crossing PAGE_SIZE
 ...
   with iteration values: len = 131071, tx_off = 0, rx_off = 3
   with iteration values: len = 131071, tx_off = 0, rx_off = 4
   with iteration values: len = 131071, tx_off = 0, rx_off = 5
 loopback strangeness - rx changed outside of allowed range at: ...a4321000
   spi_msg@ffffffd5a4157690
     frame_length:  131071
     actual_length: 131071
     spi_transfer@ffffffd5a41576f8
       len:    131071
       tx_buf: ffffffd5a4340ffc

Note that rx_offset > 3 can only occur if the SPI controller driver sets
->dma_alignment to a higher value than 4, so most SPI controller drivers
are not affect.

The allocated Rx buffer is of size SPI_TEST_MAX_SIZE_PLUS, which is 132
KiB (assuming 4 KiB pages).  This test uses an initial offset into the
rx_buf of PAGE_SIZE - 4, and a len of 131071, so the range expected to
be written in this transfer ends at (4096 - 4) + 5 + 131071 == 132 KiB,
which is also the end of the allocated buffer.  But the code which
verifies the content of the buffer reads a byte beyond the allocated
buffer and spuriously fails because this out-of-bounds read doesn't
return the expected value.

Fix this by using ITERATE_LEN instead of ITERATE_MAX_LEN to avoid
testing sizes which cause out-of-bounds reads.

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Link: https://lore.kernel.org/r/20200902132341.7079-1-vincent.whitchurch@axis.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-loopback-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-loopback-test.c b/drivers/spi/spi-loopback-test.c
index bed7403bb6b3a..b9a7117b6dce3 100644
--- a/drivers/spi/spi-loopback-test.c
+++ b/drivers/spi/spi-loopback-test.c
@@ -99,7 +99,7 @@ static struct spi_test spi_tests[] = {
 	{
 		.description	= "tx/rx-transfer - crossing PAGE_SIZE",
 		.fill_option	= FILL_COUNT_8,
-		.iterate_len    = { ITERATE_MAX_LEN },
+		.iterate_len    = { ITERATE_LEN },
 		.iterate_tx_align = ITERATE_ALIGN,
 		.iterate_rx_align = ITERATE_ALIGN,
 		.transfer_count = 1,
-- 
2.25.1



