Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239206B456F
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbjCJOdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbjCJOdY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:33:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D953E4AFF7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:33:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C656B822DA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74093C433EF;
        Fri, 10 Mar 2023 14:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458789;
        bh=vqlWkucSLYOnNk+7/tzybszhBlrvVcLE9QqytjMe1lk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qkpVg7pc0OIzNb0mOJcEL1lMJgBAo2MY07682pBhFt4J3+vL7bT8Lsari1wXKrQg+
         OEARUW7OWe/Hol2OJ5t0tQJ2EPpORSEKOnYwxavue+0fBhTVAg3VqHX4WSXPDlxqGx
         QDOlpJq1kH3sEaRuc7Udlsgnrnvju8Huzzqd1AWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kirill Tkhai <tkhai@yandex.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 145/357] sparc: allow PM configs for sparc32 COMPILE_TEST
Date:   Fri, 10 Mar 2023 14:37:14 +0100
Message-Id: <20230310133741.105495213@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 7be6a87c2473957090995b7eb541e31d57a2c801 ]

When doing randconfig builds for sparc32 with COMPILE_TEST, some
(non-Sparc) drivers cause kconfig warnings with the Kconfig symbols PM,
PM_GENERIC_DOMAINS, or PM_GENERIC_DOMAINS_OF.

This is due to arch/sparc/Kconfig not using the PM Kconfig for
Sparc32:

  if SPARC64
  source "kernel/power/Kconfig"
  endif

Arnd suggested adding "|| COMPILE_TEST" to the conditional,
instead of trying to track down every driver that selects
any of these PM symbols.

Fixes the following kconfig warnings:

WARNING: unmet direct dependencies detected for PM
  Depends on [n]: SPARC64 [=n]
  Selected by [y]:
  - SUN20I_PPU [=y] && (ARCH_SUNXI || COMPILE_TEST [=y])

WARNING: unmet direct dependencies detected for PM
  Depends on [n]: SPARC64 [=n]
  Selected by [y]:
  - SUN20I_PPU [=y] && (ARCH_SUNXI || COMPILE_TEST [=y])

WARNING: unmet direct dependencies detected for PM_GENERIC_DOMAINS
  Depends on [n]: SPARC64 [=n] && PM [=y]
  Selected by [y]:
  - QCOM_GDSC [=y] && COMMON_CLK [=y] && PM [=y]
  - SUN20I_PPU [=y] && (ARCH_SUNXI || COMPILE_TEST [=y])
  - MESON_GX_PM_DOMAINS [=y] && (ARCH_MESON || COMPILE_TEST [=y]) && PM [=y] && OF [=y]
  - BCM2835_POWER [=y] && (ARCH_BCM2835 || COMPILE_TEST [=y] && OF [=y]) && PM [=y]
  - BCM_PMB [=y] && (ARCH_BCMBCA || COMPILE_TEST [=y] && OF [=y]) && PM [=y]
  - ROCKCHIP_PM_DOMAINS [=y] && (ARCH_ROCKCHIP || COMPILE_TEST [=y]) && PM [=y]
  Selected by [m]:
  - ARM_SCPI_POWER_DOMAIN [=m] && (ARM_SCPI_PROTOCOL [=m] || COMPILE_TEST [=y] && OF [=y]) && PM [=y]
  - MESON_EE_PM_DOMAINS [=m] && (ARCH_MESON || COMPILE_TEST [=y]) && PM [=y] && OF [=y]
  - QCOM_AOSS_QMP [=m] && (ARCH_QCOM || COMPILE_TEST [=y]) && MAILBOX [=y] && COMMON_CLK [=y] && PM [=y]

WARNING: unmet direct dependencies detected for PM_GENERIC_DOMAINS_OF
  Depends on [n]: SPARC64 [=n] && PM_GENERIC_DOMAINS [=y] && OF [=y]
  Selected by [y]:
  - MESON_GX_PM_DOMAINS [=y] && (ARCH_MESON || COMPILE_TEST [=y]) && PM [=y] && OF [=y]
  Selected by [m]:
  - MESON_EE_PM_DOMAINS [=m] && (ARCH_MESON || COMPILE_TEST [=y]) && PM [=y] && OF [=y]

Link: https://lkml.kernel.org/r/20230205004357.29459-1-rdunlap@infradead.org
Fixes: bdde6b3c8ba4 ("sparc64: Hibernation support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Kirill Tkhai <tkhai@yandex.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 349e27771ceaf..8cb5bb020b4b6 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -321,7 +321,7 @@ config FORCE_MAX_ZONEORDER
 	  This config option is actually maximum order plus one. For example,
 	  a value of 13 means that the largest free memory block is 2^12 pages.
 
-if SPARC64
+if SPARC64 || COMPILE_TEST
 source "kernel/power/Kconfig"
 endif
 
-- 
2.39.2



