Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C73328AAA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239608AbhCASVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:21:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:60786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236131AbhCASNx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:13:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FAE864F9A;
        Mon,  1 Mar 2021 17:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621010;
        bh=zObVs7WjPNun3ujJeSX1WxJemE99x5DRaj5g4eV2zW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rN7eNOxcR/kkuXa9Wl9My+XTM0h8XMKn1dJDBIXZw/8ln2JOmjAniHymyJMZBXLdL
         dLlItBJKa2nfBP8zodvF/NRcDKm6nxd03DIP0QGsNCF5QBGuYLgyboizp14ExtATDu
         /p+Mmv+7CwL52Jy00fFjebmAgF70/e5zR+1Cwy0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arthur Demchenkov <spinal.by@gmail.com>,
        Carl Philipp Klemm <philipp@uvos.xyz>,
        Merlijn Wajer <merlijn@wizzup.org>,
        Pavel Machek <pavel@ucw.cz>, Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 333/775] power: supply: cpcap-battery: Fix missing power_supply_put()
Date:   Mon,  1 Mar 2021 17:08:21 +0100
Message-Id: <20210301161218.075010826@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 97456a24acb41b74ab6910f40fb8f09b206fd3b5 ]

Fix missing power_supply_put().

Cc: Arthur Demchenkov <spinal.by@gmail.com>
Cc: Carl Philipp Klemm <philipp@uvos.xyz>
Cc: Merlijn Wajer <merlijn@wizzup.org>
Cc: Pavel Machek <pavel@ucw.cz>
Fixes: 8b0134cc14b9 ("power: supply: cpcap-battery: Fix handling of lowered charger voltage")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cpcap-battery.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/power/supply/cpcap-battery.c b/drivers/power/supply/cpcap-battery.c
index 7a974b5bd9dd1..cebc5c8fda1b5 100644
--- a/drivers/power/supply/cpcap-battery.c
+++ b/drivers/power/supply/cpcap-battery.c
@@ -561,17 +561,21 @@ static int cpcap_battery_update_charger(struct cpcap_battery_ddata *ddata,
 				POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE,
 				&prop);
 	if (error)
-		return error;
+		goto out_put;
 
 	/* Allow charger const voltage lower than battery const voltage */
 	if (const_charge_voltage > prop.intval)
-		return 0;
+		goto out_put;
 
 	val.intval = const_charge_voltage;
 
-	return power_supply_set_property(charger,
+	error = power_supply_set_property(charger,
 			POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE,
 			&val);
+out_put:
+	power_supply_put(charger);
+
+	return error;
 }
 
 static int cpcap_battery_set_property(struct power_supply *psy,
-- 
2.27.0



