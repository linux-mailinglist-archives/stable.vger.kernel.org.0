Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B180E594C9A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346921AbiHPAaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346762AbiHPAaB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:30:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68697183490;
        Mon, 15 Aug 2022 13:35:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CE4FB80EA8;
        Mon, 15 Aug 2022 20:35:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CC5C433D6;
        Mon, 15 Aug 2022 20:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595722;
        bh=mAhndZ58v9W0AkBZG9Q4H8Lw125PT5BmmTbkUSWufHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iyBJJ77KQ3jMMeT5q4U5Hkug8Fhm1M9N678+D/HvzUv2jTMba2Xq0X0skShQ5n+Hs
         bMeBLJVzjiqjooqnUDLGqgVaSfqal0QVXNc4eQ3tbO/upUepSBOft98Li5c3LqCitS
         H8ym2hh79amzW3HKn7iMLZzM2JQiv7cDj20TpeTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Peter Suti <peter.suti@streamunlimited.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0854/1157] staging: fbtft: core: set smem_len before fb_deferred_io_init call
Date:   Mon, 15 Aug 2022 20:03:30 +0200
Message-Id: <20220815180513.654242834@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Peter Suti <peter.suti@streamunlimited.com>

[ Upstream commit 81e878887ff82a7dd42f22951391069a5d520627 ]

The fbtft_framebuffer_alloc() calls fb_deferred_io_init() before
initializing info->fix.smem_len.  It is set to zero by the
framebuffer_alloc() function.  It will trigger a WARN_ON() at the
start of fb_deferred_io_init() and the function will not do anything.

Fixes: 856082f021a2 ("fbdev: defio: fix the pagelist corruption")
Signed-off-by: Peter Suti <peter.suti@streamunlimited.com>
Link: https://lore.kernel.org/r/20220727073550.1491126-1-peter.suti@streamunlimited.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/fbtft/fbtft-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/fbtft/fbtft-core.c b/drivers/staging/fbtft/fbtft-core.c
index 60b2278d8b16..ebf4e8ce4de9 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -655,7 +655,6 @@ struct fb_info *fbtft_framebuffer_alloc(struct fbtft_display *display,
 	fbdefio->delay =            HZ / fps;
 	fbdefio->sort_pagereflist = true;
 	fbdefio->deferred_io =      fbtft_deferred_io;
-	fb_deferred_io_init(info);
 
 	snprintf(info->fix.id, sizeof(info->fix.id), "%s", dev->driver->name);
 	info->fix.type =           FB_TYPE_PACKED_PIXELS;
@@ -666,6 +665,7 @@ struct fb_info *fbtft_framebuffer_alloc(struct fbtft_display *display,
 	info->fix.line_length =    width * bpp / 8;
 	info->fix.accel =          FB_ACCEL_NONE;
 	info->fix.smem_len =       vmem_size;
+	fb_deferred_io_init(info);
 
 	info->var.rotate =         pdata->rotate;
 	info->var.xres =           width;
-- 
2.35.1



