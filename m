Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5605945AD
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343712AbiHOWPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345040AbiHOWOw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:14:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0656745B;
        Mon, 15 Aug 2022 12:39:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FB7AB81141;
        Mon, 15 Aug 2022 19:39:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C6DC433D6;
        Mon, 15 Aug 2022 19:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592372;
        bh=I0yTF2qYaIgcXNTD92Ug0VZKou04HKuY/Q+ASm9ai+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oAoKuxrEFncwjGoLC0SB6MCda2sGQQ0suDsXkCdr7IutmHbIWikWatwGDMs7kP6Ud
         KujJKHGR2EPKIldOBo6eQlQUfY9jcOHIycpBaB4k+9+A784a3vnsXmAOWBCBkzB9I9
         85hRSVKv2bDujP4EQrWA6GKRZ+XAhnZkgJfVkks0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0777/1095] gpio: gpiolib-of: Fix refcount bugs in of_mm_gpiochip_add_data()
Date:   Mon, 15 Aug 2022 20:02:56 +0200
Message-Id: <20220815180501.410976577@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 6dec81b1f24b..5cabb9a9c272 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -861,7 +861,8 @@ int of_mm_gpiochip_add_data(struct device_node *np,
 	if (mm_gc->save_regs)
 		mm_gc->save_regs(mm_gc);
 
-	mm_gc->gc.of_node = np;
+	of_node_put(mm_gc->gc.of_node);
+	mm_gc->gc.of_node = of_node_get(np);
 
 	ret = gpiochip_add_data(gc, data);
 	if (ret)
@@ -869,6 +870,7 @@ int of_mm_gpiochip_add_data(struct device_node *np,
 
 	return 0;
 err2:
+	of_node_put(np);
 	iounmap(mm_gc->regs);
 err1:
 	kfree(gc->label);
-- 
2.35.1



