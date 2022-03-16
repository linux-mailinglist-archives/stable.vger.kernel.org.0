Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F74F4DB29D
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241508AbiCPOSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356487AbiCPOSW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:18:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 118FC692A3;
        Wed, 16 Mar 2022 07:16:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 995CDB81B7D;
        Wed, 16 Mar 2022 14:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E76CC340EC;
        Wed, 16 Mar 2022 14:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647440216;
        bh=WShbQXSabFJ84DUQ7BZubSHOJSxU09EfsVqM5MsbdRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SYNQq1XiDvIRrZ7ReNqbHN3If/K03Dl1f5gKFdJp9dGTIIAdAeW3b5irPeHPh8u7d
         ceFAGhZraODnVrTl+TAuxUTtUvRTdF07uHHXIjYxdm8aHUdOKpnxb4cQ7qSbfvAIdd
         BVVbxqIaizlJttyc5tNNo570V2afmfeqn0hrxzeASKh7iqZxQFKCNbVKAodb8m737B
         rc44qztsJ4ZCuPDjCFIyK2r9PCgXuz1yZlcTYob78lq3MsXxiBXHwjtW2Tynza77GT
         mF8QXjN7GewNbdguDMOQmrMHRdZVeRE4jHa4C7yYI0wiXSxLkAysTkHvJhCZvNyt26
         3lBKzMpykR3Bw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Palmer <daniel@0x0f.com>, Arnd Bergmann <arnd@arndb.de>,
        Sasha Levin <sashal@kernel.org>, daniel@thingy.jp,
        romain.perier@gmail.com, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 04/12] ARM: mstar: Select HAVE_ARM_ARCH_TIMER
Date:   Wed, 16 Mar 2022 10:16:28 -0400
Message-Id: <20220316141636.248324-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220316141636.248324-1-sashal@kernel.org>
References: <20220316141636.248324-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Palmer <daniel@0x0f.com>

[ Upstream commit ea49432d184a6a09f84461604b7711a4e9f5ec9c ]

The mstar SoCs have an arch timer but HAVE_ARM_ARCH_TIMER wasn't
selected. If MSC313E_TIMER isn't selected then the kernel gets
stuck at boot because there are no timers available.

Signed-off-by: Daniel Palmer <daniel@0x0f.com>
Link: https://lore.kernel.org/r/20220301104349.3040422-1-daniel@0x0f.com'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-mstar/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-mstar/Kconfig b/arch/arm/mach-mstar/Kconfig
index 576d1ab293c8..30560fdf87ed 100644
--- a/arch/arm/mach-mstar/Kconfig
+++ b/arch/arm/mach-mstar/Kconfig
@@ -3,6 +3,7 @@ menuconfig ARCH_MSTARV7
 	depends on ARCH_MULTI_V7
 	select ARM_GIC
 	select ARM_HEAVY_MB
+	select HAVE_ARM_ARCH_TIMER
 	select MST_IRQ
 	help
 	  Support for newer MStar/Sigmastar SoC families that are
-- 
2.34.1

