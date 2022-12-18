Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E43386500CE
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbiLRQTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:19:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbiLRQRx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:17:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB50811C11;
        Sun, 18 Dec 2022 08:07:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59D8460DC8;
        Sun, 18 Dec 2022 16:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9065C433F1;
        Sun, 18 Dec 2022 16:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379665;
        bh=AJg30lQM+3uKhnVTxpxBj1HiLwsVIJR8eAyQmiDceYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u29djQgzkddmftc7IT2sYsHvuEeoWS/ChbHG4Y6HFUGF5abaDgyhRRaa+Iwlni0OW
         gDQjP7opaM7DEU2hE1f1AQ1JEgHrmjMwkMrlBYW20/O4PpVdS9xJNdE8mKo+Qh6AwM
         JUlG5vdl7YiFYtBO5klupzasxZeJ8126/uZbmkpuKbuLanfkDbbNJFneKIFnkL1Ryf
         GrIkOPPbBPjwm0ysiIJU0leLk+XppR6yavyCM22BH0PR4ohXVdDCd53f/621nHBnBr
         KRNdIgWiHR/oO3TAx0OD1uR7zv+L9YnCSOpif8yt9G+mAIzOj4j+Z/bUgeumlBFjgM
         hvF7MIXvi6/Vg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Qian <ming.qian@nxp.com>,
        Mirela Rabulea <mirela.rabulea@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        shawnguo@kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 02/73] media: imx-jpeg: Disable useless interrupt to avoid kernel panic
Date:   Sun, 18 Dec 2022 11:06:30 -0500
Message-Id: <20221218160741.927862-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160741.927862-1-sashal@kernel.org>
References: <20221218160741.927862-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit c3720e65c9013a7b2a5dbb63e6bf6d74a35dd894 ]

There is a hardware bug that the interrupt STMBUF_HALF may be triggered
after or when disable interrupt.
It may led to unexpected kernel panic.
And interrupt STMBUF_HALF and STMBUF_RTND have no other effect.
So disable them and the unused interrupts.

meanwhile clear the interrupt status when disable interrupt.

Signed-off-by: Ming Qian <ming.qian@nxp.com>
Reviewed-by: Mirela Rabulea <mirela.rabulea@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.c b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.c
index 9418fcf740a8..ef28122a5ed4 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.c
@@ -76,12 +76,14 @@ void print_wrapper_info(struct device *dev, void __iomem *reg)
 
 void mxc_jpeg_enable_irq(void __iomem *reg, int slot)
 {
-	writel(0xFFFFFFFF, reg + MXC_SLOT_OFFSET(slot, SLOT_IRQ_EN));
+	writel(0xFFFFFFFF, reg + MXC_SLOT_OFFSET(slot, SLOT_STATUS));
+	writel(0xF0C, reg + MXC_SLOT_OFFSET(slot, SLOT_IRQ_EN));
 }
 
 void mxc_jpeg_disable_irq(void __iomem *reg, int slot)
 {
 	writel(0x0, reg + MXC_SLOT_OFFSET(slot, SLOT_IRQ_EN));
+	writel(0xFFFFFFFF, reg + MXC_SLOT_OFFSET(slot, SLOT_STATUS));
 }
 
 void mxc_jpeg_sw_reset(void __iomem *reg)
-- 
2.35.1

