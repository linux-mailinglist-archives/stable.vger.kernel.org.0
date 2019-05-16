Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 689C1205D8
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 13:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbfEPLkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 07:40:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbfEPLkk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 07:40:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7629E20833;
        Thu, 16 May 2019 11:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006840;
        bh=aPpF74asY5kHDrkay7c2MpxiyGQsuQ60iTO7Rb3MIVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e/mK02O8AMqnjNKWtWTHvN1tOpUZ0Fx72y8iwXbjpZnhGeoNmaVle+UNyDSYDkmLx
         dbGS6r7sgWlqTXJRUAzTcm2GMhTWqf7hbnW8rL6K1+rN21DlA4fU2GT6RpFVzMNQXD
         oS/fcj4AoOyWHfFlyj0YMOiZfDJTFvuFPYcUt2rU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 09/25] power: supply: cpcap-battery: Fix division by zero
Date:   Thu, 16 May 2019 07:40:12 -0400
Message-Id: <20190516114029.8682-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516114029.8682-1-sashal@kernel.org>
References: <20190516114029.8682-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

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
index 98ba07869c3b0..3bae02380bb22 100644
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

