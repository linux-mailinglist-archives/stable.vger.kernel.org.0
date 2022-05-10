Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C81F4521A29
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244045AbiEJNyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245328AbiEJNwP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:52:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC542375D4;
        Tue, 10 May 2022 06:38:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E65E9618B4;
        Tue, 10 May 2022 13:37:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1575C385A6;
        Tue, 10 May 2022 13:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189864;
        bh=/jM/xkpLU4pNVj7m9v810zL6YmMq+x9MUFy1AJ5qtFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uXpG8sitF6PnOLYnxhI+v0WYMpgeauqUtHZ7Wpl/xdiUj1SpY0/55cqQfPJAFkYUe
         ogCRnlXGKuRXFevL6co+0rlMJopizZYoFAoofhtAhO0nKiq5RDKCon4gGLHTtG0fz5
         4Tj8vgyswHIhNhg9TyGgDJ+bmqaVE2oaz6Xcg9uA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Puyou Lu <puyou.lu@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 5.17 054/140] gpio: pca953x: fix irq_stat not updated when irq is disabled (irq_mask not set)
Date:   Tue, 10 May 2022 15:07:24 +0200
Message-Id: <20220510130743.165069556@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
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

From: Puyou Lu <puyou.lu@gmail.com>

commit dba785798526a3282cc4d0f0ea751883715dbbb4 upstream.

When one port's input state get inverted (eg. from low to hight) after
pca953x_irq_setup but before setting irq_mask (by some other driver such as
"gpio-keys"), the next inversion of this port (eg. from hight to low) will not
be triggered any more (because irq_stat is not updated at the first time). Issue
should be fixed after this commit.

Fixes: 89ea8bbe9c3e ("gpio: pca953x.c: add interrupt handling capability")
Signed-off-by: Puyou Lu <puyou.lu@gmail.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-pca953x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -762,11 +762,11 @@ static bool pca953x_irq_pending(struct p
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


