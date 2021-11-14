Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA2F44F88B
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 15:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhKNOhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 09:37:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:33826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229563AbhKNOhf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Nov 2021 09:37:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAC0660ED7;
        Sun, 14 Nov 2021 14:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636900480;
        bh=FLunI+ASmabCJltSjYwspXWSedhi2FKBYDwDh/Ii3W8=;
        h=Subject:To:Cc:From:Date:From;
        b=dVAE80xobewyMXXorVn7KkeTyw3CDrJy3Q7DK77FOaWtLcdivsULGaOagu3hZp5OY
         /3qw0dhfaV+wtfWNuJg44Y1MZb9Cc7g5EDx5hgUnJZgLOTYWkA59DigIbEbPuvddmp
         Wk+p6UTcRfb+KWf4rJe5qYRX6f5pmDdw48bZAp3g=
Subject: FAILED: patch "[PATCH] power: supply: max17042_battery: Clear status bits in" failed to apply to 4.14-stable tree
To:     sebastian.krzyszkowiak@puri.sm, krzysztof.kozlowski@canonical.com,
        sebastian.reichel@collabora.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Nov 2021 15:34:37 +0100
Message-ID: <16369004775232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

