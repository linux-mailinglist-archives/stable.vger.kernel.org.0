Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67E42A90A7
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390170AbfIDSK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:10:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390198AbfIDSK5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:10:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1DD12087E;
        Wed,  4 Sep 2019 18:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620657;
        bh=+CyUkE+H/8l3WaDV/04VyoPmGhpoJr8ns5AR1Hn6Qqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eyvajwcrUFz0dSBbCcPJPOzh2WUmYRmtQ+wfxdacy/+BZVYoxqrAlI829uDQPBAsH
         Q8Z9Y2mzvF6A49BgW/Ql0JHiwebYIOXNmZeZMZntuEDYFIcH+C6vtYUHUorCaLx8Zy
         7Niac9Gjcxn5LVlf6nU931e8ZITy0enN8hukekCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <wahrenst@gmx.net>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 045/143] watchdog: bcm2835_wdt: Fix module autoload
Date:   Wed,  4 Sep 2019 19:53:08 +0200
Message-Id: <20190904175315.832873991@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 215e06f0d18d5d653d6ea269e4dfc684854d48bf ]

The commit 5e6acc3e678e ("bcm2835-pm: Move bcm2835-watchdog's DT probe
to an MFD.") broke module autoloading on Raspberry Pi. So add a
module alias this fix this.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/bcm2835_wdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/bcm2835_wdt.c b/drivers/watchdog/bcm2835_wdt.c
index 560c1c54c1779..f4937a91e5160 100644
--- a/drivers/watchdog/bcm2835_wdt.c
+++ b/drivers/watchdog/bcm2835_wdt.c
@@ -240,6 +240,7 @@ module_param(nowayout, bool, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
+MODULE_ALIAS("platform:bcm2835-wdt");
 MODULE_AUTHOR("Lubomir Rintel <lkundrak@v3.sk>");
 MODULE_DESCRIPTION("Driver for Broadcom BCM2835 watchdog timer");
 MODULE_LICENSE("GPL");
-- 
2.20.1



