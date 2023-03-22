Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7213B6C575D
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbjCVUTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbjCVUTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:19:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A701B97B5F;
        Wed, 22 Mar 2023 13:09:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4ED47622CA;
        Wed, 22 Mar 2023 20:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B1BC433D2;
        Wed, 22 Mar 2023 20:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515384;
        bh=hkwxSZAe/lfznY7v5/uJEgJ4zJ8deckhDUkg6dhdkHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vG2G3PnHvpFaUvnqFgM6SAuSFCjtThXdFWV5F0sCSA2rom4aCW1cDVbExcS/ERH8z
         PO0/eG9EISl6SMotr/jk+oovCzwyqTwmvX3WDl/9N/KfGUtm7uFRd+WNmuJ5RVP1Ye
         fdNF084ShLqib5VnbUu470sMuUsKU92YpB0hyvmiEHQSLCjEuor7t4Q7PhPovQbWSr
         3kQkUlTia0DRDktCuJK3XxAn6H8YVf+vuKlOfi0wa4gEbsZ1vd6vwRJstDzYOMkS5M
         GdE5tGSZHkBjqj8INT8Xx9uCKE1L8b+YRu2BJNumXLS8YrW1p2ypH/Kiq9NNbbt4Nc
         uEu3HDj9MNImg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Chen <harperchen1110@gmail.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, dilinger@queued.net,
        linux-geode@lists.infradead.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 8/9] fbdev: lxfb: Fix potential divide by zero
Date:   Wed, 22 Mar 2023 16:02:40 -0400
Message-Id: <20230322200242.1997527-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322200242.1997527-1-sashal@kernel.org>
References: <20230322200242.1997527-1-sashal@kernel.org>
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
index b0f07d676eb3e..ffda25089e2ce 100644
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

