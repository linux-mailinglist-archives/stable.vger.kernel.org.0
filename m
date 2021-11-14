Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678D944F88C
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 15:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhKNOiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 09:38:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:33856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229890AbhKNOhu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Nov 2021 09:37:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0889D60EE2;
        Sun, 14 Nov 2021 14:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636900494;
        bh=g1/G3nMrKxWyIiTAcqDBGX9bZadvugls4E89FRK2evA=;
        h=Subject:To:Cc:From:Date:From;
        b=Cu7LwuM6K6bCjFcQS0ErXBe0YoDLXPYmVrcGUo+NE4/JI4o7xk5kOlnW47iei6cd4
         RPmudx5KZkuls0hfB/N1hmRiFuweZ6tUFt+Gc/uJSpM5U4FQt63Mk7ptQaE8RS30nf
         RT6CeaQ6ffkD9YZOh6m2H0kPp5ReXj4PACKBXOV0=
Subject: FAILED: patch "[PATCH] power: supply: max17042_battery: Clear status bits in" failed to apply to 4.19-stable tree
To:     sebastian.krzyszkowiak@puri.sm, krzysztof.kozlowski@canonical.com,
        sebastian.reichel@collabora.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Nov 2021 15:34:51 +0100
Message-ID: <163690049116629@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0cf48167b87e388fa1268c9fe6d2443ae7f43d8a Mon Sep 17 00:00:00 2001
From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Date: Tue, 14 Sep 2021 14:18:05 +0200
Subject: [PATCH] power: supply: max17042_battery: Clear status bits in
 interrupt handler

The gauge requires us to clear the status bits manually for some alerts
to be properly dismissed. Previously the IRQ was configured to react only
on falling edge, which wasn't technically correct (the ALRT line is active
low), but it had a happy side-effect of preventing interrupt storms
on uncleared alerts from happening.

Fixes: 7fbf6b731bca ("power: supply: max17042: Do not enforce (incorrect) interrupt trigger type")
Cc: <stable@vger.kernel.org>
Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>

diff --git a/drivers/power/supply/max17042_battery.c b/drivers/power/supply/max17042_battery.c
index 32f331480487..2eb61856f3e4 100644
--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -879,6 +879,10 @@ static irqreturn_t max17042_thread_handler(int id, void *dev)
 		max17042_set_soc_threshold(chip, 1);
 	}
 
+	/* we implicitly handle all alerts via power_supply_changed */
+	regmap_clear_bits(chip->regmap, MAX17042_STATUS,
+			  0xFFFF & ~(STATUS_POR_BIT | STATUS_BST_BIT));
+
 	power_supply_changed(chip->battery);
 	return IRQ_HANDLED;
 }

