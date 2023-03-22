Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8CBC6C5699
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbjCVUHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbjCVUG7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:06:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4556B5D5;
        Wed, 22 Mar 2023 13:01:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92EA4B81DE8;
        Wed, 22 Mar 2023 20:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3AEC4339B;
        Wed, 22 Mar 2023 20:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515272;
        bh=OzFtwA7If/Wya3jhnsAa+8xL/Wy2+Y3Rx8WMX1aLFYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U9KV961f0YtBwJoqYRqCW2kvo6eTZLHt1NaXK/kB6odBKVwTS78QEU7K9tjbYhRVq
         pUHpWdszPOC0dVl+CUNlTtIjVzJXWPWF+suKGYkYp4v/qvmEQY6Iwb4MX/T0k4FI88
         Y0q6HlXmx8zXIm0WSpWrtK3k4E/12ND6NF6zF9u5AlFUod/1pfsPZ80CEuEs51jOQO
         dCdZ+V8q+XgEUYFmFZo8IRCMLj4DXA0RY69QpNFQtkTcGA8MEHokoaCabrLz36tBgX
         fFmWVNob7SziKWRGYsZ9byD1n9mvXzJPHjvFHKh2OJ56HCUMOsWv79ikp6ohknDjSC
         LMBY8qpC3P6Pw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Chen <harperchen1110@gmail.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, dilinger@queued.net,
        linux-geode@lists.infradead.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 30/34] fbdev: lxfb: Fix potential divide by zero
Date:   Wed, 22 Mar 2023 15:59:22 -0400
Message-Id: <20230322195926.1996699-30-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195926.1996699-1-sashal@kernel.org>
References: <20230322195926.1996699-1-sashal@kernel.org>
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
index 9d26592dbfce9..41fda498406c1 100644
--- a/drivers/video/fbdev/geode/lxfb_core.c
+++ b/drivers/video/fbdev/geode/lxfb_core.c
@@ -235,6 +235,9 @@ static void get_modedb(struct fb_videomode **modedb, unsigned int *size)
 
 static int lxfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
+	if (!var->pixclock)
+		return -EINVAL;
+
 	if (var->xres > 1920 || var->yres > 1440)
 		return -EINVAL;
 
-- 
2.39.2

