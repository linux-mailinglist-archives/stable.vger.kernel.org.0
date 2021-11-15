Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C305450E02
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240463AbhKOSJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:09:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:46092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239850AbhKOSEy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:04:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ED3763274;
        Mon, 15 Nov 2021 17:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997978;
        bh=QNkBOXerpcpHEfQOVpQVhKG2iNCf4nEvew5Iw5lWYuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DqW3SrvaObnHhKtBGMgod3klXj2joQhOA1V2AjJZZ2qur/Y37zBmD/s8WJG8W2YUm
         5QSW3jjDAqEH/B8IGCwp+Qx0eWVQ3OV4KsDN75q9QORfxSx/QJ/Tq4MMkN4zAWUk1e
         +ykxzbWf1L9t8bAgdikJeFcPcEVHkQS8Q4JUpoJU=
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
Subject: [PATCH 5.10 343/575] clocksource/drivers/timer-ti-dm: Select TIMER_OF
Date:   Mon, 15 Nov 2021 18:01:08 +0100
Message-Id: <20211115165355.663142735@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 39f4d88662002..a0c6e88bebe08 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -24,6 +24,7 @@ config I8253_LOCK
 
 config OMAP_DM_TIMER
 	bool
+	select TIMER_OF
 
 config CLKBLD_I8253
 	def_bool y if CLKSRC_I8253 || CLKEVT_I8253 || I8253_LOCK
-- 
2.33.0



