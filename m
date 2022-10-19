Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD89D603F85
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233766AbiJSJcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233982AbiJSJaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:30:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A258EB75A;
        Wed, 19 Oct 2022 02:13:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0191617D4;
        Wed, 19 Oct 2022 09:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1110C433D7;
        Wed, 19 Oct 2022 09:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170822;
        bh=Kl9RoFAq3sCIwA5R+gllPUC3sCxEPBv5CtTb6Rfc7FE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ba1dWm5pWrfwEFHV1+Vii2JDATk3xFjYXfXchptxKNseXMgZZSd2pXebWcPkMI5kN
         EKXAfsLPAAKZYMaWeH4cLjWGiMMhp6QTgMtYP+KOP7tLNehvBXgzFMvtR2URZobIa/
         d8Vo1qthOfkyYxHmSrK2KKGQVQxZ3IndoQ1PKcKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 782/862] ARM: orion: fix include path
Date:   Wed, 19 Oct 2022 10:34:29 +0200
Message-Id: <20221019083324.465380916@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



