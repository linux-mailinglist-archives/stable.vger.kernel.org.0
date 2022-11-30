Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7869A63DE4C
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiK3Sfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:35:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbiK3Sfb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:35:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511639208A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:35:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2BD8B81C9F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A4EC433D6;
        Wed, 30 Nov 2022 18:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833327;
        bh=w0I30QUcwoacNhiW7A8I6u9hG4L3PLnzcvps8TLedZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBT4G5ebJ3BEzbA4gPEyMG78EEf8nec1B2Ta45T0MPLKg0kbsZxy1RaIxOpZvBNkj
         8f+DolOTfxeO82DhOx54GBdaEBAcafwX13S+xWAMRlPKM8LOYw4QQ5L8ig9cXHXy6A
         9/HRUZf/xI6oP/Qaw0JXk65dPNFZS+2wDDK5IqvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/206] spi: dw-dma: decrease reference count in dw_spi_dma_init_mfld()
Date:   Wed, 30 Nov 2022 19:21:58 +0100
Message-Id: <20221130180534.679179508@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit 804313b64e412a81b0b3389a10e7622452004aa6 ]

pci_get_device() will increase the reference count for the returned
pci_dev. Since 'dma_dev' is only used to filter the channel in
dw_spi_dma_chan_filer() after using it we need to call pci_dev_put() to
decrease the reference count. Also add pci_dev_put() for the error case.

Fixes: 7063c0d942a1 ("spi/dw_spi: add DMA support")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Acked-by: Serge Semin <fancer.lancer@gmail.com>
Link: https://lore.kernel.org/r/20221116093204.46700-1-wangxiongfeng2@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw-dma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi-dw-dma.c b/drivers/spi/spi-dw-dma.c
index a09831c62192..32ac8f9068e8 100644
--- a/drivers/spi/spi-dw-dma.c
+++ b/drivers/spi/spi-dw-dma.c
@@ -127,12 +127,15 @@ static int dw_spi_dma_init_mfld(struct device *dev, struct dw_spi *dws)
 
 	dw_spi_dma_sg_burst_init(dws);
 
+	pci_dev_put(dma_dev);
+
 	return 0;
 
 free_rxchan:
 	dma_release_channel(dws->rxchan);
 	dws->rxchan = NULL;
 err_exit:
+	pci_dev_put(dma_dev);
 	return -EBUSY;
 }
 
-- 
2.35.1



