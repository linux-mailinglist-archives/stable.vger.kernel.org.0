Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F5F52915A
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241453AbiEPUHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349573AbiEPUAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:00:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1524D42A0C;
        Mon, 16 May 2022 12:54:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83EB560ECC;
        Mon, 16 May 2022 19:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817E2C36AE3;
        Mon, 16 May 2022 19:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730842;
        bh=8TNGV8+lcfjcP2CucebFTBrC3MWqsBcqoaEeKvVh1+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rpjj4mh2yd3kfVdDdpCWZwAV9qlllh0Mdy17Jcgu+QTalUwW+TjuwpX0JjW6E6cjG
         SAYbkb4AxULkwrlATVh71kX2MKlK7X8Y/4Pzmafdv5wiWIH8Fk3R/YefSlY5/6CUrh
         g5g3eRcDmsLL9wzJkUnAh13dGP8d1PWH/kwoNaIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Thomas Zimmermann <tzimemrmann@suse.de>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 022/114] fbdev: efifb: Fix a use-after-free due early fb_info cleanup
Date:   Mon, 16 May 2022 21:35:56 +0200
Message-Id: <20220516193626.131510142@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javier Martinez Canillas <javierm@redhat.com>

[ Upstream commit 1b5853dfab7fdde450f00f145327342238135c8a ]

Commit d258d00fb9c7 ("fbdev: efifb: Cleanup fb_info in .fb_destroy rather
than .remove") attempted to fix a use-after-free error due driver freeing
the fb_info in the .remove handler instead of doing it in .fb_destroy.

But ironically that change introduced yet another use-after-free since the
fb_info was still used after the free.

This should fix for good by freeing the fb_info at the end of the handler.

Fixes: d258d00fb9c7 ("fbdev: efifb: Cleanup fb_info in .fb_destroy rather than .remove")
Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reported-by: Andrzej Hajda <andrzej.hajda@intel.com>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Thomas Zimmermann <tzimemrmann@suse.de>
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220506132225.588379-1-javierm@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/efifb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index cfa3dc0b4eee..b3d5f884c544 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -259,12 +259,12 @@ static void efifb_destroy(struct fb_info *info)
 			memunmap(info->screen_base);
 	}
 
-	framebuffer_release(info);
-
 	if (request_mem_succeeded)
 		release_mem_region(info->apertures->ranges[0].base,
 				   info->apertures->ranges[0].size);
 	fb_dealloc_cmap(&info->cmap);
+
+	framebuffer_release(info);
 }
 
 static const struct fb_ops efifb_ops = {
-- 
2.35.1



