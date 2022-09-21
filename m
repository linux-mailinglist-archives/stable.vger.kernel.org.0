Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A32F25C0299
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbiIUPyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbiIUPxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:53:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35065857FB;
        Wed, 21 Sep 2022 08:50:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B05D263143;
        Wed, 21 Sep 2022 15:49:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4162C433C1;
        Wed, 21 Sep 2022 15:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775374;
        bh=MjVpQg01ZuAjFEFCSzFirXe7GMa7gxyPJoxPoKsIjd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B6gV01iZVPBm6KgmcWZkcrAkKaH4ITgx/Ae09AbV4T0CUEv80GRh6OKMplQ4EHUPL
         tlpxZtA8gTTZcBb266mWkFcSW/PcPammEI3tByB22k2hj2OHCycHFsf227pJ686wmt
         Emu/v6KJycbbQNBWQwo5tkjhWN+XbBXd/OiXhnNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "=?UTF-8?q?Jo=C3=A3o=20H . =20Spies?=" <jhlspies@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 08/45] pinctrl: rockchip: Enhance support for IRQ_TYPE_EDGE_BOTH
Date:   Wed, 21 Sep 2022 17:45:58 +0200
Message-Id: <20220921153647.182046742@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.931277075@linuxfoundation.org>
References: <20220921153646.931277075@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: João H. Spies <jhlspies@gmail.com>

[ Upstream commit b871656aa4f54e04207f62bdd0d7572be1d86b36 ]

Switching between falling/rising edges for IRQ_TYPE_EDGE_BOTH on pins that
require debounce can cause the device to lose events due to a desync
between pin state and irq type.

This problem is resolved by switching between IRQ_TYPE_LEVEL_LOW and
IRQ_TYPE_LEVEL_HIGH instead.

Fixes: 936ee2675eee ("gpio/rockchip: add driver for rockchip gpio")
Signed-off-by: João H. Spies <jhlspies@gmail.com>
Link: https://lore.kernel.org/r/20220808025121.110223-1-jhlspies@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-rockchip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-rockchip.c b/drivers/gpio/gpio-rockchip.c
index 22b8f0aa80f1..f31b0947eaaa 100644
--- a/drivers/gpio/gpio-rockchip.c
+++ b/drivers/gpio/gpio-rockchip.c
@@ -418,11 +418,11 @@ static int rockchip_irq_set_type(struct irq_data *d, unsigned int type)
 			goto out;
 		} else {
 			bank->toggle_edge_mode |= mask;
-			level |= mask;
+			level &= ~mask;
 
 			/*
 			 * Determine gpio state. If 1 next interrupt should be
-			 * falling otherwise rising.
+			 * low otherwise high.
 			 */
 			data = readl(bank->reg_base + bank->gpio_regs->ext_port);
 			if (data & mask)
-- 
2.35.1



