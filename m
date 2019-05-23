Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA2B9286DD
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388130AbfEWTNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:13:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387801AbfEWTNn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:13:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73F2A20863;
        Thu, 23 May 2019 19:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638822;
        bh=wDrD/fDJJ7TXM+EKX2yzv/zboJ9hPm4L6LJm/+znrbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=itieRdrFlN6ySInUNR32hEdiJ1H0iu9wCljAnYdiM3FeBYTA8IL63EfH8y9QZU84u
         SsRbLbff5uAM4yuD4S2vDr0xF0v4CQ1a/MVoJEIs/mLbOVBIpuot1HnhpSWap/UjO8
         NaLw+3Euvl8zyMYinM+oKBCA+Z8nBylgzThA0m/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 61/77] power: supply: cpcap-battery: Fix division by zero
Date:   Thu, 23 May 2019 21:06:19 +0200
Message-Id: <20190523181728.409484885@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181719.982121681@linuxfoundation.org>
References: <20190523181719.982121681@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit dbe7208c6c4aec083571f2ec742870a0d0edbea3 ]

If called fast enough so samples do not increment, we can get
division by zero in kernel:

__div0
cpcap_battery_cc_raw_div
cpcap_battery_get_property
power_supply_get_property.part.1
power_supply_get_property
power_supply_show_property
power_supply_uevent

Fixes: 874b2adbed12 ("power: supply: cpcap-battery: Add a battery driver")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cpcap-battery.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/power/supply/cpcap-battery.c b/drivers/power/supply/cpcap-battery.c
index ee71a2b37b12c..fe7fcf3a2ad03 100644
--- a/drivers/power/supply/cpcap-battery.c
+++ b/drivers/power/supply/cpcap-battery.c
@@ -221,6 +221,9 @@ static int cpcap_battery_cc_raw_div(struct cpcap_battery_ddata *ddata,
 	int avg_current;
 	u32 cc_lsb;
 
+	if (!divider)
+		return 0;
+
 	sample &= 0xffffff;		/* 24-bits, unsigned */
 	offset &= 0x7ff;		/* 10-bits, signed */
 
-- 
2.20.1



