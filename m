Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC16328A57
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239482AbhCASP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:15:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:58156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234234AbhCASI4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:08:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6E7C64F56;
        Mon,  1 Mar 2021 17:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620979;
        bh=oFvtRJ6XI/H3L4BODR1F8GGrS7JiyuCCfqcE4h/dDPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xYoKVEcKuQdzKSLpweISLTZRN02ojfDeMBxE85h8lUuoTLFZJ4Dm4Pfx7jzlgXM/u
         lXuu61ucZV7aFuwZm+0NESaDnGMZoYHCA9vrX2KsCx9RaceIcllXBrMHPS3COwhgcc
         Nf3Fcogh0HpxQmjtp5mpjh9r6HVoFkIgf5o+vsJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arthur Demchenkov <spinal.by@gmail.com>,
        Carl Philipp Klemm <philipp@uvos.xyz>,
        Merlijn Wajer <merlijn@wizzup.org>,
        Pavel Machek <pavel@ucw.cz>, Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 332/775] power: supply: cpcap-charger: Fix missing power_supply_put()
Date:   Mon,  1 Mar 2021 17:08:20 +0100
Message-Id: <20210301161218.025655607@linuxfoundation.org>
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

[ Upstream commit 4bff91bb3231882b530af794c92ac3a5fe199481 ]

Fix missing power_supply_put().

Cc: Arthur Demchenkov <spinal.by@gmail.com>
Cc: Carl Philipp Klemm <philipp@uvos.xyz>
Cc: Merlijn Wajer <merlijn@wizzup.org>
Cc: Pavel Machek <pavel@ucw.cz>
Fixes: 5688ea049233 ("power: supply: cpcap-charger: Allow changing constant charge voltage")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cpcap-charger.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/supply/cpcap-charger.c b/drivers/power/supply/cpcap-charger.c
index 804ac7f84c301..2c5f2246c6eaa 100644
--- a/drivers/power/supply/cpcap-charger.c
+++ b/drivers/power/supply/cpcap-charger.c
@@ -302,6 +302,7 @@ cpcap_charger_get_bat_const_charge_voltage(struct cpcap_charger_ddata *ddata)
 		if (!error)
 			voltage = prop.intval;
 	}
+	power_supply_put(battery);
 
 	return voltage;
 }
-- 
2.27.0



