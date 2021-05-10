Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9273781D4
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbhEJKaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:30:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231321AbhEJK2m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:28:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79A2F6145C;
        Mon, 10 May 2021 10:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642428;
        bh=/LzrbPktzhyQ1nIou3ef3Jihzk5fClU2jPJvhIfDLUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0kwoAJX8f02DudMaiUfNQ2NxB20w/Ijkit99DUNAcoEbnIoZNYOIhZ3BqNmVoyy01
         /b1/duF79ech1wtKon/knEn+A0hobiN4X6sPUcM7AKsykQ9ZsmmfhRTmhPQids/hg/
         YVtqu7MgzCIFW+vcSIM7YEX+Djifbvi2CfI+H5NE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/184] usb: xhci-mtk: support quirk to disable usb2 lpm
Date:   Mon, 10 May 2021 12:19:09 +0200
Message-Id: <20210510101952.012121329@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



