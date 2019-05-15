Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83AB21EFFE
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732116AbfEOL3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:29:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731806AbfEOL3B (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:29:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E696F206BF;
        Wed, 15 May 2019 11:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919741;
        bh=Vs33h3HMAQVmJ+SIVLTPU0qa4/O/E42YM7/d53qafYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AuAxY9m3TRoPcSFQxvzl9eg7Bsy9cROU3Z6nnsX+EMwcxGbq2zp+moxdWQZhVJTU9
         Pad1yW+/6vrH8hqVDBZMo/KHG4LZ70d/BCPTf5P1Cjz0MVO+ngX14n25IyK2JXI9wO
         /Qdko3VgiWnKLCpEkTzqnqUIf/ntBvaLsd0aSpb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 032/137] clocksource/drivers/npcm: select TIMER_OF
Date:   Wed, 15 May 2019 12:55:13 +0200
Message-Id: <20190515090655.659546612@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
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
index 8dfd3bc448d04..9df90daa9c030 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -144,6 +144,7 @@ config VT8500_TIMER
 config NPCM7XX_TIMER
 	bool "NPCM7xx timer driver" if COMPILE_TEST
 	depends on HAS_IOMEM
+	select TIMER_OF
 	select CLKSRC_MMIO
 	help
 	  Enable 24-bit TIMER0 and TIMER1 counters in the NPCM7xx architecture,
-- 
2.20.1



