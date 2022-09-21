Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4447D5C0306
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232112AbiIUP60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbiIUP54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:57:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E7DA0339;
        Wed, 21 Sep 2022 08:51:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5084A63151;
        Wed, 21 Sep 2022 15:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2EEC433D7;
        Wed, 21 Sep 2022 15:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775461;
        bh=y4k8irumabBAHABUczfHkGj/E3CP61nP2gfTxUoqx5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=te0UW4VnwS4qz5EES8270FBSjbmftmayanNOfxBixPWF+3tRxYTQIBjvtucvlTkZP
         v/l98bEWrUQ9uwipB2wlHNAmSyQMePPP+O6shIsqu3PdPhqRZLN+N25Nib2hYIT3H4
         bCb0wrKbySBgX1owU36HaVp4v+BHr4+6/95YHtaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 15/39] gpio: mpc8xxx: Fix support for IRQ_TYPE_LEVEL_LOW flow_type in mpc85xx
Date:   Wed, 21 Sep 2022 17:46:20 +0200
Message-Id: <20220921153646.245895747@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
References: <20220921153645.663680057@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 279c12df8d2efb28def9d037f288cbfb97c30fe2 ]

Commit e39d5ef67804 ("powerpc/5xxx: extend mpc8xxx_gpio driver to support
mpc512x gpios") implemented support for IRQ_TYPE_LEVEL_LOW flow type in
mpc512x via falling edge type. Do same for mpc85xx which support was added
in commit 345e5c8a1cc3 ("powerpc: Add interrupt support to mpc8xxx_gpio").

Fixes probing of lm90 hwmon driver on mpc85xx based board which use level
interrupt. Without it kernel prints error and refuse lm90 to work:

    [   15.258370] genirq: Setting trigger mode 8 for irq 49 failed (mpc8xxx_irq_set_type+0x0/0xf8)
    [   15.267168] lm90 0-004c: cannot request IRQ 49
    [   15.272708] lm90: probe of 0-004c failed with error -22

Fixes: 345e5c8a1cc3 ("powerpc: Add interrupt support to mpc8xxx_gpio")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mpc8xxx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index d60d5520707d..60c2533a39a5 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -169,6 +169,7 @@ static int mpc8xxx_irq_set_type(struct irq_data *d, unsigned int flow_type)
 
 	switch (flow_type) {
 	case IRQ_TYPE_EDGE_FALLING:
+	case IRQ_TYPE_LEVEL_LOW:
 		raw_spin_lock_irqsave(&mpc8xxx_gc->lock, flags);
 		gc->write_reg(mpc8xxx_gc->regs + GPIO_ICR,
 			gc->read_reg(mpc8xxx_gc->regs + GPIO_ICR)
-- 
2.35.1



