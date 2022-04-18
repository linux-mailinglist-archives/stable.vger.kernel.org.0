Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50256505146
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiDRMeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239231AbiDRMcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:32:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BAB26104;
        Mon, 18 Apr 2022 05:24:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A24BCB80EDA;
        Mon, 18 Apr 2022 12:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE91C385A8;
        Mon, 18 Apr 2022 12:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284661;
        bh=xykrMrmiv5+u/RvlY5+4iaJ7HcGO82DMt1+l6pSg8os=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vdwA3fwPMQ9noXcaQca1I1a3nxhol1MGI5dJGS6pPXb4Qpd+APZn2GID0Pyt0fuBg
         cq8Icl2CbHEYOAAoamiHZ0fnGd5bYTS2NcQuSssvGMtRRlotO+IjebzpPnchOykJVe
         PlIp4Zh+yIm2RmcW5akN339VBtMJCuWnCZJH8/+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.17 188/219] gpio: sim: fix setting and getting multiple lines
Date:   Mon, 18 Apr 2022 14:12:37 +0200
Message-Id: <20220418121212.139304618@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <brgl@bgdev.pl>

commit 3836c73e6a2585561af928c6641d74528a8bdfa4 upstream.

We need to take mask into account in the set/get_multiple() callbacks.
Use bitmap_replace() instead of bitmap_copy().

Fixes: cb8c474e79be ("gpio: sim: new testing module")
Cc: stable@vger.kernel.org
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-sim.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpio-sim.c
+++ b/drivers/gpio/gpio-sim.c
@@ -134,7 +134,7 @@ static int gpio_sim_get_multiple(struct
 	struct gpio_sim_chip *chip = gpiochip_get_data(gc);
 
 	mutex_lock(&chip->lock);
-	bitmap_copy(bits, chip->value_map, gc->ngpio);
+	bitmap_replace(bits, bits, chip->value_map, mask, gc->ngpio);
 	mutex_unlock(&chip->lock);
 
 	return 0;
@@ -146,7 +146,7 @@ static void gpio_sim_set_multiple(struct
 	struct gpio_sim_chip *chip = gpiochip_get_data(gc);
 
 	mutex_lock(&chip->lock);
-	bitmap_copy(chip->value_map, bits, gc->ngpio);
+	bitmap_replace(chip->value_map, chip->value_map, bits, mask, gc->ngpio);
 	mutex_unlock(&chip->lock);
 }
 


