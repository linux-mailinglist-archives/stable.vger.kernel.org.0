Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 642F3157A64
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgBJNWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:22:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:58948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728193AbgBJMhX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:23 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01F1020838;
        Mon, 10 Feb 2020 12:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338243;
        bh=xk2jWWEmwKaCGlqYNJeB/YEGW+4Fo0RAqrQtO9PIooI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JIN8A0z2js3CxTlwC7vINyd+rNMmA4x5+uvxG/lpXJGs0gn0VcJ7RxL0NGg1T1id8
         rzzOpFUcrUOUTfrT0WNNaedLJ6MiELzajYcFSRuen88jKBvhH/RmUQF67hmuqSPy3X
         wUt/vaMO/jGxTYMiJ5l7tA66elDN/HuZ4tbvj1o4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>,
        Chen-Yu Tsai <wens@csie.org>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5.4 099/309] mfd: axp20x: Mark AXP20X_VBUS_IPSOUT_MGMT as volatile
Date:   Mon, 10 Feb 2020 04:30:55 -0800
Message-Id: <20200210122415.704746296@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
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


