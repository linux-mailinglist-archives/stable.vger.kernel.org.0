Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1F51CA628
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404767AbfJCQkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:40:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404451AbfJCQka (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:40:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 612F620830;
        Thu,  3 Oct 2019 16:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120829;
        bh=lZGEvVKT7P6VlhMVE3btjG8+YRwhHKeruH72i+PVMm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I5A6E3qrYMSHEfF7sRDuM/NkN1ODKLTtvDYxOgFi6t5D0g25IXqN1uQGB+wAiZjnS
         4iHJkzJ7b/8hU2kNGZqbR0/7+ubDI+aIgvUI/lsLLhtts/fjIhrMMc3UiJh9RcyM5f
         x6nBNE1S++BGCyh4ZlFAEsZ+zYrF8LYKbQ4F27j8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Young <sean@mess.org>,
        Sean Wang <sean.wang@kernel.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 053/344] media: mtk-cir: lower de-glitch counter for rc-mm protocol
Date:   Thu,  3 Oct 2019 17:50:18 +0200
Message-Id: <20191003154545.363336419@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

[ Upstream commit 5dd4b89dc098bf22cd13e82a308f42a02c102b2b ]

The rc-mm protocol can't be decoded by the mtk-cir since the de-glitch
filter removes pulses/spaces shorter than 294 microseconds.

Tested on a BananaPi R2.

Signed-off-by: Sean Young <sean@mess.org>
Acked-by: Sean Wang <sean.wang@kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/mtk-cir.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/rc/mtk-cir.c b/drivers/media/rc/mtk-cir.c
index 50fb0aebb8d40..f2259082e3d82 100644
--- a/drivers/media/rc/mtk-cir.c
+++ b/drivers/media/rc/mtk-cir.c
@@ -35,6 +35,11 @@
 /* Fields containing pulse width data */
 #define MTK_WIDTH_MASK		  (GENMASK(7, 0))
 
+/* IR threshold */
+#define MTK_IRTHD		 0x14
+#define MTK_DG_CNT_MASK		 (GENMASK(12, 8))
+#define MTK_DG_CNT(x)		 ((x) << 8)
+
 /* Bit to enable interrupt */
 #define MTK_IRINT_EN		  BIT(0)
 
@@ -398,6 +403,9 @@ static int mtk_ir_probe(struct platform_device *pdev)
 	mtk_w32_mask(ir, val, ir->data->fields[MTK_HW_PERIOD].mask,
 		     ir->data->fields[MTK_HW_PERIOD].reg);
 
+	/* Set de-glitch counter */
+	mtk_w32_mask(ir, MTK_DG_CNT(1), MTK_DG_CNT_MASK, MTK_IRTHD);
+
 	/* Enable IR and PWM */
 	val = mtk_r32(ir, MTK_CONFIG_HIGH_REG);
 	val |= MTK_OK_COUNT(ir->data->ok_count) |  MTK_PWM_EN | MTK_IR_EN;
-- 
2.20.1



