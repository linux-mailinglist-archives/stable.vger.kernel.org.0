Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04669328E35
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241520AbhCATZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:25:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:46134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241414AbhCATVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:21:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E145664FD1;
        Mon,  1 Mar 2021 17:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621023;
        bh=U2+6gTmH/NBd3LfZo/E+AVn8ZOP80TPgObgc60h1xEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pBNJ0g99QYeY8mv2F7n1UtD+0222KYMhkwvdhbfJCjpizj2kuQvwFfQnilOUcYNOd
         Ol5bU32fPZPbr0buCViSqcI48VapgKXCXtsNCb6gcNyTuIWzX77Qh0LQksnKrRlbZy
         kgK3Habm9aUosDMdIVJDjAVbQSO4gJgsGfDNoTyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 335/775] power: supply: cpcap-charger: Fix power_supply_put on null battery pointer
Date:   Mon,  1 Mar 2021 17:08:23 +0100
Message-Id: <20210301161218.176454023@linuxfoundation.org>
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

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 39196cfe10dd2b46ee28b44abbc0db4f4cb7822f ]

Currently if the pointer battery is null there is a null pointer
dereference on the call to power_supply_put.  Fix this by only
performing the put if battery is not null.

Addresses-Coverity: ("Dereference after null check")
Fixes: 4bff91bb3231 ("power: supply: cpcap-charger: Fix missing power_supply_put()")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cpcap-charger.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/cpcap-charger.c b/drivers/power/supply/cpcap-charger.c
index 2c5f2246c6eaa..22fff01425d63 100644
--- a/drivers/power/supply/cpcap-charger.c
+++ b/drivers/power/supply/cpcap-charger.c
@@ -301,8 +301,9 @@ cpcap_charger_get_bat_const_charge_voltage(struct cpcap_charger_ddata *ddata)
 				&prop);
 		if (!error)
 			voltage = prop.intval;
+
+		power_supply_put(battery);
 	}
-	power_supply_put(battery);
 
 	return voltage;
 }
-- 
2.27.0



