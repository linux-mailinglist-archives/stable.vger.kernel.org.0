Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8159D531ACC
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241623AbiEWRjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241946AbiEWRg2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:36:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9732A8FFB9;
        Mon, 23 May 2022 10:30:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8C3D611D1;
        Mon, 23 May 2022 17:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B35C385AA;
        Mon, 23 May 2022 17:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653327011;
        bh=8BC25H1XHkhLbiJGxK/vsgQN1+wdIUNdw9oW21XsJ9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uhEOSEQN52rj5wBFg+MazyZvSQCMVgmDfCH90LTZxXC+JfpZO/KZS3UacGxE62iSl
         H6uI+1kUKpitXyeck7qmDbundVI2V7bIiddq2/KiBiEO0ezJWuBZaRcj3FQTTxKlT7
         8JlvZjz3PF9edB89FnhfJQfLbi5tE7emRsXQgAl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Haibo Chen <haibo.chen@nxp.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 127/158] gpio: gpio-vf610: do not touch other bits when set the target bit
Date:   Mon, 23 May 2022 19:04:44 +0200
Message-Id: <20220523165851.651816398@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 9bf3ac466faa83d51a8fe9212131701e58fdef74 ]

For gpio controller contain register PDDR, when set one target bit,
current logic will clear all other bits, this is wrong. Use operator
'|=' to fix it.

Fixes: 659d8a62311f ("gpio: vf610: add imx7ulp support")
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-vf610.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-vf610.c b/drivers/gpio/gpio-vf610.c
index 20780c35da1b..23cddb265a0d 100644
--- a/drivers/gpio/gpio-vf610.c
+++ b/drivers/gpio/gpio-vf610.c
@@ -125,9 +125,13 @@ static int vf610_gpio_direction_output(struct gpio_chip *chip, unsigned gpio,
 {
 	struct vf610_gpio_port *port = gpiochip_get_data(chip);
 	unsigned long mask = BIT(gpio);
+	u32 val;
 
-	if (port->sdata && port->sdata->have_paddr)
-		vf610_gpio_writel(mask, port->gpio_base + GPIO_PDDR);
+	if (port->sdata && port->sdata->have_paddr) {
+		val = vf610_gpio_readl(port->gpio_base + GPIO_PDDR);
+		val |= mask;
+		vf610_gpio_writel(val, port->gpio_base + GPIO_PDDR);
+	}
 
 	vf610_gpio_set(chip, gpio, value);
 
-- 
2.35.1



