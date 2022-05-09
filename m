Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABF151F9DF
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 12:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbiEIKdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 06:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiEIKcs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 06:32:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E33B2A0A48
        for <stable@vger.kernel.org>; Mon,  9 May 2022 03:27:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4F8E60F80
        for <stable@vger.kernel.org>; Mon,  9 May 2022 10:25:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C823BC385AB;
        Mon,  9 May 2022 10:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652091955;
        bh=u+OZHOI7QBJhmVYm5pgVbfB5lLWsIT/L0eDc7T5zuME=;
        h=Subject:To:Cc:From:Date:From;
        b=q4p8R7HBm/RbvyE5C4OJrVy22n3n9NXhZeSdJrc7LPyMWq/9DduigO0PqnI0RayfT
         aTq/NyrIUGISLOqJCKTrCSwGhS6awQNSjIxfXlHK0relrxdArRz38WY+cpbaAzIdgS
         I0d5Bj1WrNcc+M2SPmtTV/Z6RR6Upy8L8eQFAMk8=
Subject: FAILED: patch "[PATCH] gpio: pca953x: fix irq_stat not updated when irq is disabled" failed to apply to 4.19-stable tree
To:     puyou.lu@gmail.com, brgl@bgdev.pl
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 12:25:44 +0200
Message-ID: <165209194416795@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dba785798526a3282cc4d0f0ea751883715dbbb4 Mon Sep 17 00:00:00 2001
From: Puyou Lu <puyou.lu@gmail.com>
Date: Fri, 6 May 2022 16:06:30 +0800
Subject: [PATCH] gpio: pca953x: fix irq_stat not updated when irq is disabled
 (irq_mask not set)

When one port's input state get inverted (eg. from low to hight) after
pca953x_irq_setup but before setting irq_mask (by some other driver such as
"gpio-keys"), the next inversion of this port (eg. from hight to low) will not
be triggered any more (because irq_stat is not updated at the first time). Issue
should be fixed after this commit.

Fixes: 89ea8bbe9c3e ("gpio: pca953x.c: add interrupt handling capability")
Signed-off-by: Puyou Lu <puyou.lu@gmail.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index d2fe76f3f34f..8726921a1129 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -762,11 +762,11 @@ static bool pca953x_irq_pending(struct pca953x_chip *chip, unsigned long *pendin
 	bitmap_xor(cur_stat, new_stat, old_stat, gc->ngpio);
 	bitmap_and(trigger, cur_stat, chip->irq_mask, gc->ngpio);
 
+	bitmap_copy(chip->irq_stat, new_stat, gc->ngpio);
+
 	if (bitmap_empty(trigger, gc->ngpio))
 		return false;
 
-	bitmap_copy(chip->irq_stat, new_stat, gc->ngpio);
-
 	bitmap_and(cur_stat, chip->irq_trig_fall, old_stat, gc->ngpio);
 	bitmap_and(old_stat, chip->irq_trig_raise, new_stat, gc->ngpio);
 	bitmap_or(new_stat, old_stat, cur_stat, gc->ngpio);

