Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A9362157B
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235339AbiKHOMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235247AbiKHOM1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:12:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A924A57B78
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:11:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 465196157D
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5345AC433D7;
        Tue,  8 Nov 2022 14:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916715;
        bh=tgZrbmYo5mLJ7ElOY1Zk7nw4vS9jC9FkewzqzEPLAMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZt1l2mjUqvQygULOYFddCl1G3uLaZ9/LEaZh9SQ12WsmkWwhk8edOd8MR6GZxlnn
         rySf7HG7Ntu+pA/VMYolHa5anow4sg3YX47S6NoSr2dJQ+QOOsDjZeLA2Tp1Iop5ji
         z7cZfHsdW3I673D2FqAvK7o0tJl/qKJF6DnHgdg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Jonker <jbx6244@gmail.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        John Keeping <john@metanate.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 110/197] drm/rockchip: fix fbdev on non-IOMMU devices
Date:   Tue,  8 Nov 2022 14:39:08 +0100
Message-Id: <20221108133359.853735928@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Keeping <john@metanate.com>

[ Upstream commit ab78c74cfc5a3caa2bbb7627cb8f3bca40bb5fb0 ]

When switching to the generic fbdev infrastructure, it was missed that
framebuffers were created with the alloc_kmap parameter to
rockchip_gem_create_object() set to true.  The generic infrastructure
calls this via the .dumb_create() driver operation and thus creates a
buffer without an associated kmap.

alloc_kmap only makes a difference on devices without an IOMMU, but when
it is missing rockchip_gem_prime_vmap() fails and the framebuffer cannot
be used.

Detect the case where a buffer is being allocated for the framebuffer
and ensure a kernel mapping is created in this case.

Fixes: 24af7c34b290 ("drm/rockchip: use generic fbdev setup")
Reported-by: Johan Jonker <jbx6244@gmail.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: John Keeping <john@metanate.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20221020181248.2497065-1-john@metanate.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
index 985584147da1..cf8322c300bd 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
@@ -364,9 +364,12 @@ rockchip_gem_create_with_handle(struct drm_file *file_priv,
 {
 	struct rockchip_gem_object *rk_obj;
 	struct drm_gem_object *obj;
+	bool is_framebuffer;
 	int ret;
 
-	rk_obj = rockchip_gem_create_object(drm, size, false);
+	is_framebuffer = drm->fb_helper && file_priv == drm->fb_helper->client.file;
+
+	rk_obj = rockchip_gem_create_object(drm, size, is_framebuffer);
 	if (IS_ERR(rk_obj))
 		return ERR_CAST(rk_obj);
 
-- 
2.35.1



