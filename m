Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528EE2E4161
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439065AbgL1PFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:05:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:45022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439059AbgL1OKh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:10:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E341920791;
        Mon, 28 Dec 2020 14:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164596;
        bh=7Ft/XUMKKsohRnffoVmtAMZzEzvC8B567WmWQE2bDs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o412OZWkXXBlEUzTYvROxgpGYNEjqkxWFQX/3zAJYzrM4dR2Y/qqk+YyRX1a/UOKH
         merO+pyaiZQfXmr0O8QM+zH/vZKMZOcrdqwffiTshWHsJB9qOJrM+cz9bgDfl7cqc3
         117GEyuP6ypL6uKoXSDYxElcRTVGcs58QweMz99s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Timon Baetz <timon.baetz@protonmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 230/717] power: supply: max17042_battery: Fix current_{avg,now} hiding with no current sense
Date:   Mon, 28 Dec 2020 13:43:48 +0100
Message-Id: <20201228125032.007643995@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

[ Upstream commit 4b0a56e692503692da6555337a697c17feabbb3e ]

When current sense is disabled, max17042_no_current_sense_psy_desc gets
used which ignores two last properties from the list.

Fixes: 21b01cc879cc ("power: supply: max17042_battery: Add support for the TTE_NOW prop")
Reported-by: Timon Baetz <timon.baetz@protonmail.com>
Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/max17042_battery.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/max17042_battery.c b/drivers/power/supply/max17042_battery.c
index f284547913d6f..2e9672fe4df1f 100644
--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -85,9 +85,10 @@ static enum power_supply_property max17042_battery_props[] = {
 	POWER_SUPPLY_PROP_TEMP_MAX,
 	POWER_SUPPLY_PROP_HEALTH,
 	POWER_SUPPLY_PROP_SCOPE,
+	POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW,
+	// these two have to be at the end on the list
 	POWER_SUPPLY_PROP_CURRENT_NOW,
 	POWER_SUPPLY_PROP_CURRENT_AVG,
-	POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW,
 };
 
 static int max17042_get_temperature(struct max17042_chip *chip, int *temp)
-- 
2.27.0



