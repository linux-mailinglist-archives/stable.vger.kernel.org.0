Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223E96501CB
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbiLRQfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232020AbiLRQeI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:34:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5C8E009;
        Sun, 18 Dec 2022 08:12:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD831B80BA4;
        Sun, 18 Dec 2022 16:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4469EC433D2;
        Sun, 18 Dec 2022 16:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379973;
        bh=5+ZQXrFg6ZmJxZDs0YrFxEzV/Yh9SfNFj2b9O/xjFBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mSjEpQVVxY4LRwS16dxhipkH7QnaNw9HpinVoWw4FY2B8+Tlm6s6GrcFFyggydkrz
         mcbQq9pTB0CaodOHz8B17dcv8HjcyJa9mcdYMw/cnpeiFPYPLD9wGnKBmMU9jxy6yw
         PcX3z1xJVqYzKvVJnvm49lJAiDGdMQA6ptu/YjXlZBUM+GJENP5pwstKVg76z3WAm2
         zD2MRxAR5Y9frjF/wdhhOdoPwQCciMLH6GniQ95phkqK825rt3bYfAwSr++cZlYIFh
         A8VZza3aPDfb3wGGJ76NjQNJ8jg0ssAX7I2Mj6fGDWMz/x9TOr13N/WRJai1fZrbNp
         LAkJZ44t7NfGA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Qian <ming.qian@nxp.com>,
        Mirela Rabulea <mirela.rabulea@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        shawnguo@kernel.org, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 02/46] media: imx-jpeg: Disable useless interrupt to avoid kernel panic
Date:   Sun, 18 Dec 2022 11:12:00 -0500
Message-Id: <20221218161244.930785-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218161244.930785-1-sashal@kernel.org>
References: <20221218161244.930785-1-sashal@kernel.org>
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
 drivers/media/platform/imx-jpeg/mxc-jpeg-hw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/imx-jpeg/mxc-jpeg-hw.c b/drivers/media/platform/imx-jpeg/mxc-jpeg-hw.c
index 718b7b08f93e..8936d5ce886c 100644
--- a/drivers/media/platform/imx-jpeg/mxc-jpeg-hw.c
+++ b/drivers/media/platform/imx-jpeg/mxc-jpeg-hw.c
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

