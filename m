Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B765FB630
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbiJKPBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbiJKO7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:59:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D396359;
        Tue, 11 Oct 2022 07:55:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE849611F5;
        Tue, 11 Oct 2022 14:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28431C43142;
        Tue, 11 Oct 2022 14:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665500065;
        bh=poWo66Ew23pjdPqCySrVu6RmHwqjHqXtnGvPjkXg3qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nJjo1Qynhj8fL7Jtb/B47PLQ7n69eXvL7WjPjSh2EWY8TlqleoamZqHFsnG1B7nU9
         cEfjgJBHhuU2Whzwlk84/JGH5Nf8Dq/skslLVvLSiG45Q9zj9hfA56k3AjCM4ydUAS
         rT0fSmxAzViDMLJsALjCIm33AORddVDios/KzV28qP9p4LY/U0ZInjPtND5TCujwY1
         sJdILucQrz7IdUdKCrUsNi+MoQhEji17qg0nvxjaqXbXeqwPzWZ51j2BljYNZjftw+
         x1XVuO6zeh6BlXexgEofAdOy4Z4QNRLw+Nm3zOL7C8N4HwTDk8Kqvs2raYc3vdpW54
         L9FDGVz3btt2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>, andrew@lunn.ch,
        sebastian.hesselbarth@gmail.com, gregory.clement@bootlin.com,
        linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 7/7] ARM: orion: fix include path
Date:   Tue, 11 Oct 2022 10:54:14 -0400
Message-Id: <20221011145414.1625237-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145414.1625237-1-sashal@kernel.org>
References: <20221011145414.1625237-1-sashal@kernel.org>
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

