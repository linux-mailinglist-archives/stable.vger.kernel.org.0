Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFE2B5FB694
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbiJKPHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbiJKPHQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 11:07:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E94A5993;
        Tue, 11 Oct 2022 08:00:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E114D611AC;
        Tue, 11 Oct 2022 14:53:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B851C4347C;
        Tue, 11 Oct 2022 14:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665500010;
        bh=Kl9RoFAq3sCIwA5R+gllPUC3sCxEPBv5CtTb6Rfc7FE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sQYNnl3Hxmk8PGBfg1SC8oR6FdL+e+noR94FFVGuxvnq33yy1iQYDOx9uz0/wkOwG
         hssMMTbNIlR4syoIoi2Aftfm6RbUKSYJsBmgNDWCftY5WIgZOSdllLa7LFoner6ftk
         ZfRtT6CfoC6SFDNVgtGk28a4SASwDLGqiKR10z8IorwA/L7+//GMpjtbXBh80idT4t
         +5lhR5dl6dS7pNfByFz8VpPvZ5igxnRBgQ+GUVoIWQnfiAm7vuWi4D+NdT0kJxfokU
         mTYgy5lUoixVK6NFUkp9t5c9jqdGdf/nUahOEHahnl/VMuDJv8ZCsvgmxfZpDfR73o
         iltQDiOC80xRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>, andrew@lunn.ch,
        sebastian.hesselbarth@gmail.com, gregory.clement@bootlin.com,
        linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 12/17] ARM: orion: fix include path
Date:   Tue, 11 Oct 2022 10:53:07 -0400
Message-Id: <20221011145312.1624341-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145312.1624341-1-sashal@kernel.org>
References: <20221011145312.1624341-1-sashal@kernel.org>
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

[ Upstream commit 63872304bdb3decd5454f4dd210c25395278ed13 ]

Now that CONFIG_ARCH_MULTIPLATFORM can be disabled anywhere,
there is a build failure for plat-orion:

arch/arm/plat-orion/irq.c:19:10: fatal error: plat/irq.h: No such file or directory

Make the include path unconditional.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/plat-orion/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/plat-orion/Makefile b/arch/arm/plat-orion/Makefile
index 4e3f25de13c1..830b0be038c6 100644
--- a/arch/arm/plat-orion/Makefile
+++ b/arch/arm/plat-orion/Makefile
@@ -2,7 +2,7 @@
 #
 # Makefile for the linux kernel.
 #
-ccflags-$(CONFIG_ARCH_MULTIPLATFORM) := -I$(srctree)/$(src)/include
+ccflags-y := -I$(srctree)/$(src)/include
 
 orion-gpio-$(CONFIG_GPIOLIB)      += gpio.o
 obj-$(CONFIG_PLAT_ORION_LEGACY)   += irq.o pcie.o time.o common.o mpp.o
-- 
2.35.1

