Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B710157550
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729640AbgBJMkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:40:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:39482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729630AbgBJMkI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:08 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 875292467D;
        Mon, 10 Feb 2020 12:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338407;
        bh=xk2jWWEmwKaCGlqYNJeB/YEGW+4Fo0RAqrQtO9PIooI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2u1AyQVr7ek1Q47/BU8bqbstgKuavtdk06JNDh7z9kM+WuiW3legkCS1C5KzjnBL9
         EAG+ZP2P1ROWV09X0WUytZc2PhdTZvLOlxPVaZc4hjNAhxdYFc9Sn20xd1fxbCoh2M
         v78R2giW8vfaJmHp1X5Fkps7KYOGQN8cVmuc6dGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>,
        Chen-Yu Tsai <wens@csie.org>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5.5 111/367] mfd: axp20x: Mark AXP20X_VBUS_IPSOUT_MGMT as volatile
Date:   Mon, 10 Feb 2020 04:30:24 -0800
Message-Id: <20200210122434.757039493@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

commit dc91c3b6fe66a13ac76f6cb3b2100c0779cd3350 upstream.

On AXP288 and newer PMICs, bit 7 of AXP20X_VBUS_IPSOUT_MGMT can be set
to prevent using the VBUS input. However, when the VBUS unplugged and
plugged back in, the bit automatically resets to zero.

We need to set the register as volatile to prevent regmap from caching
that bit. Otherwise, regcache will think the bit is already set and not
write the register.

Fixes: cd53216625a0 ("mfd: axp20x: Fix axp288 volatile ranges")
Cc: stable@vger.kernel.org
Signed-off-by: Samuel Holland <samuel@sholland.org>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/axp20x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/axp20x.c
+++ b/drivers/mfd/axp20x.c
@@ -126,7 +126,7 @@ static const struct regmap_range axp288_
 static const struct regmap_range axp288_volatile_ranges[] = {
 	regmap_reg_range(AXP20X_PWR_INPUT_STATUS, AXP288_POWER_REASON),
 	regmap_reg_range(AXP288_BC_GLOBAL, AXP288_BC_GLOBAL),
-	regmap_reg_range(AXP288_BC_DET_STAT, AXP288_BC_DET_STAT),
+	regmap_reg_range(AXP288_BC_DET_STAT, AXP20X_VBUS_IPSOUT_MGMT),
 	regmap_reg_range(AXP20X_CHRG_BAK_CTRL, AXP20X_CHRG_BAK_CTRL),
 	regmap_reg_range(AXP20X_IRQ1_EN, AXP20X_IPSOUT_V_HIGH_L),
 	regmap_reg_range(AXP20X_TIMER_CTRL, AXP20X_TIMER_CTRL),


