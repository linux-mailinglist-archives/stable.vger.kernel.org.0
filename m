Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87F55CAC4D
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733252AbfJCQIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:08:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731955AbfJCQIm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:08:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63C8320865;
        Thu,  3 Oct 2019 16:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118921;
        bh=nE9nz5evbkAO8wmG0ixscqvwNdd1KDUNZZz1Dyjbub8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VhHC7CmKJ8p5sihzHmURyILHjzcesM1C0WoYC7DokDPxhdgwhDXRIAeUToVy8WOhR
         OVO1sNKeNkGC2Vk4/pTAJLuP4ERMGXvcU+RJ14KygtzNVXKJuSLgLFqV522D23K9pw
         5NYSB0HcEV822atJsluqSKkhrqPAgc0EYPzc8UMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Young <sean@mess.org>,
        Sean Wang <sean.wang@kernel.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 059/185] media: mtk-cir: lower de-glitch counter for rc-mm protocol
Date:   Thu,  3 Oct 2019 17:52:17 +0200
Message-Id: <20191003154450.607953431@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
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
index e88eb64e8e693..00a4a0dfcab87 100644
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
 
@@ -411,6 +416,9 @@ static int mtk_ir_probe(struct platform_device *pdev)
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



