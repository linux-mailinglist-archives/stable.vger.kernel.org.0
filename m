Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA75155DA79
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237883AbiF0LtK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238462AbiF0Lsa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FAF3BE31;
        Mon, 27 Jun 2022 04:41:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33C5561192;
        Mon, 27 Jun 2022 11:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45229C341C7;
        Mon, 27 Jun 2022 11:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330098;
        bh=mQxZLlG1fnMhdpl5nNqIAaOfKrFy36I2HEN0sikocns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CUU/t+E7+Xot+fUkAVFQRWp1v7+3nLX82hk9GklgOSAmox3UALTukZ3oS2za57nxw
         sD19UZ2lwtP2bcgpHC/SHFZhlsV6hI472VJA3R3LhskPNeOIL06tHMi/C2DTYEz+ae
         aJasC6mbU/LYvr8+0aCuGB9NRLCggo2NLtuPoKWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, k2ci <kernel-bot@kylinos.cn>,
        huhai <huhai@kylinos.cn>,
        Genjian Zhang <zhanggenjian@kylinos.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 082/181] MIPS: Remove repetitive increase irq_err_count
Date:   Mon, 27 Jun 2022 13:20:55 +0200
Message-Id: <20220627111946.938512475@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
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
index 7b7f25b4b057..9240bcdbe74e 100644
--- a/arch/mips/vr41xx/common/icu.c
+++ b/arch/mips/vr41xx/common/icu.c
@@ -640,8 +640,6 @@ static int icu_get_irq(unsigned int irq)
 
 	printk(KERN_ERR "spurious ICU interrupt: %04x,%04x\n", pend1, pend2);
 
-	atomic_inc(&irq_err_count);
-
 	return -1;
 }
 
diff --git a/drivers/gpio/gpio-vr41xx.c b/drivers/gpio/gpio-vr41xx.c
index 98cd715ccc33..8d09b619c166 100644
--- a/drivers/gpio/gpio-vr41xx.c
+++ b/drivers/gpio/gpio-vr41xx.c
@@ -217,8 +217,6 @@ static int giu_get_irq(unsigned int irq)
 	printk(KERN_ERR "spurious GIU interrupt: %04x(%04x),%04x(%04x)\n",
 	       maskl, pendl, maskh, pendh);
 
-	atomic_inc(&irq_err_count);
-
 	return -EINVAL;
 }
 
-- 
2.35.1



