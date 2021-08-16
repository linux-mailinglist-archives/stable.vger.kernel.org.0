Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB193ED4D9
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237088AbhHPNFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:05:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237247AbhHPNFc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:05:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35DD161A7A;
        Mon, 16 Aug 2021 13:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119100;
        bh=rkCkvNfDX/iWRL2ASSFRxRPruVr2sa+2Ga63hXnutJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mjyazb00WP53BVRLV0F+vd4jTzWPH+fA2kDa1tZs/2NSYhKHs9SpnygQnddNfEODC
         M/RmIlAMyfuRKn2poGQMQOEsT7C02sAV8dZr5XGHuEhOp07q9z3Mj20/Ap4ge/o7kT
         ChEXu/KuL4a8wrhzPyAijPe80SiyAuBH7ljh5IFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Eckert <fe@dev.tdt.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 19/62] platform/x86: pcengines-apuv2: revert wiring up simswitch GPIO as LED
Date:   Mon, 16 Aug 2021 15:01:51 +0200
Message-Id: <20210816125428.847575906@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125428.198692661@linuxfoundation.org>
References: <20210816125428.198692661@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Eckert <fe@dev.tdt.de>

[ Upstream commit f560cd502190a9fd0ca8db0a15c5cca7d9091d2c ]

This reverts commit 5037d4ddda31c2dbbb018109655f61054b1756dc.

Explanation why this does not work:
This change connects the simswap to the LED subsystem of the kernel.
>From my point of view, it's nonsense. If we do it this way, then this
can be switched relatively easily via the LED subsystem (trigger:
none/default-on) and that is dangerous! If this is used, it would be
unfavorable, since there is also another trigger (trigger:
heartbeat/netdev).

Therefore, this simswap GPIO should remain in the GPIO
subsystem and be switched via it and not be connected to the LED
subsystem. To avoid the problems mentioned above. The LED subsystem is
not made for this and it is not a good compromise, but rather dangerous.

Signed-off-by: Florian Eckert <fe@dev.tdt.de>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/pcengines-apuv2.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/platform/x86/pcengines-apuv2.c b/drivers/platform/x86/pcengines-apuv2.c
index c32daf087640..cb95b4ede824 100644
--- a/drivers/platform/x86/pcengines-apuv2.c
+++ b/drivers/platform/x86/pcengines-apuv2.c
@@ -78,7 +78,6 @@ static const struct gpio_led apu2_leds[] = {
 	{ .name = "apu:green:1" },
 	{ .name = "apu:green:2" },
 	{ .name = "apu:green:3" },
-	{ .name = "apu:simswap" },
 };
 
 static const struct gpio_led_platform_data apu2_leds_pdata = {
@@ -95,8 +94,6 @@ static struct gpiod_lookup_table gpios_led_table = {
 				NULL, 1, GPIO_ACTIVE_LOW),
 		GPIO_LOOKUP_IDX(AMD_FCH_GPIO_DRIVER_NAME, APU2_GPIO_LINE_LED3,
 				NULL, 2, GPIO_ACTIVE_LOW),
-		GPIO_LOOKUP_IDX(AMD_FCH_GPIO_DRIVER_NAME, APU2_GPIO_LINE_SIMSWAP,
-				NULL, 3, GPIO_ACTIVE_LOW),
 	}
 };
 
-- 
2.30.2



