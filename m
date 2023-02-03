Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281A96895B9
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbjBCKWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233364AbjBCKWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:22:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0E09D04C
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:22:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69D8A61EC2
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33BAFC4339E;
        Fri,  3 Feb 2023 10:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419703;
        bh=WZl2eKdtabjmBmr+WssfJF8VVwfHHWPXijY6QfNZVV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=deBI4TwsW6IUYQFIaTGU+4s0z8QQuo4Fk5wxNtcjMJnweT03txGVsCbXbSzXDEB9H
         bCmcRTqCf1jFSXqrcn+dl8KVPmZuukZ0modcxppq8LYniNBNXA+ygVTqLGAunsN4Sm
         q3huiIStFhR5EsUda/FlFZ6KlMEwodb2k04O8pzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 10/28] ARM: omap1: fix building gpio15xx
Date:   Fri,  3 Feb 2023 11:12:58 +0100
Message-Id: <20230203101010.410641102@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
References: <20230203101009.946745030@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



