Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88006FF386
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbfKPPl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:41:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:45320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728064AbfKPPl6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:58 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B42820854;
        Sat, 16 Nov 2019 15:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918917;
        bh=AFXHZLOietu/5Qoi+Zd8KLI2EG/uE9+32R3/Z1FPs5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tU2GYp3LbtiPNvimtfHI/QdGk+N9ABAxi78f2U2oYQnEKQGzb/Ju1CZT1RssAfhfx
         NKQpI/45diwdSkrJF10dRtvDsK8WFFcwAPYXtPTO9qgzob7kmkdIjHrIdLQZ4oxf+i
         wflhf2tGkoECL0g5yP0SV74a7gV7aYW//W/+2acY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 041/237] pinctrl: sunxi: Fix a memory leak in 'sunxi_pinctrl_build_state()'
Date:   Sat, 16 Nov 2019 10:37:56 -0500
Message-Id: <20191116154113.7417-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit a93a676b079144009f55fff2ab0e34c3b7258c8a ]

If 'krealloc()' fails, 'pctl->functions' is set to NULL.
We should instead use a temp variable in order to be able to free the
previously allocated memeory, in case of OOM.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sunxi/pinctrl-sunxi.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index 26ebedc1f6d31..61aaaf58c5993 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -1042,6 +1042,7 @@ static int sunxi_pinctrl_add_function(struct sunxi_pinctrl *pctl,
 static int sunxi_pinctrl_build_state(struct platform_device *pdev)
 {
 	struct sunxi_pinctrl *pctl = platform_get_drvdata(pdev);
+	void *ptr;
 	int i;
 
 	/*
@@ -1108,13 +1109,15 @@ static int sunxi_pinctrl_build_state(struct platform_device *pdev)
 	}
 
 	/* And now allocated and fill the array for real */
-	pctl->functions = krealloc(pctl->functions,
-				   pctl->nfunctions * sizeof(*pctl->functions),
-				   GFP_KERNEL);
-	if (!pctl->functions) {
+	ptr = krealloc(pctl->functions,
+		       pctl->nfunctions * sizeof(*pctl->functions),
+		       GFP_KERNEL);
+	if (!ptr) {
 		kfree(pctl->functions);
+		pctl->functions = NULL;
 		return -ENOMEM;
 	}
+	pctl->functions = ptr;
 
 	for (i = 0; i < pctl->desc->npins; i++) {
 		const struct sunxi_desc_pin *pin = pctl->desc->pins + i;
-- 
2.20.1

