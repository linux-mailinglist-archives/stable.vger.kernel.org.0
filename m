Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B046C5723
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbjCVUNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbjCVUMy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:12:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3491D7FD79;
        Wed, 22 Mar 2023 13:04:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FCF6622B4;
        Wed, 22 Mar 2023 20:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88309C4339B;
        Wed, 22 Mar 2023 20:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515431;
        bh=0vnA3WU9n71Hksc/Fk2ECnvm3tBZSD5qLPZsrYMfSA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gCrIJVT48kvbjhFtY6QmfpivzuEbFevCFdThJVCBKwgvezjnMJJqiX98XanBU3M20
         NwiWikW9Ucm44SZ7FhrZTaa4mjMZ8vB58rOSrmWqWq4vjFNmFtCHF9SUg8efrrLLWQ
         llgG+HeIhnbbLJzVrRfWxdRdRjL+MlnTWQMcOE6o1trubCptDFEsjAWZo2LkNlvkmH
         zqi9mSYieOC+G7YI/qoiwIEM1gs6DNe1izqL7M5x5EWOmFFtfs+1VMM7ubOB4565Z/
         ITOcyx2uWgXL2TZ3QytOE8cH0/ps4loZ8ux8TzT8upsDkcgqo4q0VzZPo9YsMcM4yh
         7Je/dTkdJYlPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Chen <harperchen1110@gmail.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, javierm@redhat.com,
        tzimmermann@suse.de, wsa+renesas@sang-engineering.com,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 4/9] fbdev: tgafb: Fix potential divide by zero
Date:   Wed, 22 Mar 2023 16:03:31 -0400
Message-Id: <20230322200337.1997810-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322200337.1997810-1-sashal@kernel.org>
References: <20230322200337.1997810-1-sashal@kernel.org>
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
index 65ba9921506e2..9d2912947eef6 100644
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

