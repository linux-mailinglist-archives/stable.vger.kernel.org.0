Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 586AD2E3858
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730081AbgL1NJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:09:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731086AbgL1NJO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:09:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44860208D5;
        Mon, 28 Dec 2020 13:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160913;
        bh=c8LCfZSTGzbnWCzKYbG3MtKbBzqV/GpOM0o9lbsGoL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jaBsbBZcxfB+gSMe1ubopW3xE/+DO0ewviEiGo3vL9qsHeA9A3hOngvb8by+y10uJ
         0ZFrmCc33khQWf5PunRpcO2iZKvu2qCTtrEyb6OkRSSjPgNr/mGTchoEqr6tRsUJxf
         /trrtJXv1u8EILlhiof0eoCNPDjKxAoip3Dkjj6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 036/242] pinctrl: baytrail: Avoid clearing debounce value when turning it off
Date:   Mon, 28 Dec 2020 13:47:21 +0100
Message-Id: <20201228124906.443930589@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
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
index 62eac76be9f66..519758d4297ee 100644
--- a/drivers/pinctrl/intel/pinctrl-baytrail.c
+++ b/drivers/pinctrl/intel/pinctrl-baytrail.c
@@ -1266,7 +1266,6 @@ static int byt_pin_config_set(struct pinctrl_dev *pctl_dev,
 			break;
 		case PIN_CONFIG_INPUT_DEBOUNCE:
 			debounce = readl(db_reg);
-			debounce &= ~BYT_DEBOUNCE_PULSE_MASK;
 
 			if (arg)
 				conf |= BYT_DEBOUNCE_EN;
@@ -1275,24 +1274,31 @@ static int byt_pin_config_set(struct pinctrl_dev *pctl_dev,
 
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



