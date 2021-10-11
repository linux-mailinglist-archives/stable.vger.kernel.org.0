Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6CD9428F81
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237483AbhJKN7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:59:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238192AbhJKN5c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:57:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2712C60555;
        Mon, 11 Oct 2021 13:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960450;
        bh=t/0bX0SbVyZbJc1kDZCfPr7Bm/ITs/34zUpEui1W42U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bf42dsyZfcTaRHZzUr4piAxF+5Rqzzl+9faDgr5pJ76Jb/QtytkRYadvug+c0/7qF
         z7j1wmGygsL6XudgJiKBg+0YPirVSL2ICRplK6CihpJBYFPfKlSe7sgjvrRcNc3k4z
         UYu3CY9LQpU7Z8Et9oDIA2KWVzshqHI6HitQiPq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Drew Fustini <pdp7pdp7@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Robert Nelson <robertcnelson@gmail.com>,
        Yongqin Liu <yongqin.liu@linaro.org>,
        Matti Vaittinen <mazziesaccount@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 36/83] soc: ti: omap-prm: Fix external abort for am335x pruss
Date:   Mon, 11 Oct 2021 15:45:56 +0200
Message-Id: <20211011134509.631730661@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit b232537074fcaf0c2837abbb217429c097bb7598 ]

Starting with v5.15-rc1, we may now see some am335x beaglebone black
device produce the following error on pruss probe:

Unhandled fault: external abort on non-linefetch (0x1008) at 0xe0326000

This has started with the enabling of pruss for am335x in the dts files.

Turns out the is caused by the PRM reset handling not waiting for the
reset bit to clear. To fix the issue, let's always wait for the reset
bit to clear, even if there is a separate reset status register.

We attempted to fix a similar issue for dra7 iva with a udelay() in
commit effe89e40037 ("soc: ti: omap-prm: Fix occasional abort on reset
deassert for dra7 iva"). There is no longer a need for the udelay()
for dra7 iva reset either with the check added for reset bit clearing.

Cc: Drew Fustini <pdp7pdp7@gmail.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: "H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Robert Nelson <robertcnelson@gmail.com>
Cc: Yongqin Liu <yongqin.liu@linaro.org>
Fixes: effe89e40037 ("soc: ti: omap-prm: Fix occasional abort on reset deassert for dra7 iva")
Reported-by: Matti Vaittinen <mazziesaccount@gmail.com>
Tested-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/omap_prm.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/soc/ti/omap_prm.c b/drivers/soc/ti/omap_prm.c
index fb067b5e4a97..4a782bfd753c 100644
--- a/drivers/soc/ti/omap_prm.c
+++ b/drivers/soc/ti/omap_prm.c
@@ -509,25 +509,28 @@ static int omap_reset_deassert(struct reset_controller_dev *rcdev,
 	writel_relaxed(v, reset->prm->base + reset->prm->data->rstctrl);
 	spin_unlock_irqrestore(&reset->lock, flags);
 
-	if (!has_rstst)
-		goto exit;
+	/* wait for the reset bit to clear */
+	ret = readl_relaxed_poll_timeout_atomic(reset->prm->base +
+						reset->prm->data->rstctrl,
+						v, !(v & BIT(id)), 1,
+						OMAP_RESET_MAX_WAIT);
+	if (ret)
+		pr_err("%s: timedout waiting for %s:%lu\n", __func__,
+		       reset->prm->data->name, id);
 
 	/* wait for the status to be set */
-	ret = readl_relaxed_poll_timeout_atomic(reset->prm->base +
+	if (has_rstst) {
+		ret = readl_relaxed_poll_timeout_atomic(reset->prm->base +
 						 reset->prm->data->rstst,
 						 v, v & BIT(st_bit), 1,
 						 OMAP_RESET_MAX_WAIT);
-	if (ret)
-		pr_err("%s: timedout waiting for %s:%lu\n", __func__,
-		       reset->prm->data->name, id);
+		if (ret)
+			pr_err("%s: timedout waiting for %s:%lu\n", __func__,
+			       reset->prm->data->name, id);
+	}
 
-exit:
-	if (reset->clkdm) {
-		/* At least dra7 iva needs a delay before clkdm idle */
-		if (has_rstst)
-			udelay(1);
+	if (reset->clkdm)
 		pdata->clkdm_allow_idle(reset->clkdm);
-	}
 
 	return ret;
 }
-- 
2.33.0



