Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F20C52BAA8
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 14:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236480AbiERM1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 08:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236438AbiERM1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 08:27:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56056FD38;
        Wed, 18 May 2022 05:27:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E83AB81F40;
        Wed, 18 May 2022 12:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC80C385AA;
        Wed, 18 May 2022 12:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876820;
        bh=Y3HnaIdwRzgm8ZRIpbxNDktGkEgObnYgq8LHzhYZ0eI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YEtTQDy1ls12EXMY2VUAn9vTOABUghXAcdTppGrVNbRG5+Rm4O66odduxQLaBRZSs
         +esDo8m2vLki+p17KcHqhMRgL7nJFbtZx124q324AU4XBZSck+K4EiPZZZbLJnCq3E
         JICw+/G9IXDHw+vE7JwBlgiQScbbhFS3uOcegWFmOlI0M1JELornrmpywxATyUIipI
         AlxaKkPR4yE1UG0V/A2aTKTDprNQvSew6kwhRq2s35x05duin4RT0EZoISSHYAXb9A
         DXG2R9tVcgG4c89rZGo6Bb6X+21bzBK19sSQwMb8qyXSH+waGX/w3x97OEeJGe2xeJ
         mrUjZgW2hzEww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Javier Martinez Canillas <javierm@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>, daniel@ffwll.ch,
        deller@gmx.de, sam@ravnborg.org, tzimmermann@suse.de,
        thunder.leizhen@huawei.com, xiyuyang19@fudan.edu.cn,
        willy@infradead.org, alexander.deucher@amd.com,
        penguin-kernel@i-love.sakura.ne.jp, deng.changcheng@zte.com.cn,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.17 07/23] Revert "fbdev: Make fb_release() return -ENODEV if fbdev was unregistered"
Date:   Wed, 18 May 2022 08:26:20 -0400
Message-Id: <20220518122641.342120-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122641.342120-1-sashal@kernel.org>
References: <20220518122641.342120-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit 135332f34ba2662bc1e32b5c612e06a8cc41a053 ]

This reverts commit aafa025c76dcc7d1a8c8f0bdefcbe4eb480b2f6a. That commit
attempted to fix a NULL pointer dereference, caused by the struct fb_info
associated with a framebuffer device to not longer be valid when the file
descriptor was closed.

The issue was exposed by commit 27599aacbaef ("fbdev: Hot-unplug firmware
fb devices on forced removal"), which added a new path that goes through
the struct device removal instead of directly unregistering the fb.

Most fbdev drivers have issues with the fb_info lifetime, because call to
framebuffer_release() from their driver's .remove callback, rather than
doing from fbops.fb_destroy callback. This meant that due to this switch,
the fb_info was now destroyed too early, while references still existed,
while before it was simply leaked.

The patch we're reverting here reinstated that leak, hence "fixed" the
regression. But the proper solution is to fix the drivers to not release
the fb_info too soon.

Suggested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20220504115917.758787-1-javierm@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbmem.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index 10a9369c9dea..00f0f282e7a1 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -1438,10 +1438,7 @@ fb_release(struct inode *inode, struct file *file)
 __acquires(&info->lock)
 __releases(&info->lock)
 {
-	struct fb_info * const info = file_fb_info(file);
-
-	if (!info)
-		return -ENODEV;
+	struct fb_info * const info = file->private_data;
 
 	lock_fb_info(info);
 	if (info->fbops->fb_release)
-- 
2.35.1

