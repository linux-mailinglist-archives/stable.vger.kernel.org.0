Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E80C6C564C
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbjCVUE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbjCVUDr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:03:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73BC6C198;
        Wed, 22 Mar 2023 12:59:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B243E622B6;
        Wed, 22 Mar 2023 19:59:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB0BC4339C;
        Wed, 22 Mar 2023 19:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515159;
        bh=GZPVYcrHtGWQvUQ8YdKknhqUfDuUeXv2O0AacKE8YH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h/vSuUwX2Yh3MgXEDBS9oeb0xe0l3f7P4fLSxOH3cibIliyNtFrAGIxm2upShHwXS
         ousoS71arUUpdWFU68DNxuoi3AR7sFURSZzOja+HYZxffm3UwP3YwsAo6l2qzTjXia
         cHElJrP9PDJ/gciE3iwu/gvyqLiOqVJ54H6Qq1jiX0VyP6tIEOJI94xJ/pGlv4xu61
         LoRiyv8j3WMbw/cAqjuCF8e26P+c63QO9l6qKUn1TYv0W4hj3bzgtDJcJG2pzkNiX6
         e9cMj6OV9qX88vBpzFeTynDFU1gQTjmx/5gFv3RsD4z2O/1R1rhs+T+PfgGZdKkAHp
         L3Fx771JULgyA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Chen <harperchen1110@gmail.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, dilinger@queued.net,
        linux-geode@lists.infradead.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.2 41/45] fbdev: lxfb: Fix potential divide by zero
Date:   Wed, 22 Mar 2023 15:56:35 -0400
Message-Id: <20230322195639.1995821-41-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195639.1995821-1-sashal@kernel.org>
References: <20230322195639.1995821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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
index 8130e9eee2b4b..556d8b1a9e06a 100644
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

