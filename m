Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5894A1EE75
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730739AbfEOLVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:21:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731342AbfEOLVw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:21:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE6C320881;
        Wed, 15 May 2019 11:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919312;
        bh=/jBHW+2TNSFoJi5HgXdm+/hCQ+Jojsit8Vqm+c1mV3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k8KLpqc0hdstDIV5w2GubVR01/8fxZuCi6G6pIeKuaGYqKyyiqkySw5mqm7NcMXX0
         f7GS7VQO172fpHw4fVbSX2L+wdjTYjWn7ApmQyfsSWZNn41lioaG3f3npe2EjWIQSq
         rZA0Jzmr/MCtSSDsjMpdiIusTipMyYP4j5XsR62E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 027/113] clocksource/drivers/npcm: select TIMER_OF
Date:   Wed, 15 May 2019 12:55:18 +0200
Message-Id: <20190515090655.577623764@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 99834eead2a04e93a120abb112542b87c42ff5e1 ]

When this is disabled, we get a link failure:

drivers/clocksource/timer-npcm7xx.o: In function `npcm7xx_timer_init':
timer-npcm7xx.c:(.init.text+0xf): undefined reference to `timer_of_init'

Fixes: 1c00289ecd12 ("clocksource/drivers/npcm: Add NPCM7xx timer driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index c1ddafa4c2994..4d37f018d846c 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -136,6 +136,7 @@ config VT8500_TIMER
 config NPCM7XX_TIMER
 	bool "NPCM7xx timer driver" if COMPILE_TEST
 	depends on HAS_IOMEM
+	select TIMER_OF
 	select CLKSRC_MMIO
 	help
 	  Enable 24-bit TIMER0 and TIMER1 counters in the NPCM7xx architecture,
-- 
2.20.1



