Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26682E645A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391469AbgL1Nib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:38:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:38794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391475AbgL1Nia (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:38:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A81E207C9;
        Mon, 28 Dec 2020 13:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162669;
        bh=qbEtMZJktTNYtVXibHZ0fe4tlOtLL1pmTgkGf+DQaAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HtI+gEsAsZy86QPdUgKzjaXRV8i0dM+F/AVP9TiNH/JRSXPPu50gNsdMUCYAgnQCK
         0GzuGqHJFjbrzRYC7NiTG8gbzOVxX/2C9HVBr2DqR1FMC9JPzi5BgKC0FjZjOHmmCu
         xj7ZQjWkoVka0KCMX5k6m9UCI+pR9opZs8YUAU3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 005/453] pinctrl: baytrail: Avoid clearing debounce value when turning it off
Date:   Mon, 28 Dec 2020 13:44:01 +0100
Message-Id: <20201228124937.501438978@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 0b74e40a4e41f3cbad76dff4c50850d47b525b26 ]

Baytrail pin control has a common register to set up debounce timeout.
When a pin configuration requested debounce to be disabled, the rest
of the pins may still want to have debounce enabled and thus rely on
the common timeout value. Avoid clearing debounce value when turning
it off for one pin while others may still use it.

Fixes: 658b476c742f ("pinctrl: baytrail: Add debounce configuration")
Depends-on: 04ff5a095d66 ("pinctrl: baytrail: Rectify debounce support")
Depends-on: 827e1579e1d5 ("pinctrl: baytrail: Rectify debounce support (part 2)")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-baytrail.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/intel/pinctrl-baytrail.c b/drivers/pinctrl/intel/pinctrl-baytrail.c
index 5a1174a8e2bac..d05f20ca90d7e 100644
--- a/drivers/pinctrl/intel/pinctrl-baytrail.c
+++ b/drivers/pinctrl/intel/pinctrl-baytrail.c
@@ -1060,7 +1060,6 @@ static int byt_pin_config_set(struct pinctrl_dev *pctl_dev,
 			break;
 		case PIN_CONFIG_INPUT_DEBOUNCE:
 			debounce = readl(db_reg);
-			debounce &= ~BYT_DEBOUNCE_PULSE_MASK;
 
 			if (arg)
 				conf |= BYT_DEBOUNCE_EN;
@@ -1069,24 +1068,31 @@ static int byt_pin_config_set(struct pinctrl_dev *pctl_dev,
 
 			switch (arg) {
 			case 375:
+				debounce &= ~BYT_DEBOUNCE_PULSE_MASK;
 				debounce |= BYT_DEBOUNCE_PULSE_375US;
 				break;
 			case 750:
+				debounce &= ~BYT_DEBOUNCE_PULSE_MASK;
 				debounce |= BYT_DEBOUNCE_PULSE_750US;
 				break;
 			case 1500:
+				debounce &= ~BYT_DEBOUNCE_PULSE_MASK;
 				debounce |= BYT_DEBOUNCE_PULSE_1500US;
 				break;
 			case 3000:
+				debounce &= ~BYT_DEBOUNCE_PULSE_MASK;
 				debounce |= BYT_DEBOUNCE_PULSE_3MS;
 				break;
 			case 6000:
+				debounce &= ~BYT_DEBOUNCE_PULSE_MASK;
 				debounce |= BYT_DEBOUNCE_PULSE_6MS;
 				break;
 			case 12000:
+				debounce &= ~BYT_DEBOUNCE_PULSE_MASK;
 				debounce |= BYT_DEBOUNCE_PULSE_12MS;
 				break;
 			case 24000:
+				debounce &= ~BYT_DEBOUNCE_PULSE_MASK;
 				debounce |= BYT_DEBOUNCE_PULSE_24MS;
 				break;
 			default:
-- 
2.27.0



