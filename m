Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C424523EA
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241993AbhKPBf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:35:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:42248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242052AbhKOSdN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:33:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 996786333F;
        Mon, 15 Nov 2021 17:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999178;
        bh=txTzy4U+g/sUtPy3cHI4R8RkaqqByGa0Q+WzRYLUGuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ruuzYOpU3Vz+Nk4ZnvzdppsF3YBpdzViK4MVaiQpyxasTBN6d4t+85kj5kXt1nsvb
         p/eBA6G76vB9Emko6LKZvKgYN9gvSwnuiFHk59OHqjEp4qVn8SNzHT2uxKMZ8D/MEr
         foYkC9z/NXewKQhkebkJpitCQMAGRicLU3bkSLBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.14 203/849] power: supply: max17042_battery: Clear status bits in interrupt handler
Date:   Mon, 15 Nov 2021 17:54:46 +0100
Message-Id: <20211115165427.072072556@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

commit 0cf48167b87e388fa1268c9fe6d2443ae7f43d8a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/max17042_battery.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -885,6 +885,10 @@ static irqreturn_t max17042_thread_handl
 		max17042_set_soc_threshold(chip, 1);
 	}
 
+	/* we implicitly handle all alerts via power_supply_changed */
+	regmap_clear_bits(chip->regmap, MAX17042_STATUS,
+			  0xFFFF & ~(STATUS_POR_BIT | STATUS_BST_BIT));
+
 	power_supply_changed(chip->battery);
 	return IRQ_HANDLED;
 }


