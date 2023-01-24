Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2664C6799D7
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234271AbjAXNmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234040AbjAXNmQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:42:16 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F239457E6;
        Tue, 24 Jan 2023 05:42:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 79642CE1B21;
        Tue, 24 Jan 2023 13:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85ACEC433A8;
        Tue, 24 Jan 2023 13:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567716;
        bh=WZl2eKdtabjmBmr+WssfJF8VVwfHHWPXijY6QfNZVV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TCAvcOXtBNLSW3PzOF7d/JpKQXvQIBrrJX/m0MS6W6rZJSDfwVyH/p9fGAXR0jeve
         k5VgYWC97qBgJu3bd0LFyF6j+PTYCZ/HFrF1T689maVW5sVeXgSAF6ucsR1hPgftdW
         cbZQXo3yTItquCEioAV2N5W7ZXxJIx5S8wraJNaxSVmFB229IcEHXvM2ZMyz36Qw+x
         Yba0VSqOoCT6V+oJOaAdvkUJ8ZOY0U6FoxXloyzx1K5362viRA4CvvzX8yYZ6uguXr
         nt7f+37M3MBsQqGtL/74ClU/aeYF11yfehnry5/uj8oh8Hhx6knPSBy7wWBriKORPS
         JR09BdPSjORQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sasha Levin <sashal@kernel.org>, jmkrzyszt@gmail.com,
        tony@atomide.com, linux@armlinux.org.uk,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.1 10/35] ARM: omap1: fix building gpio15xx
Date:   Tue, 24 Jan 2023 08:41:06 -0500
Message-Id: <20230124134131.637036-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134131.637036-1-sashal@kernel.org>
References: <20230124134131.637036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 9d46ce57f4d1c626bb48170226ea5e35deb5877c ]

In some randconfig builds, the asm/irq.h header is not included
in gpio15xx.c, so add an explicit include to avoid a build fialure:

In file included from arch/arm/mach-omap1/gpio15xx.c:15:
arch/arm/mach-omap1/irqs.h:99:34: error: 'NR_IRQS_LEGACY' undeclared here (not in a function)
   99 | #define IH2_BASE                (NR_IRQS_LEGACY + 32)
      |                                  ^~~~~~~~~~~~~~
arch/arm/mach-omap1/irqs.h:105:38: note: in expansion of macro 'IH2_BASE'
  105 | #define INT_MPUIO               (5 + IH2_BASE)
      |                                      ^~~~~~~~
arch/arm/mach-omap1/gpio15xx.c:28:27: note: in expansion of macro 'INT_MPUIO'
   28 |                 .start  = INT_MPUIO,
      |                           ^~~~~~~~~

Acked-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap1/gpio15xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap1/gpio15xx.c b/arch/arm/mach-omap1/gpio15xx.c
index c675f11de99d..61fa26efd865 100644
--- a/arch/arm/mach-omap1/gpio15xx.c
+++ b/arch/arm/mach-omap1/gpio15xx.c
@@ -11,6 +11,7 @@
 #include <linux/gpio.h>
 #include <linux/platform_data/gpio-omap.h>
 #include <linux/soc/ti/omap1-soc.h>
+#include <asm/irq.h>
 
 #include "irqs.h"
 
-- 
2.39.0

