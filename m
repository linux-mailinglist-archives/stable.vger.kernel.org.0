Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3216C56E1
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbjCVUK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbjCVUJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:09:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106F329413;
        Wed, 22 Mar 2023 13:02:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EC0E622B4;
        Wed, 22 Mar 2023 20:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24940C433EF;
        Wed, 22 Mar 2023 20:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515377;
        bh=6rJG97ZzxVmIyk1bTkmXt1OfZk0tUqXxGyQT7Wn+4hM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CuWjr3IWgd5Qn6+rkTgw4vBhI2+14VZDEV9GmTBvRNcIpS/lKvJWsauNfwKHGfzyQ
         TLM5Fa769G4ff6Zjz7TOTUwP3Vu6xk8Kz2NU3OpW5dJ1DTT0iRFQKJugcHRJ5qJZrf
         3ipAoxXFj5QD335Yv5UXlr+K9oc5LvyPXkGLddqQkZreIK890kgqss086Lv/UvVOY0
         SBQTRSlptm7aGYTwO5qxA5p4Jk1RiFd3kSbjKA38lpwdsk4ONe9JuXoo7dFWsDp6TP
         IsXwyjy5DnNRjrbitvrTO9FtQqyo2Li9RgMLnmUY84qRqiyTNhRcNRck8HKL1inQKC
         cL3f93tlO3m3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Chen <harperchen1110@gmail.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, tzimmermann@suse.de,
        javierm@redhat.com, wsa+renesas@sang-engineering.com,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 4/9] fbdev: tgafb: Fix potential divide by zero
Date:   Wed, 22 Mar 2023 16:02:36 -0400
Message-Id: <20230322200242.1997527-4-sashal@kernel.org>
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

[ Upstream commit f90bd245de82c095187d8c2cabb8b488a39eaecc ]

fb_set_var would by called when user invokes ioctl with cmd
FBIOPUT_VSCREENINFO. User-provided data would finally reach
tgafb_check_var. In case var->pixclock is assigned to zero,
divide by zero would occur when checking whether reciprocal
of var->pixclock is too high.

Similar crashes have happened in other fbdev drivers. There
is no check and modification on var->pixclock along the call
chain to tgafb_check_var. We believe it could also be triggered
in driver tgafb from user site.

Signed-off-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/tgafb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/fbdev/tgafb.c b/drivers/video/fbdev/tgafb.c
index 286b2371c7dd3..eab2b4f87d68f 100644
--- a/drivers/video/fbdev/tgafb.c
+++ b/drivers/video/fbdev/tgafb.c
@@ -166,6 +166,9 @@ tgafb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
 	struct tga_par *par = (struct tga_par *)info->par;
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	if (par->tga_type == TGA_TYPE_8PLANE) {
 		if (var->bits_per_pixel != 8)
 			return -EINVAL;
-- 
2.39.2

