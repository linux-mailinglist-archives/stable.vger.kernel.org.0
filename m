Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069AA6C5643
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbjCVUEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbjCVUDO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:03:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDEC6C1AF;
        Wed, 22 Mar 2023 12:59:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7235E622C0;
        Wed, 22 Mar 2023 19:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C3BC4339B;
        Wed, 22 Mar 2023 19:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515157;
        bh=QcfqzscAf9dPC2v2aEj1NR0Q/YM5YoN6MttM5Qqh1MM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o7uUZW1+kzn4G6fiRMeZXtQNNGK/GqR52q3n/0erQ9t+72LGKi9/6fdfx4xwJcvzu
         ObRwCXjOHwx83ih4+QWrwAKVWChCuEaYJNm8rGv/buSok/oQOjbdPKF1E30F22WsqF
         roGiWJsKaDb1oCIGpZ5S/FvPveZgff7pYzkBzJcBcU8tbsXtsmQd4RCAQEdItSGEmq
         a8itX8rOYqQ7lcskhwOYTXhJ9Wewhx4aLs+bZzLbIPM49uFa0jrauCMoqGLdwWS2HU
         5BRjZ7Wa8/oL6ww77+LRevqTbqiOvlu1wgrGWpXfY2nOv4WRnCUixAEj+DGuvHc/Ek
         AU5dZlN+w9qNQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Chen <harperchen1110@gmail.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, mbroemme@libmpq.org,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.2 40/45] fbdev: intelfb: Fix potential divide by zero
Date:   Wed, 22 Mar 2023 15:56:34 -0400
Message-Id: <20230322195639.1995821-40-sashal@kernel.org>
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

[ Upstream commit d823685486a3446d061fed7c7d2f80af984f119a ]

Variable var->pixclock is controlled by user and can be assigned
to zero. Without proper check, divide by zero would occur in
intelfbhw_validate_mode and intelfbhw_mode_to_hw.

Error out if var->pixclock is zero.

Signed-off-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/intelfb/intelfbdrv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/fbdev/intelfb/intelfbdrv.c b/drivers/video/fbdev/intelfb/intelfbdrv.c
index 0a9e5067b2010..a81095b2b1ea5 100644
--- a/drivers/video/fbdev/intelfb/intelfbdrv.c
+++ b/drivers/video/fbdev/intelfb/intelfbdrv.c
@@ -1222,6 +1222,9 @@ static int intelfb_check_var(struct fb_var_screeninfo *var,
 
 	dinfo = GET_DINFO(info);
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	/* update the pitch */
 	if (intelfbhw_validate_mode(dinfo, var) != 0)
 		return -EINVAL;
-- 
2.39.2

