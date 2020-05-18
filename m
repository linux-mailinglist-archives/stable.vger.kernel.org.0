Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372C71D8476
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732590AbgERSC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:02:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731198AbgERSC4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:02:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4A8B207D3;
        Mon, 18 May 2020 18:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824976;
        bh=cTsk6Vd1CBdbHwWM2rAQN9WqRfHIR5FG9DzF31Adokw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XV9cywZWMaW4eKwjpvgF4UuTVoim1bO3wRhKOdHg/GKmCBBv233lD1iTgZEq5ffNo
         pisZ2u3u6ZfvsXyfBiQb9VvcYIFu8I5RATM9FHfGvU6BtuqoxdWGJujnv2H/BEW3Ue
         yBx86eGvChaSnKGO81nwN8uqsSgihUv/ijIDqEm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ansuel Smith <ansuelsmth@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 077/194] pinctrl: qcom: fix wrong write in update_dual_edge
Date:   Mon, 18 May 2020 19:36:07 +0200
Message-Id: <20200518173538.215907782@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ansuel Smith <ansuelsmth@gmail.com>

[ Upstream commit 90bcb0c3ca0809d1ed358bfbf838df4b3d4e58e0 ]

Fix a typo in the readl/writel accessor conversion where val is used
instead of pol changing the behavior of the original code.

Cc: stable@vger.kernel.org
Fixes: 6c73698904aa pinctrl: qcom: Introduce readl/writel accessors
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20200414003726.25347-1-ansuelsmth@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-msm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index 1a948c3f54b7c..9f1c9951949ea 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -692,7 +692,7 @@ static void msm_gpio_update_dual_edge_pos(struct msm_pinctrl *pctrl,
 
 		pol = msm_readl_intr_cfg(pctrl, g);
 		pol ^= BIT(g->intr_polarity_bit);
-		msm_writel_intr_cfg(val, pctrl, g);
+		msm_writel_intr_cfg(pol, pctrl, g);
 
 		val2 = msm_readl_io(pctrl, g) & BIT(g->in_bit);
 		intstat = msm_readl_intr_status(pctrl, g);
-- 
2.20.1



