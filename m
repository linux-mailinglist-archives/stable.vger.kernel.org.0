Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5A33CDF7B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344694AbhGSPKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:10:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345117AbhGSPJN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:09:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25B8F601FD;
        Mon, 19 Jul 2021 15:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709724;
        bh=ogffrAJAv0Qfp3dpAx85aa9VF4QXvkD92e4jOO4c35w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kn3mywsvebdaksMQg0BCpRmImoMc8d9li9O0svGS8ow3ylZP0T47aA/Ogp2ksU7v1
         3+yXWpAXRnHIZF51w2XB+NBuOh4jcqrxuFhNW8sHz3z4s2DojwQj4czN9W2oOt/oVx
         6QU/0b6HJuUGHVvNCI95aa7C0Lzn4Cfsg1YvAhIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 073/149] power: supply: max17042: Do not enforce (incorrect) interrupt trigger type
Date:   Mon, 19 Jul 2021 16:53:01 +0200
Message-Id: <20210719144918.606716199@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 7fbf6b731bca347700e460d94b130f9d734b33e9 ]

Interrupt line can be configured on different hardware in different way,
even inverted.  Therefore driver should not enforce specific trigger
type - edge falling - but instead rely on Devicetree to configure it.

The Maxim 17047/77693 datasheets describe the interrupt line as active
low with a requirement of acknowledge from the CPU therefore the edge
falling is not correct.

The interrupt line is shared between PMIC and RTC driver, so using level
sensitive interrupt is here especially important to avoid races.  With
an edge configuration in case if first PMIC signals interrupt followed
shortly after by the RTC, the interrupt might not be yet cleared/acked
thus the second one would not be noticed.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/max17042_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/max17042_battery.c b/drivers/power/supply/max17042_battery.c
index 0dfad2cf13fe..fa862f0380c4 100644
--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -1076,7 +1076,7 @@ static int max17042_probe(struct i2c_client *client,
 	}
 
 	if (client->irq) {
-		unsigned int flags = IRQF_TRIGGER_FALLING | IRQF_ONESHOT;
+		unsigned int flags = IRQF_ONESHOT;
 
 		/*
 		 * On ACPI systems the IRQ may be handled by ACPI-event code,
-- 
2.30.2



