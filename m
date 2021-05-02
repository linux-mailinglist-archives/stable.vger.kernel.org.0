Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C138370CCF
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbhEBOHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:07:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233165AbhEBOG1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:06:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96323613B0;
        Sun,  2 May 2021 14:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964333;
        bh=Jfp2iIYgHJRSaV2HyRvRnNTudasMjHvEd9wkE7q3ZyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t7ESafim1Qbqapyl8xqbB+WwJ/0DxvLwicNtN7+KnlIe57VICQi8YWshLcbGVw93B
         a/IoS08VXLtFrjap5rWWBGpoKKlrKPCuBvStKiUECiua6EEn9ttgMN192ePPuv20oT
         c9kjxgmN9cWgvAFaNaIsBzPGBMxjey040Di3Bo7V34LXZNEvVTwbCp+vzOvl5CRDKg
         aNx+HAAGmTJAM7kDp08rcsF/CsueES9oUkxpa+WfJrX9Lr8FuQwZK8Q6GeTE+tAuSf
         nyrd2WCYCsHuUEXC5nmjZF4o8CMO1RjnRygc9OwVD8x6MAkdTXL6Yv/bBTYhw8Xn3i
         7+CZgKBDktlWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 12/21] usb: xhci-mtk: support quirk to disable usb2 lpm
Date:   Sun,  2 May 2021 10:05:08 -0400
Message-Id: <20210502140517.2719912-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140517.2719912-1-sashal@kernel.org>
References: <20210502140517.2719912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

[ Upstream commit bee1f89aad2a51cd3339571bc8eadbb0dc88a683 ]

The xHCI driver support usb2 HW LPM by default, here add support
XHCI_HW_LPM_DISABLE quirk, then we can disable usb2 lpm when
need it.

Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/1617181553-3503-4-git-send-email-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mtk.c | 3 +++
 drivers/usb/host/xhci-mtk.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/usb/host/xhci-mtk.c b/drivers/usb/host/xhci-mtk.c
index 09d5a789fcd5..f4b2e766f195 100644
--- a/drivers/usb/host/xhci-mtk.c
+++ b/drivers/usb/host/xhci-mtk.c
@@ -395,6 +395,8 @@ static void xhci_mtk_quirks(struct device *dev, struct xhci_hcd *xhci)
 	xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
 	if (mtk->lpm_support)
 		xhci->quirks |= XHCI_LPM_SUPPORT;
+	if (mtk->u2_lpm_disable)
+		xhci->quirks |= XHCI_HW_LPM_DISABLE;
 
 	/*
 	 * MTK xHCI 0.96: PSA is 1 by default even if doesn't support stream,
@@ -467,6 +469,7 @@ static int xhci_mtk_probe(struct platform_device *pdev)
 		return ret;
 
 	mtk->lpm_support = of_property_read_bool(node, "usb3-lpm-capable");
+	mtk->u2_lpm_disable = of_property_read_bool(node, "usb2-lpm-disable");
 	/* optional property, ignore the error if it does not exist */
 	of_property_read_u32(node, "mediatek,u3p-dis-msk",
 			     &mtk->u3p_dis_msk);
diff --git a/drivers/usb/host/xhci-mtk.h b/drivers/usb/host/xhci-mtk.h
index cc59d80b663b..1601ca9a388e 100644
--- a/drivers/usb/host/xhci-mtk.h
+++ b/drivers/usb/host/xhci-mtk.h
@@ -123,6 +123,7 @@ struct xhci_hcd_mtk {
 	struct phy **phys;
 	int num_phys;
 	bool lpm_support;
+	bool u2_lpm_disable;
 	/* usb remote wakeup */
 	bool uwk_en;
 	struct regmap *uwk;
-- 
2.30.2

