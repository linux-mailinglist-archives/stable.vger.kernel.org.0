Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5895D52BAF1
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 14:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236798AbiERMaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 08:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236867AbiERM3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 08:29:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F26E195795;
        Wed, 18 May 2022 05:28:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 240FD6164C;
        Wed, 18 May 2022 12:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44938C34119;
        Wed, 18 May 2022 12:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876891;
        bh=2G3O/BeuOB/LP+pXY8WjpNyQcb0iZ9J+DrQIeLIcGXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=boOUcq/+nlWQEoFW6WOugy+AXfoip8MtHPwSJ2jzQu5iucQZa6ZHqkvuUPd8gV1cv
         SEIeJ9Rr5K6MXJ8AYXtRY740YD+OBB1AKHjjCSCRGzkxuOVw+8IXKTQIsUBe4T6SdW
         YN9L02OCFTmew9kz+//gRD0qJca91EUxGD5p2k06Ztj43S1p0GMcN9psuQkQ8HNTzT
         umPjyzoAWkQ+OOBODwIVGr/+aVG7mMVUJK8N90HciP2/CPjKQ6ycoE5vCU4nHtAzOX
         jFycRdjAA40VGdSiLOdnHH0hrbvo1uesHAvTtvOAd1W9+ifVlF3BTTDB/zGLVUKw7H
         HpEmhdlE2P89Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>, daniel@ffwll.ch,
        deller@gmx.de, wangqing@vivo.com, sam@ravnborg.org,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 07/17] fbdev: Prevent possible use-after-free in fb_release()
Date:   Wed, 18 May 2022 08:27:41 -0400
Message-Id: <20220518122753.342758-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122753.342758-1-sashal@kernel.org>
References: <20220518122753.342758-1-sashal@kernel.org>
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

From: Daniel Vetter <daniel.vetter@ffwll.ch>

[ Upstream commit 89bfd4017e58faaf70411555e7f508495114e90b ]

Most fbdev drivers have issues with the fb_info lifetime, because call to
framebuffer_release() from their driver's .remove callback, rather than
doing from fbops.fb_destroy callback.

Doing that will destroy the fb_info too early, while references to it may
still exist, leading to a use-after-free error.

To prevent this, check the fb_info reference counter when attempting to
kfree the data structure in framebuffer_release(). That will leak it but
at least will prevent the mentioned error.

Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220505220413.365977-1-javierm@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbsysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/video/fbdev/core/fbsysfs.c b/drivers/video/fbdev/core/fbsysfs.c
index 65dae05fff8e..ce699396d6ba 100644
--- a/drivers/video/fbdev/core/fbsysfs.c
+++ b/drivers/video/fbdev/core/fbsysfs.c
@@ -80,6 +80,10 @@ void framebuffer_release(struct fb_info *info)
 {
 	if (!info)
 		return;
+
+	if (WARN_ON(refcount_read(&info->count)))
+		return;
+
 	kfree(info->apertures);
 	kfree(info);
 }
-- 
2.35.1

