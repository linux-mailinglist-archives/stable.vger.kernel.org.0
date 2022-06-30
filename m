Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81EC3561BF6
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 15:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbiF3NvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235677AbiF3Nuz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:50:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52AA037A84;
        Thu, 30 Jun 2022 06:49:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A90FB82AF0;
        Thu, 30 Jun 2022 13:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C0CC34115;
        Thu, 30 Jun 2022 13:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656596942;
        bh=U8YNSeg0RjBUDvQiRGZ/ZJrhD7LyEegV+Tj8h5JY5HY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c0in57UihLxZm/qUlhObqpbmMxje+N+nfYpT//sPGpYQ/Idf/Np2dsONIINYeD1Rn
         cTbgFjBe3vAB9O/8/ItJk8LasglH57jeh+z7DcrDD9hn4N1o2zJrRMWAUQ6w5t9Lxz
         Z4JgbPW77pHG4PoL2neHCrJN0tE+bzrKzCPiivs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, k2ci <kernel-bot@kylinos.cn>,
        huhai <huhai@kylinos.cn>,
        Genjian Zhang <zhanggenjian@kylinos.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 09/29] MIPS: Remove repetitive increase irq_err_count
Date:   Thu, 30 Jun 2022 15:46:09 +0200
Message-Id: <20220630133231.477751844@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133231.200642128@linuxfoundation.org>
References: <20220630133231.200642128@linuxfoundation.org>
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
index 41e873bc8474..a174fda8b397 100644
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



