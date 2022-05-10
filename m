Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0576C521829
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243414AbiEJNde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243929AbiEJNcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:32:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4645FCA;
        Tue, 10 May 2022 06:23:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 667B2B81DA8;
        Tue, 10 May 2022 13:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD271C385C6;
        Tue, 10 May 2022 13:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189029;
        bh=HoOfi01wBxkhtS/69h0Be3htZAnNoys6Mua3ZN7jUoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNjYzHZFjib28irKa5tMGE2YojhgFfMTwwZBiOZX7tDoO3BocNGRz83N58LJTl6jG
         bZzOCzrRo87JxzAV1fOkZ02/4nfULESKbMPNZWBC2JNoUvr8fiiIyHSZP8UY0ae5LX
         8r9nZ1ZWIgFjbsK42hd1uNsiMLVOynY0ZZ8ImZVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrei Lalaev <andrei.lalaev@emlid.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 5.4 04/52] gpiolib: of: fix bounds check for gpio-reserved-ranges
Date:   Tue, 10 May 2022 15:07:33 +0200
Message-Id: <20220510130729.984881193@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130729.852544477@linuxfoundation.org>
References: <20220510130729.852544477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrei Lalaev <andrei.lalaev@emlid.com>

commit e75f88efac05bf4e107e4171d8db6d8c3937252d upstream.

Gpiolib interprets the elements of "gpio-reserved-ranges" as "start,size"
because it clears "size" bits starting from the "start" bit in the according
bitmap. So it has to use "greater" instead of "greater or equal" when performs
bounds check to make sure that GPIOs are in the available range.
Previous implementation skipped ranges that include the last GPIO in
the range.

I wrote the mail to the maintainers
(https://lore.kernel.org/linux-gpio/20220412115554.159435-1-andrei.lalaev@emlid.com/T/#u)
of the questioned DTSes (because I couldn't understand how the maintainers
interpreted this property), but I haven't received a response.
Since the questioned DTSes use "gpio-reserved-ranges = <0 4>"
(i.e., the beginning of the range), this patch doesn't affect these DTSes at all.
TBH this patch doesn't break any existing DTSes because none of them
reserve gpios at the end of range.

Fixes: 726cb3ba4969 ("gpiolib: Support 'gpio-reserved-ranges' property")
Signed-off-by: Andrei Lalaev <andrei.lalaev@emlid.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-of.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -783,7 +783,7 @@ static void of_gpiochip_init_valid_mask(
 					   i, &start);
 		of_property_read_u32_index(np, "gpio-reserved-ranges",
 					   i + 1, &count);
-		if (start >= chip->ngpio || start + count >= chip->ngpio)
+		if (start >= chip->ngpio || start + count > chip->ngpio)
 			continue;
 
 		bitmap_clear(chip->valid_mask, start, count);


