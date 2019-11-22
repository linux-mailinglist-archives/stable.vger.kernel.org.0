Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE23C1065C6
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbfKVG0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:26:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:55610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727867AbfKVFur (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FDAB20726;
        Fri, 22 Nov 2019 05:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401847;
        bh=5NqZWv/lrf+4gV1AJubypYGwHZ9tJ+dRz9dCQ+jRxVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dXNXADBtlCp6WTkeO2bkbAJBQtoFyqxszwk3oLpjv17K/Yq1xBkfvN0YTVOarcvS5
         UTXO0UreHZzj924LAsk3Qj+bnCxahhIzPUG0I3q114X27veM7WijYPW+hdVuPLbDUA
         wua7edgmB88ooWSBJwceer4F48IFLlSk0vzCi6b0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Ladislav Michl <ladis@linux-mips.org>,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 085/219] memory: omap-gpmc: Get the header of the enum
Date:   Fri, 22 Nov 2019 00:46:57 -0500
Message-Id: <20191122054911.1750-78-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

