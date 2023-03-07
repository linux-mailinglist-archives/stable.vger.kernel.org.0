Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0545E6AEF97
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbjCGSYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231407AbjCGSYI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:24:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447D699668
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:19:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7D29B8184E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD00C433D2;
        Tue,  7 Mar 2023 18:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213177;
        bh=iTw/78BSAVpQZvd+pK66e2spGCGmHFO/fPM0Sq5d/68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mdEWel26t92MmK2L7bGtcEkGdZo2co7z2fhb9zAH/lvWKCPmeO89qKWKBvK3YT2lF
         dtlMce6gdkYfD7iLMbrYwcHEus2G/j1Au0nB2DUD6KyN1fyKxt2cTSdx8B134rTqSZ
         5Mgi8jSRJFUZYY2TvdWoCh+woG+gIY96U4pWdOP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 406/885] dmaengine: HISI_DMA should depend on ARCH_HISI
Date:   Tue,  7 Mar 2023 17:55:40 +0100
Message-Id: <20230307170020.045905196@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit dcca9d045c0852584ad092123c7f6e6526a633b1 ]

The HiSilicon DMA Engine is only present on HiSilicon SoCs.  Hence add a
dependency on ARCH_HISI, to prevent asking the user about this driver
when configuring a kernel without HiSilicon SoC support.

Fixes: e9f08b65250d73ab ("dmaengine: hisilicon: Add Kunpeng DMA engine support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/363a1816d36cd3cf604d88ec90f97c75f604de64.1669044190.git.geert+renesas@glider.be
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 7524b62a8870a..b64ae02c26f8c 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -244,7 +244,7 @@ config FSL_RAID
 
 config HISI_DMA
 	tristate "HiSilicon DMA Engine support"
-	depends on ARM64 || COMPILE_TEST
+	depends on ARCH_HISI || COMPILE_TEST
 	depends on PCI_MSI
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
-- 
2.39.2



