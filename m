Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55EE5576285
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 15:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiGONGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 09:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiGONGy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 09:06:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DEC5C96F
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 06:06:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6123762392
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 13:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E388C34115;
        Fri, 15 Jul 2022 13:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657890412;
        bh=vawO7ezRv5friL+uIS5dqv1FARG2tZANNZqCgScqNOw=;
        h=Subject:To:Cc:From:Date:From;
        b=citf+8vayj/Rnwpg95gLL5wwArTcOHarLv3lreuov1qUYBDWPG3H2CiPVutAOuRbs
         uJy74p9R+EcY7t46WE2hIYWB6+HiqEEWBpzBNXu9cUBBp/VlKxLY4plzV0KT1z785m
         HmEJMVXOyNkHGZuFK61e6F9Aa6zVhFQrFPwdsLYQ=
Subject: FAILED: patch "[PATCH] drm/panfrost: Put mapping instead of shmem obj on" failed to apply to 5.4-stable tree
To:     dmitry.osipenko@collabora.com, steven.price@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Jul 2022 15:06:49 +0200
Message-ID: <1657890409152100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fb6e0637ab7ebd8e61fe24f4d663c4bae99cfa62 Mon Sep 17 00:00:00 2001
From: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Date: Thu, 30 Jun 2022 23:06:00 +0300
Subject: [PATCH] drm/panfrost: Put mapping instead of shmem obj on
 panfrost_mmu_map_fault_addr() error

When panfrost_mmu_map_fault_addr() fails, the BO's mapping should be
unreferenced and not the shmem object which backs the mapping.

Cc: stable@vger.kernel.org
Fixes: bdefca2d8dc0 ("drm/panfrost: Add the panfrost_gem_mapping concept")
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220630200601.1884120-2-dmitry.osipenko@collabora.com

diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
index d3f82b26a631..b285a8001b1d 100644
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -518,7 +518,7 @@ static int panfrost_mmu_map_fault_addr(struct panfrost_device *pfdev, int as,
 err_pages:
 	drm_gem_shmem_put_pages(&bo->base);
 err_bo:
-	drm_gem_object_put(&bo->base.base);
+	panfrost_gem_mapping_put(bomapping);
 	return ret;
 }
 

