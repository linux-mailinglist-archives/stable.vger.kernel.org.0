Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF6E6C56F2
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbjCVUK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbjCVUKM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:10:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C656BC35;
        Wed, 22 Mar 2023 13:03:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72674622CB;
        Wed, 22 Mar 2023 20:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD75C433EF;
        Wed, 22 Mar 2023 20:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515346;
        bh=424IzOqQEgqNHPP35M94Ry7+wAFUjP2L6M6RBIzUo8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d5h2oIuqCPE+6BgAa1iVKNf/n81AslRKVQSwdfEMKkMBvAyp7t6BcJjNzqS1lULpg
         9nwVlMcPi8FCcNmz/MKn+ORWPwxkjgJWuHq5FBxeBe8MufDYW67Kg1Ro9+QKDrKTWB
         9PxTbQjEhDl1mQ4hOsCNWu5uYLGq4WtFYZRtdqRxUlevtML8qk3XbdaUARJ8OTe8jL
         PvbbwL2Q5dIIKnYjrVELxyCgKBzvAUcZzm4u0vSIoxOzEyWFgvaRPTl73RRw8jI3hf
         n2tRhdz+q+nu/knD/AWrjU5+IBqArsDaa0ESFw2PwvefHtTpfWAOSFpX19SHDV97i8
         2w/su9TnEdaGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Chen <harperchen1110@gmail.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, javierm@redhat.com,
        tzimmermann@suse.de, wsa+renesas@sang-engineering.com,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 05/12] fbdev: tgafb: Fix potential divide by zero
Date:   Wed, 22 Mar 2023 16:01:59 -0400
Message-Id: <20230322200207.1997367-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322200207.1997367-1-sashal@kernel.org>
References: <20230322200207.1997367-1-sashal@kernel.org>
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
index 666fbe2f671c9..98a2977fd4271 100644
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

