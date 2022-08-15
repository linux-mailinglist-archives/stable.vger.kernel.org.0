Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22DCF59478E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241164AbiHOXmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353659AbiHOXjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:39:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDC6153D3C;
        Mon, 15 Aug 2022 13:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B620B80EA9;
        Mon, 15 Aug 2022 20:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2209C433D6;
        Mon, 15 Aug 2022 20:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594210;
        bh=WTlqPFfrZvu1SVl3BDbBSZq5wF8+vw4pET+mwT6EseM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pbea4ZM61uI7y2Yj0+cHRUu31Uv/GY2J1TC7cELyst94U8WwaPW7NuSy3Oz+BG9eP
         Yd/TzPj/0mJ/vhUB4HogzqTUmDR2tOB285vUqcPFiIjK/Kj100lf/omxaBalIZnMpl
         8kQFn7XAC6QbOXqx7if7sS1aaMeOOc3Z2bcuDvc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Mirela Rabulea <mirela.rabulea@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0395/1157] media: imx-jpeg: Disable slot interrupt when frame done
Date:   Mon, 15 Aug 2022 19:55:51 +0200
Message-Id: <20220815180455.483633379@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 22a2bc88c139dc9757bdb1d0a3665ac27edc79a5 ]

The interrupt STMBUF_HALF may be triggered after frame done.
It may led to system hang if driver try to access the register after
power off.

Disable the slot interrupt when frame done.

Fixes: 2db16c6ed72ce ("media: imx-jpeg: Add V4L2 driver for i.MX8 JPEG Encoder/Decoder")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Reviewed-by: Mirela Rabulea <mirela.rabulea@nxp.com>
Tested-by: Mirela Rabulea <mirela.rabulea@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.c |  5 +++++
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.h |  1 +
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c    | 10 ++--------
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.c b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.c
index 29c604b1b179..718b7b08f93e 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.c
@@ -79,6 +79,11 @@ void mxc_jpeg_enable_irq(void __iomem *reg, int slot)
 	writel(0xFFFFFFFF, reg + MXC_SLOT_OFFSET(slot, SLOT_IRQ_EN));
 }
 
+void mxc_jpeg_disable_irq(void __iomem *reg, int slot)
+{
+	writel(0x0, reg + MXC_SLOT_OFFSET(slot, SLOT_IRQ_EN));
+}
+
 void mxc_jpeg_sw_reset(void __iomem *reg)
 {
 	/*
diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.h b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.h
index 5f64cbbe0fa9..645a24fe8bc1 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.h
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.h
@@ -125,6 +125,7 @@ u32 mxc_jpeg_get_offset(void __iomem *reg, int slot);
 void mxc_jpeg_enable_slot(void __iomem *reg, int slot);
 void mxc_jpeg_set_l_endian(void __iomem *reg, int le);
 void mxc_jpeg_enable_irq(void __iomem *reg, int slot);
+void mxc_jpeg_disable_irq(void __iomem *reg, int slot);
 int mxc_jpeg_set_input(void __iomem *reg, u32 in_buf, u32 bufsize);
 int mxc_jpeg_set_output(void __iomem *reg, u16 out_pitch, u32 out_buf,
 			u16 w, u16 h);
diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
index 9a2fb0dc77a4..35a7cb936653 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -593,15 +593,8 @@ static irqreturn_t mxc_jpeg_dec_irq(int irq, void *priv)
 	dev_dbg(dev, "Irq %d on slot %d.\n", irq, slot);
 
 	ctx = v4l2_m2m_get_curr_priv(jpeg->m2m_dev);
-	if (!ctx) {
-		dev_err(dev,
-			"Instance released before the end of transaction.\n");
-		/* soft reset only resets internal state, not registers */
-		mxc_jpeg_sw_reset(reg);
-		/* clear all interrupts */
-		writel(0xFFFFFFFF, reg + MXC_SLOT_OFFSET(slot, SLOT_STATUS));
+	if (WARN_ON(!ctx))
 		goto job_unlock;
-	}
 
 	if (slot != ctx->slot) {
 		/* TODO investigate when adding multi-instance support */
@@ -673,6 +666,7 @@ static irqreturn_t mxc_jpeg_dec_irq(int irq, void *priv)
 	buf_state = VB2_BUF_STATE_DONE;
 
 buffers_done:
+	mxc_jpeg_disable_irq(reg, ctx->slot);
 	jpeg->slot_data[slot].used = false; /* unused, but don't free */
 	mxc_jpeg_check_and_set_last_buffer(ctx, src_buf, dst_buf);
 	v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
-- 
2.35.1



