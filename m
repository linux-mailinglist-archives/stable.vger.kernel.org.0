Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F9E579D62
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241923AbiGSMvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242252AbiGSMt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:49:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31BE59254;
        Tue, 19 Jul 2022 05:19:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 228CFB81B2C;
        Tue, 19 Jul 2022 12:19:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B642C341C6;
        Tue, 19 Jul 2022 12:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233193;
        bh=yHoAhGSzQVhcwIArIP2AxbzqpTlGQtXQw1uz9/g2c+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MhgpnETywlEDY7VqMtEZhzvS8iDEH8HVXUGwDLui7CH1vdcULevJlmjG3memq2Ld7
         fJuywl3HkFzEHchT7Ib3Rpa6X7jAlOEUWpsBStEtdjqytNrIpLEYuWx8G9YiPJErX8
         PM9kJz9HKOnj1YiYdrMCRFMb1ftEeav7NlSIXfXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anastasios Vacharakis <vacharakis@o2mail.de>,
        Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 039/231] spi: amd: Limit max transfer and message size
Date:   Tue, 19 Jul 2022 13:52:04 +0200
Message-Id: <20220719114717.498118965@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 6ece49c56965544262523dae4a071ace3db63507 ]

Enabling the SPI CS35L41 audio codec driver for Steam Deck [1]
revealed a problem with the current AMD SPI controller driver
implementation, consisting of an unrecoverable system hang.

The issue can be prevented if we ensure the max transfer size
and the max message size do not exceed the FIFO buffer size.

According to the implementation of the downstream driver, the
AMD SPI controller is not able to handle more than 70 bytes per
transfer, which corresponds to the size of the FIFO buffer.

Hence, let's fix this by setting the SPI limits mentioned above.

[1] https://lore.kernel.org/r/20220621213819.262537-1-cristian.ciocaltea@collabora.com

Reported-by: Anastasios Vacharakis <vacharakis@o2mail.de>
Fixes: bbb336f39efc ("spi: spi-amd: Add AMD SPI controller driver support")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://lore.kernel.org/r/20220706100626.1234731-2-cristian.ciocaltea@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-amd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/spi/spi-amd.c b/drivers/spi/spi-amd.c
index cba6a4486c24..efdcbe6c4c26 100644
--- a/drivers/spi/spi-amd.c
+++ b/drivers/spi/spi-amd.c
@@ -33,6 +33,7 @@
 #define AMD_SPI_RX_COUNT_REG	0x4B
 #define AMD_SPI_STATUS_REG	0x4C
 
+#define AMD_SPI_FIFO_SIZE	70
 #define AMD_SPI_MEM_SIZE	200
 
 /* M_CMD OP codes for SPI */
@@ -270,6 +271,11 @@ static int amd_spi_master_transfer(struct spi_master *master,
 	return 0;
 }
 
+static size_t amd_spi_max_transfer_size(struct spi_device *spi)
+{
+	return AMD_SPI_FIFO_SIZE;
+}
+
 static int amd_spi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -302,6 +308,8 @@ static int amd_spi_probe(struct platform_device *pdev)
 	master->flags = SPI_MASTER_HALF_DUPLEX;
 	master->setup = amd_spi_master_setup;
 	master->transfer_one_message = amd_spi_master_transfer;
+	master->max_transfer_size = amd_spi_max_transfer_size;
+	master->max_message_size = amd_spi_max_transfer_size;
 
 	/* Register the controller with SPI framework */
 	err = devm_spi_register_master(dev, master);
-- 
2.35.1



