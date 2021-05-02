Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4CCD370C6A
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbhEBOGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:06:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233051AbhEBOFs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:05:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5424C613C6;
        Sun,  2 May 2021 14:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964297;
        bh=/LzrbPktzhyQ1nIou3ef3Jihzk5fClU2jPJvhIfDLUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJV1gkGSLPW7Pd4ZdxB4bBygqSn011DcELbG7byeU2TXIVvq4R16mIfyr6iIDX56e
         fEV2bHMlW/k6Rsvp/dBeu+dQHPdgLdchzqpaKmfv/ZN087T2MLcFglJbaRJvPxuKGJ
         C/xlA+WLm3bTVBS1Y6uZGsNS8AbSTp1ng7U1dQbjQncuHcpZo8iZCAD+AyMnVQdelT
         f8O+yM4QkCjrZ67ztkDRxlm/cdfAAaTUdxlQUKsOYIE2+3tBxoV48xWSGQysEpIXgq
         r3mXlIsiWXgsnWananKY5IM+v1dU4Px5tU6h4Ivzm7dAqcLK4SDaOYsl44NB8O3gpj
         ImUNCkGf6eHTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 18/34] usb: xhci-mtk: support quirk to disable usb2 lpm
Date:   Sun,  2 May 2021 10:04:18 -0400
Message-Id: <20210502140434.2719553-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140434.2719553-1-sashal@kernel.org>
References: <20210502140434.2719553-1-sashal@kernel.org>
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
index 5fc3ea6d46c5..5c0eb35cd007 100644
--- a/drivers/usb/host/xhci-mtk.c
+++ b/drivers/usb/host/xhci-mtk.c
@@ -397,6 +397,8 @@ static void xhci_mtk_quirks(struct device *dev, struct xhci_hcd *xhci)
 	xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
 	if (mtk->lpm_support)
 		xhci->quirks |= XHCI_LPM_SUPPORT;
+	if (mtk->u2_lpm_disable)
+		xhci->quirks |= XHCI_HW_LPM_DISABLE;
 
 	/*
 	 * MTK xHCI 0.96: PSA is 1 by default even if doesn't support stream,
@@ -469,6 +471,7 @@ static int xhci_mtk_probe(struct platform_device *pdev)
 		return ret;
 
 	mtk->lpm_support = of_property_read_bool(node, "usb3-lpm-capable");
+	mtk->u2_lpm_disable = of_property_read_bool(node, "usb2-lpm-disable");
 	/* optional property, ignore the error if it does not exist */
 	of_property_read_u32(node, "mediatek,u3p-dis-msk",
 			     &mtk->u3p_dis_msk);
diff --git a/drivers/usb/host/xhci-mtk.h b/drivers/usb/host/xhci-mtk.h
index 734c5513aa1b..d9f438d078da 100644
--- a/drivers/usb/host/xhci-mtk.h
+++ b/drivers/usb/host/xhci-mtk.h
@@ -150,6 +150,7 @@ struct xhci_hcd_mtk {
 	struct phy **phys;
 	int num_phys;
 	bool lpm_support;
+	bool u2_lpm_disable;
 	/* usb remote wakeup */
 	bool uwk_en;
 	struct regmap *uwk;
-- 
2.30.2

