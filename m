Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EECFF289D5
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389079AbfEWTS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:18:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389714AbfEWTS5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:18:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAD1E20863;
        Thu, 23 May 2019 19:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639137;
        bh=oaJYnaQdqWOwuiA3j1Yxlk+IcB46rchR/4L+SMQ/m4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GV8i9sIaufWocFm2ROpm+wQKN+QyvefmBHjsURZLF2+ZnTyjDJPOXEx6rrpKW5WFu
         s45GsW2X2/+72gwylVo+SPcPMZlB2WNDa8dsXnoSkLjlVNGMuJsRLkpGFbAgDTL/yy
         fbmQNxKiXe8SefNEhSwA0hzzc9avkj16sVAFGBbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 091/114] power: supply: cpcap-battery: Fix division by zero
Date:   Thu, 23 May 2019 21:06:30 +0200
Message-Id: <20190523181739.726666171@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
References: <20190523181731.372074275@linuxfoundation.org>
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



