Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3A8A111EB9
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730056AbfLCXDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:03:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729811AbfLCWwc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:52:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5E6720865;
        Tue,  3 Dec 2019 22:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413552;
        bh=5NqZWv/lrf+4gV1AJubypYGwHZ9tJ+dRz9dCQ+jRxVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=itUQo19btgEPs4TlaeL5KmDBZkU+6FUn3xlqA3G5buf82zG56iZEA1v6z5zNWK/Sg
         70omz4nAi9S37E1gkSFE+7M+LcuCX5E1Dh9kV8+r4h1Bv4lfu7BnMzLUkstLDzSerk
         gyblJnOPUj9NFjlshn40tjK8dhtqKrvsX3gpjJTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ladislav Michl <ladis@linux-mips.org>,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 131/321] memory: omap-gpmc: Get the header of the enum
Date:   Tue,  3 Dec 2019 23:33:17 +0100
Message-Id: <20191203223433.967451527@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit a0752e9c3097b2c4fccd618802938e0951038dfa ]

Commit 21abf103818a
("gpio: Pass a flag to gpiochip_request_own_desc()")
started to pass an enum gpiod_flags but this file is
not including the header file that defines that enum
and the compiler spits:

drivers/memory/omap-gpmc.c: In function
			    'gpmc_probe_generic_child':
drivers/memory/omap-gpmc.c:2174:9: error: type of formal
				   parameter 4 is incomplete
         0);
         ^

Cc: Ladislav Michl <ladis@linux-mips.org>
Cc: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 21abf103818a ("gpio: Pass a flag to gpiochip_request_own_desc()")
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/omap-gpmc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/memory/omap-gpmc.c b/drivers/memory/omap-gpmc.c
index c215287e80cf3..1c6a7c16e0c17 100644
--- a/drivers/memory/omap-gpmc.c
+++ b/drivers/memory/omap-gpmc.c
@@ -21,6 +21,7 @@
 #include <linux/spinlock.h>
 #include <linux/io.h>
 #include <linux/gpio/driver.h>
+#include <linux/gpio/consumer.h> /* GPIO descriptor enum */
 #include <linux/interrupt.h>
 #include <linux/irqdomain.h>
 #include <linux/platform_device.h>
-- 
2.20.1



