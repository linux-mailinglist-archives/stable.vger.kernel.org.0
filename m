Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795EC29BE99
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1794772AbgJ0Qwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:52:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794781AbgJ0PNb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:13:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6B5C20728;
        Tue, 27 Oct 2020 15:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811611;
        bh=nDTdg9vkigXJJd1FTB/cHEAatr2cCXwcOARRfxBsD1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kxNXLU/DMkMw1hJ+gzDHSYQ7HU2Gu963q0LK11W1SMaLVo26ezq79nTXzw8ulMFF4
         I+YY1JU3kaAN2kg4gPEk6dDSqOMOVdydXpPNGKIZnSrr3VPNaP99aCNnS5PwyQ/4gQ
         mNXEC66rnQ8EjNf0UuEb5n246lQC/o6i9NC3I2vk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brad Bishop <bradleyb@fuzziesquirrel.com>,
        Eddie James <eajames@linux.ibm.com>,
        Joel Stanley <joel@jms.id.au>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 547/633] spi: fsi: Fix clock running too fast
Date:   Tue, 27 Oct 2020 14:54:50 +0100
Message-Id: <20201027135548.452584804@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brad Bishop <bradleyb@fuzziesquirrel.com>

[ Upstream commit 0b546bbe9474ff23e6843916ad6d567f703b2396 ]

Use a clock divider tuned to a 200MHz FSI bus frequency (the maximum). Use
of the previous divider at 200MHz results in corrupt data from endpoint
devices. Ideally the clock divider would be calculated from the FSI clock,
but that would require some significant work on the FSI driver. With FSI
frequencies slower than 200MHz, the SPI clock will simply run slower, but
safely.

Signed-off-by: Brad Bishop <bradleyb@fuzziesquirrel.com>
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20200909222857.28653-3-eajames@linux.ibm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsi.c b/drivers/spi/spi-fsi.c
index ef5e0826a53c3..a702e9d7d68c0 100644
--- a/drivers/spi/spi-fsi.c
+++ b/drivers/spi/spi-fsi.c
@@ -403,7 +403,7 @@ static int fsi_spi_transfer_init(struct fsi_spi *ctx)
 	u64 status = 0ULL;
 	u64 wanted_clock_cfg = SPI_FSI_CLOCK_CFG_ECC_DISABLE |
 		SPI_FSI_CLOCK_CFG_SCK_NO_DEL |
-		FIELD_PREP(SPI_FSI_CLOCK_CFG_SCK_DIV, 4);
+		FIELD_PREP(SPI_FSI_CLOCK_CFG_SCK_DIV, 19);
 
 	end = jiffies + msecs_to_jiffies(SPI_FSI_INIT_TIMEOUT_MS);
 	do {
-- 
2.25.1



