Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B237620D166
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 20:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgF2Slm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:41:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbgF2Slc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:41:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB48F23ECE;
        Mon, 29 Jun 2020 15:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443901;
        bh=ooaYo2UWxBuWMktj2MkFM4Eulu1UWspFb8hoIGx+cj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A+KVZViAIDeJ6Das8WNnMJ8WJpD+ALcYd5yMt+/LrqttKoe5+qpivajAFARbJ337i
         BjsnBMq1Z+qCaQ5eCgobZjf17EEzfOLJfepkJJxxD2T1mgmMWemqc+NmkwDOZWX750
         vjpPr42T3g75/mYEn/Q8TqQ822Ea07nf5VGkaQLk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 001/265] spi: spi-fsl-dspi: Free DMA memory with matching function
Date:   Mon, 29 Jun 2020 11:13:54 -0400
Message-Id: <20200629151818.2493727-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

commit 03fe7aaf0c3d40ef7feff2bdc7180c146989586a upstream.

Driver allocates DMA memory with dma_alloc_coherent() but frees it with
dma_unmap_single().

This causes DMA warning during system shutdown (with DMA debugging) on
Toradex Colibri VF50 module:

    WARNING: CPU: 0 PID: 1 at ../kernel/dma/debug.c:1036 check_unmap+0x3fc/0xb04
    DMA-API: fsl-edma 40098000.dma-controller: device driver frees DMA memory with wrong function
      [device address=0x0000000087040000] [size=8 bytes] [mapped as coherent] [unmapped as single]
    Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
      (unwind_backtrace) from [<8010bb34>] (show_stack+0x10/0x14)
      (show_stack) from [<8011ced8>] (__warn+0xf0/0x108)
      (__warn) from [<8011cf64>] (warn_slowpath_fmt+0x74/0xb8)
      (warn_slowpath_fmt) from [<8017d170>] (check_unmap+0x3fc/0xb04)
      (check_unmap) from [<8017d900>] (debug_dma_unmap_page+0x88/0x90)
      (debug_dma_unmap_page) from [<80601d68>] (dspi_release_dma+0x88/0x110)
      (dspi_release_dma) from [<80601e4c>] (dspi_shutdown+0x5c/0x80)
      (dspi_shutdown) from [<805845f8>] (device_shutdown+0x17c/0x220)
      (device_shutdown) from [<80143ef8>] (kernel_restart+0xc/0x50)
      (kernel_restart) from [<801441cc>] (__do_sys_reboot+0x18c/0x210)
      (__do_sys_reboot) from [<80100060>] (ret_fast_syscall+0x0/0x28)
    DMA-API: Mapped at:
     dma_alloc_attrs+0xa4/0x130
     dspi_probe+0x568/0x7b4
     platform_drv_probe+0x6c/0xa4
     really_probe+0x208/0x348
     driver_probe_device+0x5c/0xb4

Fixes: 90ba37033cb9 ("spi: spi-fsl-dspi: Add DMA support for Vybrid")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1591803717-11218-1-git-send-email-krzk@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-fsl-dspi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 2e9f9adc59003..88176eaca448f 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -584,14 +584,14 @@ static void dspi_release_dma(struct fsl_dspi *dspi)
 		return;
 
 	if (dma->chan_tx) {
-		dma_unmap_single(dma->chan_tx->device->dev, dma->tx_dma_phys,
-				 dma_bufsize, DMA_TO_DEVICE);
+		dma_free_coherent(dma->chan_tx->device->dev, dma_bufsize,
+				  dma->tx_dma_buf, dma->tx_dma_phys);
 		dma_release_channel(dma->chan_tx);
 	}
 
 	if (dma->chan_rx) {
-		dma_unmap_single(dma->chan_rx->device->dev, dma->rx_dma_phys,
-				 dma_bufsize, DMA_FROM_DEVICE);
+		dma_free_coherent(dma->chan_rx->device->dev, dma_bufsize,
+				  dma->rx_dma_buf, dma->rx_dma_phys);
 		dma_release_channel(dma->chan_rx);
 	}
 }
-- 
2.25.1

