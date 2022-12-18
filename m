Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B019964FF64
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbiLRQBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbiLRQBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:01:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6A755B1;
        Sun, 18 Dec 2022 08:01:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7509BB80B4A;
        Sun, 18 Dec 2022 16:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF66C433EF;
        Sun, 18 Dec 2022 16:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379308;
        bh=AJg30lQM+3uKhnVTxpxBj1HiLwsVIJR8eAyQmiDceYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U/lFchjfmMiQ9ZyIcJ1+cW7YNEQXm/nUSSIEOx7UKaBndQJjEWwQKQQHAotnAsb+y
         6JAvIsazOShaRjabIYXi8UushGeCrsh9k2FcCWJk0ga0up5VsB10/5pryPaKUBE55U
         QOiW4tilqhM67Fr2hD1e8d0UPzAMQ/kvszPSHSTwsWZe1xHQSIt0owG2Ho0xmp894z
         FtBQ9iK1augQqli+iv7kRw/ofOX5MyuQFJUVgw9dYYIllSyvR0d6hhqvJJJIpKnpNl
         Pqan1Evx/KUU1JtsxW2HUsQen0CRQ8rNaQ7edEUWvmRS53yGM0hZjz/vF6AXLz2k7E
         2RFDBdkEhZO5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Qian <ming.qian@nxp.com>,
        Mirela Rabulea <mirela.rabulea@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        shawnguo@kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.1 02/85] media: imx-jpeg: Disable useless interrupt to avoid kernel panic
Date:   Sun, 18 Dec 2022 11:00:19 -0500
Message-Id: <20221218160142.925394-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160142.925394-1-sashal@kernel.org>
References: <20221218160142.925394-1-sashal@kernel.org>
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

