Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1086D25A7
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388224AbfJJIk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:40:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388223AbfJJIk6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:40:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE3B32054F;
        Thu, 10 Oct 2019 08:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696857;
        bh=YCv08OtIP8ALu1K/EyVpY57KtMBqX6VgQaWNOZT7QrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z6yeVNSs6AaQKAHGHH2qM+ywMTj6c5L6385PdBrlxAf/VMBv36n3xBi87GLP6OPAz
         v/c6+D3JWlNCazjAtLU5hYiJgIsSoaXZ7IJj3Si2FXrUpBNUceCGpVxo0GtK7w6n00
         m9lEEnufom0u/hRXp6AsnbkIKIZeUn7UofGo82uM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.3 076/148] mmc: sdhci-of-esdhc: set DMA snooping based on DMA coherence
Date:   Thu, 10 Oct 2019 10:35:37 +0200
Message-Id: <20191010083615.965680999@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

commit 121bd08b029e03404c451bb237729cdff76eafed upstream.

We must not unconditionally set the DMA snoop bit; if the DMA API is
assuming that the device is not DMA coherent, and the device snoops the
CPU caches, the device can see stale cache lines brought in by
speculative prefetch.

This leads to the device seeing stale data, potentially resulting in
corrupted data transfers.  Commonly, this results in a descriptor fetch
error such as:

mmc0: ADMA error
mmc0: sdhci: ============ SDHCI REGISTER DUMP ===========
mmc0: sdhci: Sys addr:  0x00000000 | Version:  0x00002202
mmc0: sdhci: Blk size:  0x00000008 | Blk cnt:  0x00000001
mmc0: sdhci: Argument:  0x00000000 | Trn mode: 0x00000013
mmc0: sdhci: Present:   0x01f50008 | Host ctl: 0x00000038
mmc0: sdhci: Power:     0x00000003 | Blk gap:  0x00000000
mmc0: sdhci: Wake-up:   0x00000000 | Clock:    0x000040d8
mmc0: sdhci: Timeout:   0x00000003 | Int stat: 0x00000001
mmc0: sdhci: Int enab:  0x037f108f | Sig enab: 0x037f108b
mmc0: sdhci: ACmd stat: 0x00000000 | Slot int: 0x00002202
mmc0: sdhci: Caps:      0x35fa0000 | Caps_1:   0x0000af00
mmc0: sdhci: Cmd:       0x0000333a | Max curr: 0x00000000
mmc0: sdhci: Resp[0]:   0x00000920 | Resp[1]:  0x001d8a33
mmc0: sdhci: Resp[2]:   0x325b5900 | Resp[3]:  0x3f400e00
mmc0: sdhci: Host ctl2: 0x00000000
mmc0: sdhci: ADMA Err:  0x00000009 | ADMA Ptr: 0x000000236d43820c
mmc0: sdhci: ============================================
mmc0: error -5 whilst initialising SD card

but can lead to other errors, and potentially direct the SDHCI
controller to read/write data to other memory locations (e.g. if a valid
descriptor is visible to the device in a stale cache line.)

Fix this by ensuring that the DMA snoop bit corresponds with the
behaviour of the DMA API.  Since the driver currently only supports DT,
use of_dma_is_coherent().  Note that device_get_dma_attr() can not be
used as that risks re-introducing this bug if/when the driver is
converted to ACPI.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-of-esdhc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -495,7 +495,12 @@ static int esdhc_of_enable_dma(struct sd
 		dma_set_mask_and_coherent(dev, DMA_BIT_MASK(40));
 
 	value = sdhci_readl(host, ESDHC_DMA_SYSCTL);
-	value |= ESDHC_DMA_SNOOP;
+
+	if (of_dma_is_coherent(dev->of_node))
+		value |= ESDHC_DMA_SNOOP;
+	else
+		value &= ~ESDHC_DMA_SNOOP;
+
 	sdhci_writel(host, value, ESDHC_DMA_SYSCTL);
 	return 0;
 }


