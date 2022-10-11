Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6AA65FB797
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiJKPoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiJKPnV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 11:43:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6982043ACE;
        Tue, 11 Oct 2022 08:33:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDE33611C6;
        Tue, 11 Oct 2022 14:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53352C43143;
        Tue, 11 Oct 2022 14:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665500074;
        bh=poWo66Ew23pjdPqCySrVu6RmHwqjHqXtnGvPjkXg3qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B4qBdYry9ww6dWsESk9mA+brGkQPIZe0k+IJSgb7nA1cL2jD1U6D7Ml4kmrDYf7eE
         8PlIFfp9wVzrvUMIG/dQqgMnx6o3dnLtHqro3G7CptXluQhXIsmJ3hJzOqoT0Vi/Uy
         22WeGZzW28rhpGZMaObFGy5OgeRE7UxmieZxo7fGKtl6Q1anmm/LbNGIrccAJXie6P
         IYMsP5xZ8LFD/4ia06j3HkTY9OroOBh2sReADDEnQVGCnofVBI2liWrubINgtzE4BC
         LMtiCbJGCLSb/ZegsxL5/v6N2kOiXpLvEceTVtfrOqoaDuWvxtH7XmRHjNMEQrtBqA
         A1Xc+jjEeRt5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>, andrew@lunn.ch,
        sebastian.hesselbarth@gmail.com, gregory.clement@bootlin.com,
        linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 6/6] ARM: orion: fix include path
Date:   Tue, 11 Oct 2022 10:54:25 -0400
Message-Id: <20221011145425.1625494-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145425.1625494-1-sashal@kernel.org>
References: <20221011145425.1625494-1-sashal@kernel.org>
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
index 9433605cd290..06c3530d8ad5 100644
--- a/arch/arm/plat-orion/Makefile
+++ b/arch/arm/plat-orion/Makefile
@@ -1,7 +1,7 @@
 #
 # Makefile for the linux kernel.
 #
-ccflags-$(CONFIG_ARCH_MULTIPLATFORM) := -I$(srctree)/$(src)/include
+ccflags-y := -I$(srctree)/$(src)/include
 
 orion-gpio-$(CONFIG_GPIOLIB)      += gpio.o
 obj-$(CONFIG_PLAT_ORION_LEGACY)   += irq.o pcie.o time.o common.o mpp.o
-- 
2.35.1

