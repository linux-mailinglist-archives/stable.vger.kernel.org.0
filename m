Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2BAF45C084
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344788AbhKXNJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:09:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347226AbhKXNHU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:07:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7353A61A3C;
        Wed, 24 Nov 2021 12:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757511;
        bh=RkwHq1cRwgCLq/qexO1dmHvG2QeRPD46hOCbh35QAlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kM0Si0MC3Wcm/NvZcaBGikJnzL/xE2Q9wEPbV42tt9CKDgoLKW/NTPSicEnkpVVo+
         Fq7eSFiBdnRdCexpetp9H5hJg3WwdnbVdVSWw6wdYegfPHjQyO2FduVIVc2b+hGyF9
         +HgfrjhFjoxGb+cZweQw4bVxpyCOl2F1oRSeHddU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Tony Lindgren <tony@atomide.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Keerthy <j-keerthy@ti.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Ladislav Michl <ladis@linux-mips.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        linux-omap@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 160/323] clocksource/drivers/timer-ti-dm: Select TIMER_OF
Date:   Wed, 24 Nov 2021 12:55:50 +0100
Message-Id: <20211124115724.327164032@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit eda9a4f7af6ee47e9e131f20e4f8a41a97379293 ]

When building OMAP_DM_TIMER without TIMER_OF, there are orphan sections
due to the use of TIMER_OF_DELCARE() without CONFIG_TIMER_OF. Select
CONFIG_TIMER_OF when enaling OMAP_DM_TIMER:

arm-linux-gnueabi-ld: warning: orphan section `__timer_of_table' from `drivers/clocksource/timer-ti-dm-systimer.o' being placed in section `__timer_of_table'

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/lkml/202108282255.tkdt4ani-lkp@intel.com/
Cc: Tony Lindgren <tony@atomide.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Keerthy <j-keerthy@ti.com>
Cc: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: Ladislav Michl <ladis@linux-mips.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: linux-omap@vger.kernel.org
Fixes: 52762fbd1c47 ("clocksource/drivers/timer-ti-dm: Add clockevent and clocksource support")
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20210828175747.3777891-1-keescook@chromium.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 4d37f018d846c..06504384c3765 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -23,6 +23,7 @@ config I8253_LOCK
 
 config OMAP_DM_TIMER
 	bool
+	select TIMER_OF
 
 config CLKBLD_I8253
 	def_bool y if CLKSRC_I8253 || CLKEVT_I8253 || I8253_LOCK
-- 
2.33.0



