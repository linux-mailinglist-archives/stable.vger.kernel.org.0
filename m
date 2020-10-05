Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34F1283A7A
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbgJEPen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:34:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728271AbgJEPeU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:34:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97FCA2085B;
        Mon,  5 Oct 2020 15:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601912060;
        bh=RYtEeu5BvRlDLYwG2JQfFqKm4J+xy0z2HlN6dXQ5FNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gsyKIihBWz4yTWNg9ZWxWaFL+g6stkIRGn8ptegDpHieCSLT8y1qIsCEA5tGsc9ob
         P86RzEFqR8yyRMFg5GszZM8o+uxsmebnFw6NFWo0T/I9kttQJ+f36ePIrmhRLHUQUC
         pl9QNWSj6TFA0poKWL0OFbjYrEtLNiwSnmrad0R0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hanks Chen <hanks.chen@mediatek.com>,
        Sean Wang <sean.wang@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        Jie Yang <sin_jieyang@mediatek.com>
Subject: [PATCH 5.8 73/85] pinctrl: mediatek: check mtk_is_virt_gpio input parameter
Date:   Mon,  5 Oct 2020 17:27:09 +0200
Message-Id: <20201005142118.242854830@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hanks Chen <hanks.chen@mediatek.com>

[ Upstream commit 39c4dbe4cc363accd676162c24b264f44c581490 ]

check mtk_is_virt_gpio input parameter,
virtual gpio need to support eint mode.

add error handler for the ko case
to fix this boot fail:
pc : mtk_is_virt_gpio+0x20/0x38 [pinctrl_mtk_common_v2]
lr : mtk_gpio_get_direction+0x44/0xb0 [pinctrl_paris]

Fixes: edd546465002 ("pinctrl: mediatek: avoid virtual gpio trying to set reg")
Signed-off-by: Hanks Chen <hanks.chen@mediatek.com>
Acked-by: Sean Wang <sean.wang@kernel.org>
Singed-off-by: Jie Yang <sin_jieyang@mediatek.com>
Link: https://lore.kernel.org/r/1597922546-29633-1-git-send-email-hanks.chen@mediatek.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
index 2f3dfb56c3fa4..35bbe59357088 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
@@ -259,6 +259,10 @@ bool mtk_is_virt_gpio(struct mtk_pinctrl *hw, unsigned int gpio_n)
 
 	desc = (const struct mtk_pin_desc *)&hw->soc->pins[gpio_n];
 
+	/* if the GPIO is not supported for eint mode */
+	if (desc->eint.eint_m == NO_EINT_SUPPORT)
+		return virt_gpio;
+
 	if (desc->funcs && !desc->funcs[desc->eint.eint_m].name)
 		virt_gpio = true;
 
-- 
2.25.1



