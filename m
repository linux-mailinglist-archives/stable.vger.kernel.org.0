Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF30579A8F
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239058AbiGSMPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239673AbiGSMOz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:14:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8FE53D26;
        Tue, 19 Jul 2022 05:05:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FDAC6163C;
        Tue, 19 Jul 2022 12:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0001FC341CA;
        Tue, 19 Jul 2022 12:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232345;
        bh=DAD+Pjwh8/AMSXxjKUmXsLwsZvgalbFQCH6aTqtkqc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SfAU/Ki1FMI4hUsR6uzGFjCKat1emWo5crystVE+D2rmXe5905aLVNuKa6Rw+rPXI
         kI7ZDPqzakuSGXd1Pt5+sSroo/3BwXvUPjhm7+7L2PHuNWP3+HQoLGuhcwhewpbhOQ
         PzbVIgF5foMXePJGXaUjJuTJ8s/xP5m4He6DPXYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anastasios Vacharakis <vacharakis@o2mail.de>,
        Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/112] spi: amd: Limit max transfer and message size
Date:   Tue, 19 Jul 2022 13:53:19 +0200
Message-Id: <20220719114628.562665124@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
References: <20220719114626.156073229@linuxfoundation.org>
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
index 7f629544060d..a027cfd49df8 100644
--- a/drivers/spi/spi-amd.c
+++ b/drivers/spi/spi-amd.c
@@ -28,6 +28,7 @@
 #define AMD_SPI_RX_COUNT_REG	0x4B
 #define AMD_SPI_STATUS_REG	0x4C
 
+#define AMD_SPI_FIFO_SIZE	70
 #define AMD_SPI_MEM_SIZE	200
 
 /* M_CMD OP codes for SPI */
@@ -245,6 +246,11 @@ static int amd_spi_master_transfer(struct spi_master *master,
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
@@ -278,6 +284,8 @@ static int amd_spi_probe(struct platform_device *pdev)
 	master->flags = SPI_MASTER_HALF_DUPLEX;
 	master->setup = amd_spi_master_setup;
 	master->transfer_one_message = amd_spi_master_transfer;
+	master->max_transfer_size = amd_spi_max_transfer_size;
+	master->max_message_size = amd_spi_max_transfer_size;
 
 	/* Register the controller with SPI framework */
 	err = devm_spi_register_master(dev, master);
-- 
2.35.1



