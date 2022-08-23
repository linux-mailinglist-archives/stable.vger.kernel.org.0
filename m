Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A701C59D849
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243190AbiHWJtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243336AbiHWJru (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:47:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EFD659D7;
        Tue, 23 Aug 2022 01:44:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 419BF6123D;
        Tue, 23 Aug 2022 08:44:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6CCC433C1;
        Tue, 23 Aug 2022 08:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244252;
        bh=mpJcz0jiPoaLtBWRMkn60g31PRKqvDk65GI2rFfTWh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XY1HAlkpxy8pmuEPVcNXuPHgAcp8zlNTnBg9h8jylbgeQ5QAd83pzjCKv4fga9WoD
         3zUeF1d/xLBhu3W+dDuqCfYYQ3y79/8H8lD5OxoprcqW1bikkbIQbQZ62k9g1UNbCf
         DFpAqiTl5hA0ItfycNjdPJLXU8+E+yv3uOiFmgn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 109/229] gpio: gpiolib-of: Fix refcount bugs in of_mm_gpiochip_add_data()
Date:   Tue, 23 Aug 2022 10:24:30 +0200
Message-Id: <20220823080057.574686008@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 5d07a692f9562f9c06e62cce369e9dd108173a0f ]

We should use of_node_get() when a new reference of device_node
is created. It is noted that the old reference stored in
'mm_gc->gc.of_node' should also be decreased.

This patch is based on the fact that there is a call site in function
'qe_add_gpiochips()' of src file 'drivers\soc\fsl\qe\gpio.c'. In this
function, of_mm_gpiochip_add_data() is contained in an iteration of
for_each_compatible_node() which will automatically increase and
decrease the refcount. So we need additional of_node_get() for the
reference escape in of_mm_gpiochip_add_data().

Fixes: a19e3da5bc5f ("of/gpio: Kill of_gpio_chip and add members directly to gpio_chip")
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index d6ed4e891b34..cc1efdbd3db4 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -350,7 +350,8 @@ int of_mm_gpiochip_add_data(struct device_node *np,
 	if (mm_gc->save_regs)
 		mm_gc->save_regs(mm_gc);
 
-	mm_gc->gc.of_node = np;
+	of_node_put(mm_gc->gc.of_node);
+	mm_gc->gc.of_node = of_node_get(np);
 
 	ret = gpiochip_add_data(gc, data);
 	if (ret)
@@ -358,6 +359,7 @@ int of_mm_gpiochip_add_data(struct device_node *np,
 
 	return 0;
 err2:
+	of_node_put(np);
 	iounmap(mm_gc->regs);
 err1:
 	kfree(gc->label);
-- 
2.35.1



