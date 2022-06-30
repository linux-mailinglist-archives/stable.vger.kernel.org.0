Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEC2B561C08
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 15:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235470AbiF3Nvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235588AbiF3Nv0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:51:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3577E1020;
        Thu, 30 Jun 2022 06:49:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D185B82AFA;
        Thu, 30 Jun 2022 13:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C884FC34115;
        Thu, 30 Jun 2022 13:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656596953;
        bh=7kiX5/iU3xMuzV4UnCjZcDeo0Fq3+CeUwxfLySqMeXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uadquo0eR0gBVYmeX2rGEXVboYyFTg7PPpbqcq3Ylx0rndX4nkFxxJ06WKf9tk6HI
         FwCZSwaFWwTDa5RRAakRe1JGGGeXmFwv3/ZG8nNbNQrxSq3tPVSy3LussxslX4qa15
         FW8vY1OPLWEDKt/92gqhQ92NGUN2vbhhgHaPMeFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, k2ci <kernel-bot@kylinos.cn>,
        huhai <huhai@kylinos.cn>,
        Genjian Zhang <zhanggenjian@kylinos.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 11/35] MIPS: Remove repetitive increase irq_err_count
Date:   Thu, 30 Jun 2022 15:46:22 +0200
Message-Id: <20220630133232.773486663@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133232.433955678@linuxfoundation.org>
References: <20220630133232.433955678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: huhai <huhai@kylinos.cn>

[ Upstream commit c81aba8fde2aee4f5778ebab3a1d51bd2ef48e4c ]

commit 979934da9e7a ("[PATCH] mips: update IRQ handling for vr41xx") added
a function irq_dispatch, and it'll increase irq_err_count when the get_irq
callback returns a negative value, but increase irq_err_count in get_irq
was not removed.

And also, modpost complains once gpio-vr41xx drivers become modules.
  ERROR: modpost: "irq_err_count" [drivers/gpio/gpio-vr41xx.ko] undefined!

So it would be a good idea to remove repetitive increase irq_err_count in
get_irq callback.

Fixes: 27fdd325dace ("MIPS: Update VR41xx GPIO driver to use gpiolib")
Fixes: 979934da9e7a ("[PATCH] mips: update IRQ handling for vr41xx")
Reported-by: k2ci <kernel-bot@kylinos.cn>
Signed-off-by: huhai <huhai@kylinos.cn>
Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/vr41xx/common/icu.c | 2 --
 drivers/gpio/gpio-vr41xx.c    | 2 --
 2 files changed, 4 deletions(-)

diff --git a/arch/mips/vr41xx/common/icu.c b/arch/mips/vr41xx/common/icu.c
index 745b7b436961..42f77b318974 100644
--- a/arch/mips/vr41xx/common/icu.c
+++ b/arch/mips/vr41xx/common/icu.c
@@ -653,8 +653,6 @@ static int icu_get_irq(unsigned int irq)
 
 	printk(KERN_ERR "spurious ICU interrupt: %04x,%04x\n", pend1, pend2);
 
-	atomic_inc(&irq_err_count);
-
 	return -1;
 }
 
diff --git a/drivers/gpio/gpio-vr41xx.c b/drivers/gpio/gpio-vr41xx.c
index ac8deb01f6f6..ee3163dd794b 100644
--- a/drivers/gpio/gpio-vr41xx.c
+++ b/drivers/gpio/gpio-vr41xx.c
@@ -224,8 +224,6 @@ static int giu_get_irq(unsigned int irq)
 	printk(KERN_ERR "spurious GIU interrupt: %04x(%04x),%04x(%04x)\n",
 	       maskl, pendl, maskh, pendh);
 
-	atomic_inc(&irq_err_count);
-
 	return -EINVAL;
 }
 
-- 
2.35.1



