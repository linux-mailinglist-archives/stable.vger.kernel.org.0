Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25D5ACA3A8
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388470AbfJCQRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:17:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388397AbfJCQRi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:17:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82CFA21848;
        Thu,  3 Oct 2019 16:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119458;
        bh=u7H7ztHchobE3ZGof1DEGjbx8GRy0u3r0WIDuLbnQ48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3Cy/42ua66JMeC3JTNN1RSOpgRAE2vg+z4lJ4DYADzBYD0I3cuizGaTX5okNr79x
         HrdV02CK6cMQne5FK2Fd3YtKbJW7K/QxaMFe5lEcaoQf5R+hfdYJxJp4NQ/ZSq4siK
         WTlZ6UGYU2HCDiqmbIaOjdeVAeUHwcE1TlEPi6ZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Young <sean@mess.org>,
        Sean Wang <sean.wang@kernel.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 033/211] media: mtk-cir: lower de-glitch counter for rc-mm protocol
Date:   Thu,  3 Oct 2019 17:51:39 +0200
Message-Id: <20191003154454.650243924@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
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
index e42efd9d382ec..d37b85d2bc750 100644
--- a/drivers/media/rc/mtk-cir.c
+++ b/drivers/media/rc/mtk-cir.c
@@ -44,6 +44,11 @@
 /* Fields containing pulse width data */
 #define MTK_WIDTH_MASK		  (GENMASK(7, 0))
 
+/* IR threshold */
+#define MTK_IRTHD		 0x14
+#define MTK_DG_CNT_MASK		 (GENMASK(12, 8))
+#define MTK_DG_CNT(x)		 ((x) << 8)
+
 /* Bit to enable interrupt */
 #define MTK_IRINT_EN		  BIT(0)
 
@@ -409,6 +414,9 @@ static int mtk_ir_probe(struct platform_device *pdev)
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



