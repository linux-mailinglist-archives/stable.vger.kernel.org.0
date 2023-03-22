Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF75A6C57B2
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbjCVUdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbjCVUdk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:33:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B6C6E692;
        Wed, 22 Mar 2023 13:24:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33058B81DEB;
        Wed, 22 Mar 2023 20:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099D5C433EF;
        Wed, 22 Mar 2023 20:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515438;
        bh=osYd5k2tGDI708FtAvOzUUH/YD3JHeDpaPD+2tk6KTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HeKRqP2Rv6uR4eayKn7NLnuferbHPSH/Rh7SenM1kssPfiGvOArMP6nYw1BFNpESq
         mB++Y5lsU7xYsSiX0weODF6E1FnMetQoDis9va6dmeXwjOtorPGUfA+yKp9rWHkf5g
         ReKJd/aqwrZCbXVSai6FF2T3twPt1fJoaPS2hxAUL4qKYmz1+BcXPQIt70XAYB5Vlk
         hK2L28s6D8Wn4s72cJ6dRgjWs8JQvqRrdKBlgtfCummCcRVY2ZQ3iAQBrkx5wSk6JY
         LX3U0i9e3uWo7ocIBX9Fxu1QJTNy1F51++Bqy1PStFbMc5kMiMYZ0NSyeMxSDR1JYF
         J4PeYVOxorc0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Chen <harperchen1110@gmail.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, dilinger@queued.net,
        linux-geode@lists.infradead.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 8/9] fbdev: lxfb: Fix potential divide by zero
Date:   Wed, 22 Mar 2023 16:03:35 -0400
Message-Id: <20230322200337.1997810-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322200337.1997810-1-sashal@kernel.org>
References: <20230322200337.1997810-1-sashal@kernel.org>
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
index 138da6cb6cbcd..4345246b4c798 100644
--- a/drivers/video/fbdev/geode/lxfb_core.c
+++ b/drivers/video/fbdev/geode/lxfb_core.c
@@ -247,6 +247,9 @@ static void get_modedb(struct fb_videomode **modedb, unsigned int *size)
 
 static int lxfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
+	if (!var->pixclock)
+		return -EINVAL;
+
 	if (var->xres > 1920 || var->yres > 1440)
 		return -EINVAL;
 
-- 
2.39.2

