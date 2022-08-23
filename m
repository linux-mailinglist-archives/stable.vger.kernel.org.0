Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974C659E1C4
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353205AbiHWKhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353625AbiHWKe7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:34:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E841A61D0;
        Tue, 23 Aug 2022 02:07:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45F4F6156F;
        Tue, 23 Aug 2022 09:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C834C433C1;
        Tue, 23 Aug 2022 09:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245622;
        bh=em6fE2WEIEaDG8U9cC/Dtp6StwJew9mwOQxtaNxLcHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1eb8yFUe0b5kqPVx+ZhZ+eOWoktIibrXb1nVFcVYSgwiNuRstyxu9+Tvz8FccDnh
         xG85PGdsvWoJa3SdbQkR85+TRJL3ykbUS4ed5lQJOXedJT33rQg+yZ1Zbf4UvEcfmK
         +WMDCbPCXg2FNzkwZXXLVuHTKOAwIQecPD7uZMmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 135/287] gpio: gpiolib-of: Fix refcount bugs in of_mm_gpiochip_add_data()
Date:   Tue, 23 Aug 2022 10:25:04 +0200
Message-Id: <20220823080104.989173101@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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
index 09999e3e3109..7bda0f59c109 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -476,7 +476,8 @@ int of_mm_gpiochip_add_data(struct device_node *np,
 	if (mm_gc->save_regs)
 		mm_gc->save_regs(mm_gc);
 
-	mm_gc->gc.of_node = np;
+	of_node_put(mm_gc->gc.of_node);
+	mm_gc->gc.of_node = of_node_get(np);
 
 	ret = gpiochip_add_data(gc, data);
 	if (ret)
@@ -484,6 +485,7 @@ int of_mm_gpiochip_add_data(struct device_node *np,
 
 	return 0;
 err2:
+	of_node_put(np);
 	iounmap(mm_gc->regs);
 err1:
 	kfree(gc->label);
-- 
2.35.1



