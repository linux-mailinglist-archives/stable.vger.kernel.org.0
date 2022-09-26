Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B6B5EA053
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235986AbiIZKgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236313AbiIZKeu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:34:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00285245D;
        Mon, 26 Sep 2022 03:21:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B565960BB7;
        Mon, 26 Sep 2022 10:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4F8C43148;
        Mon, 26 Sep 2022 10:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187696;
        bh=2eD7QGliI3wXPdxG3FW/UmNFLlJHY7urDvH1z6VQP54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RgkcZ7RC8EVztKZ7tV0bbJNLUb3M1jQCWtjNbA6oVtGsxFl2WcCuelcl5a0lri+Yl
         3EzWe0tCGfsBPXD86G6XOG2be/z55Ky+FRJ0voUudq/QWmcu9+PhbtrsdfppYtEsib
         7/eTx+4SAY5yHZYsL3TOgfZcT3NzTexJ1VsrqJyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 003/120] gpio: mpc8xxx: Fix support for IRQ_TYPE_LEVEL_LOW flow_type in mpc85xx
Date:   Mon, 26 Sep 2022 12:10:36 +0200
Message-Id: <20220926100750.666778118@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index d72a3a5507b0..f3bf82efea8e 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -190,6 +190,7 @@ static int mpc8xxx_irq_set_type(struct irq_data *d, unsigned int flow_type)
 
 	switch (flow_type) {
 	case IRQ_TYPE_EDGE_FALLING:
+	case IRQ_TYPE_LEVEL_LOW:
 		raw_spin_lock_irqsave(&mpc8xxx_gc->lock, flags);
 		gc->write_reg(mpc8xxx_gc->regs + GPIO_ICR,
 			gc->read_reg(mpc8xxx_gc->regs + GPIO_ICR)
-- 
2.35.1



