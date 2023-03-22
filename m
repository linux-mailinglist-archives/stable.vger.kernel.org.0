Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2736C5752
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbjCVURu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbjCVURf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:17:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685493B225;
        Wed, 22 Mar 2023 13:07:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C78BAB81DE5;
        Wed, 22 Mar 2023 20:01:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B681BC433AC;
        Wed, 22 Mar 2023 20:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515317;
        bh=LaxIYNbHqf7qY6iMl1u/QsdgKbWswnQNq7WEczQzRQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ge+Hv7NJhVb7hYODjZSpyV1jasKf3FV1/1ZxG+n3bcPI3TMYjhQMQ1cbgBSy80DQX
         WxtqawnS/eF8pkI8ySol2/JWBI/Lim4cbkiz5j+K32mk5cqESClWrwxE+pGDHnSc/N
         nhlZcnI7D9KPVSUqQV0xCGJ1F15Qwvmv8TRTRkdJZk1kiSL0sgF8tctTs6bjojlDcb
         OxNtM8f8vfgpQBQ865JYrY256MEfSjjTfpbf3s/rLTVR5vtwMHoZX9T7mHuj+RL1no
         VlRj0MQWsHYQX5NOdXXVybfk+peNAUZgUxx2CDy9X+F9jMUYEkpYIxsjQGXq2IxAA3
         RwzVWeOWsb6Vg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Chen <harperchen1110@gmail.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, dilinger@queued.net,
        linux-geode@lists.infradead.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 12/16] fbdev: lxfb: Fix potential divide by zero
Date:   Wed, 22 Mar 2023 16:01:16 -0400
Message-Id: <20230322200121.1997157-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322200121.1997157-1-sashal@kernel.org>
References: <20230322200121.1997157-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Chen <harperchen1110@gmail.com>

[ Upstream commit 61ac4b86a4c047c20d5cb423ddd87496f14d9868 ]

var->pixclock can be assigned to zero by user. Without proper
check, divide by zero would occur in lx_set_clock.

Error out if var->pixclock is zero.

Signed-off-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/geode/lxfb_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/fbdev/geode/lxfb_core.c b/drivers/video/fbdev/geode/lxfb_core.c
index 66c81262d18f8..6c6b6efb49f69 100644
--- a/drivers/video/fbdev/geode/lxfb_core.c
+++ b/drivers/video/fbdev/geode/lxfb_core.c
@@ -234,6 +234,9 @@ static void get_modedb(struct fb_videomode **modedb, unsigned int *size)
 
 static int lxfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
+	if (!var->pixclock)
+		return -EINVAL;
+
 	if (var->xres > 1920 || var->yres > 1440)
 		return -EINVAL;
 
-- 
2.39.2

