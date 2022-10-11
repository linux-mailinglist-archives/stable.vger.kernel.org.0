Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 041BB5FB534
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiJKOwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbiJKOvM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:51:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D2198C8D;
        Tue, 11 Oct 2022 07:50:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5C19B81626;
        Tue, 11 Oct 2022 14:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D8DC433D7;
        Tue, 11 Oct 2022 14:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499852;
        bh=Kl9RoFAq3sCIwA5R+gllPUC3sCxEPBv5CtTb6Rfc7FE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WOonjs7iJS/HcqPDoIHw4YEe5yT74G+E/DJC+T6087gKwNmJYtCelgxVQ+vSwdUIO
         9ps/o+pr01fK+PR0VQlj1Nl58++W8LNAI5SiFr46TeWisNh9tKalMSbi7QRxH855y7
         oEykX92P98PRuJUKwAQwGe8VRF/a2P56GgU2tVF+ccDorau4gpsHvIqKoR/uoOPmEN
         MSsNGmFm2PmmzXSHFRgj0ahrF8IkmXRc1mCDe3Fkr+R+2wpBD+9eHiUE9kdYVDftfB
         lXI8S3xPZxgTQmuLJaaBTMxu2LUZn9+JJdKZi67OHw41Plo1gs3jVEw28JzY7FchQC
         ICQMBcYowmSvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>, andrew@lunn.ch,
        sebastian.hesselbarth@gmail.com, gregory.clement@bootlin.com,
        linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 22/46] ARM: orion: fix include path
Date:   Tue, 11 Oct 2022 10:49:50 -0400
Message-Id: <20221011145015.1622882-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145015.1622882-1-sashal@kernel.org>
References: <20221011145015.1622882-1-sashal@kernel.org>
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

