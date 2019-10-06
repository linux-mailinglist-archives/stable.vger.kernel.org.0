Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 550E5CD64E
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731715AbfJFRop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:44:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731707AbfJFRop (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:44:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE4B1214D9;
        Sun,  6 Oct 2019 17:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383884;
        bh=5CWtG3b29b2lb4NXYKOeC/Hsp5itJeKwBFIVJ43OSLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a01aIYltzTeBQixhCl8dPRgRzl3BSNlNMq5fpfigImta1KhO3TTojsR0MCCAV6l8o
         GIsVNqNnlRNcbhwgifHT9C6SbR4KrrMgKpBnfGotMZUzTxM2j/UHzBzUnyeKnn5qT1
         B/9mJEVsJbem/uQkwM5n6t/6cbZwBxbU5+35D4WM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        kbuild test robot <lkp@intel.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 089/166] rtc: bd70528: fix driver dependencies
Date:   Sun,  6 Oct 2019 19:20:55 +0200
Message-Id: <20191006171221.032766634@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>

[ Upstream commit 41a8e19f47dfe9154c56b35842700ad38a7c33e0 ]

With CONFIG_BD70528_WATCHDOG=m, a built-in rtc driver cannot call
into the low-level functions that are part of the watchdog module:

drivers/rtc/rtc-bd70528.o: In function `bd70528_set_time':
rtc-bd70528.c:(.text+0x22c): undefined reference to `bd70528_wdt_lock'
rtc-bd70528.c:(.text+0x2a8): undefined reference to `bd70528_wdt_unlock'
drivers/rtc/rtc-bd70528.o: In function `bd70528_set_rtc_based_timers':
rtc-bd70528.c:(.text+0x50c): undefined reference to `bd70528_wdt_set'

Add a Kconfig dependency which forces RTC to be a module if watchdog is a
module. If watchdog is not compiled at all the stub functions for watchdog
control are used. compiling the RTC without watchdog is fine.

Fixes: 32a4a4ebf768 ("rtc: bd70528: Initial support for ROHM bd70528 RTC")
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Link: https://lore.kernel.org/r/84462e01e43d39024948a3bdd24087ff87dc2255.1565591387.git.matti.vaittinen@fi.rohmeurope.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index e72f65b61176d..add43c3374895 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -500,6 +500,7 @@ config RTC_DRV_M41T80_WDT
 	  watchdog timer in the ST M41T60 and M41T80 RTC chips series.
 config RTC_DRV_BD70528
 	tristate "ROHM BD70528 PMIC RTC"
+	depends on MFD_ROHM_BD70528 && (BD70528_WATCHDOG || !BD70528_WATCHDOG)
 	help
 	  If you say Y here you will get support for the RTC
 	  on ROHM BD70528 Power Management IC.
-- 
2.20.1



