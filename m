Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D7F5945BD
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348174AbiHOW3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347966AbiHOWZG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:25:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B95126946;
        Mon, 15 Aug 2022 12:44:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA3B5B80EA9;
        Mon, 15 Aug 2022 19:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4C2C433C1;
        Mon, 15 Aug 2022 19:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592661;
        bh=XxpeVCfO3+MxzdRH2WGmrs76DgLei8x/GzgiJQYmjQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C10aj8u4JhRUr9S9IvkuJxGT8NGQzbW6TgotJdgfxXbzD7H5jSOC+sFHFc1i8OxoQ
         t1JRStwI07GrP/IcG72u6ZvAbyVldQzq5nkn7wNpLiCAyaBNiRwQI3agx8TBrx8H+e
         WoluwP2ozhD4c31S/k6PMsYk+pMT5IpG5njEK73g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Peter Suti <peter.suti@streamunlimited.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0796/1095] staging: fbtft: core: set smem_len before fb_deferred_io_init call
Date:   Mon, 15 Aug 2022 20:03:15 +0200
Message-Id: <20220815180502.179602518@linuxfoundation.org>
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
index 9c4d797e7ae4..4137c1a51e1b 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -656,7 +656,6 @@ struct fb_info *fbtft_framebuffer_alloc(struct fbtft_display *display,
 	fbdefio->delay =           HZ / fps;
 	fbdefio->sort_pagelist =   true;
 	fbdefio->deferred_io =     fbtft_deferred_io;
-	fb_deferred_io_init(info);
 
 	snprintf(info->fix.id, sizeof(info->fix.id), "%s", dev->driver->name);
 	info->fix.type =           FB_TYPE_PACKED_PIXELS;
@@ -667,6 +666,7 @@ struct fb_info *fbtft_framebuffer_alloc(struct fbtft_display *display,
 	info->fix.line_length =    width * bpp / 8;
 	info->fix.accel =          FB_ACCEL_NONE;
 	info->fix.smem_len =       vmem_size;
+	fb_deferred_io_init(info);
 
 	info->var.rotate =         pdata->rotate;
 	info->var.xres =           width;
-- 
2.35.1



