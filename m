Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0743F6543
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239273AbhHXRLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:11:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:51260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239996AbhHXRJw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:09:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EC88619F6;
        Tue, 24 Aug 2021 17:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824426;
        bh=p4W+aGWilu+phCbFPw5UJIPV3jHhStkKTzckY5OTw0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SH1gtFZptnDAgqlZSFou5wxbcXgKBkEzorMLLfWKtPDnQwZ+jY6IyV6jTG/2BE+N4
         xayCFfdRcVPe4Hf0k8HWidkne1FCh+Gf/PsukFzm+VomOMEHpngt8hFHoh+Dlb3A52
         QlcKYMwmDT/FqFfjiWXLDUmJPe6mSPezEDM11H8rjrazmNZwHPiinUAoSIVNxTpFN2
         2wRYexFkRxSphzKWX9NkNT5MqcOW5su9Nj/jiQ6XnbkH2HcLmraqdPmLsihhpxTVlp
         Fj/g0aG0kUV8dB7xSYVdv7ZRCRBqJmxwZgZTRdXV98k0Z7GTnPoGRQgyVgOm/SoFdh
         XwfNadZd5SuwA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 77/98] clk: qcom: gdsc: Ensure regulator init state matches GDSC state
Date:   Tue, 24 Aug 2021 12:58:47 -0400
Message-Id: <20210824165908.709932-78-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 9711759a87a041705148161b937ec847048d882e ]

As GDSCs are registered and found to be already enabled gdsc_init()
ensures that 1) the kernel state matches the hardware state, and 2)
votable GDSCs are properly enabled from this master as well.

But as the (optional) supply regulator is enabled deep into
gdsc_toggle_logic(), which is only executed for votable GDSCs, the
kernel's state of the regulator might not match the hardware. The
regulator might be automatically turned off if no other users are
present or the next call to gdsc_disable() would cause an unbalanced
regulator_disable().

Given that the votable case deals with an already enabled GDSC, most of
gdsc_enable() and gdsc_toggle_logic() can be skipped. Reduce it to just
clearing the SW_COLLAPSE_MASK and enabling hardware control to simply
call regulator_enable() in both cases.

The enablement of hardware control seems to be an independent property
from the GDSC being enabled, so this is moved outside that conditional
segment.

Lastly, as the propagation of ALWAYS_ON to GENPD_FLAG_ALWAYS_ON needs to
happen regardless of the initial state this is grouped together with the
other sc->pd updates at the end of the function.

Cc: stable@vger.kernel.org
Fixes: 37416e554961 ("clk: qcom: gdsc: Handle GDSC regulator supplies")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210721224056.3035016-1-bjorn.andersson@linaro.org
[sboyd@kernel.org: Rephrase commit text]
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gdsc.c | 54 +++++++++++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 18 deletions(-)

diff --git a/drivers/clk/qcom/gdsc.c b/drivers/clk/qcom/gdsc.c
index 51ed640e527b..4ece326ea233 100644
--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -357,27 +357,43 @@ static int gdsc_init(struct gdsc *sc)
 	if (on < 0)
 		return on;
 
-	/*
-	 * Votable GDSCs can be ON due to Vote from other masters.
-	 * If a Votable GDSC is ON, make sure we have a Vote.
-	 */
-	if ((sc->flags & VOTABLE) && on)
-		gdsc_enable(&sc->pd);
+	if (on) {
+		/* The regulator must be on, sync the kernel state */
+		if (sc->rsupply) {
+			ret = regulator_enable(sc->rsupply);
+			if (ret < 0)
+				return ret;
+		}
 
-	/*
-	 * Make sure the retain bit is set if the GDSC is already on, otherwise
-	 * we end up turning off the GDSC and destroying all the register
-	 * contents that we thought we were saving.
-	 */
-	if ((sc->flags & RETAIN_FF_ENABLE) && on)
-		gdsc_retain_ff_on(sc);
+		/*
+		 * Votable GDSCs can be ON due to Vote from other masters.
+		 * If a Votable GDSC is ON, make sure we have a Vote.
+		 */
+		if (sc->flags & VOTABLE) {
+			ret = regmap_update_bits(sc->regmap, sc->gdscr,
+						 SW_COLLAPSE_MASK, val);
+			if (ret)
+				return ret;
+		}
+
+		/* Turn on HW trigger mode if supported */
+		if (sc->flags & HW_CTRL) {
+			ret = gdsc_hwctrl(sc, true);
+			if (ret < 0)
+				return ret;
+		}
 
-	/* If ALWAYS_ON GDSCs are not ON, turn them ON */
-	if (sc->flags & ALWAYS_ON) {
-		if (!on)
-			gdsc_enable(&sc->pd);
+		/*
+		 * Make sure the retain bit is set if the GDSC is already on,
+		 * otherwise we end up turning off the GDSC and destroying all
+		 * the register contents that we thought we were saving.
+		 */
+		if (sc->flags & RETAIN_FF_ENABLE)
+			gdsc_retain_ff_on(sc);
+	} else if (sc->flags & ALWAYS_ON) {
+		/* If ALWAYS_ON GDSCs are not ON, turn them ON */
+		gdsc_enable(&sc->pd);
 		on = true;
-		sc->pd.flags |= GENPD_FLAG_ALWAYS_ON;
 	}
 
 	if (on || (sc->pwrsts & PWRSTS_RET))
@@ -385,6 +401,8 @@ static int gdsc_init(struct gdsc *sc)
 	else
 		gdsc_clear_mem_on(sc);
 
+	if (sc->flags & ALWAYS_ON)
+		sc->pd.flags |= GENPD_FLAG_ALWAYS_ON;
 	if (!sc->pd.power_off)
 		sc->pd.power_off = gdsc_disable;
 	if (!sc->pd.power_on)
-- 
2.30.2

