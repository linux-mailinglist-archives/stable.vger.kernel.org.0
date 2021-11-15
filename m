Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF634510B3
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242206AbhKOSw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:52:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:54286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243039AbhKOSuT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:50:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AE206329E;
        Mon, 15 Nov 2021 18:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999719;
        bh=N+Bj+wAF873haLBg7hJqpZg0pZSa3f8x9A5JPxO8PDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ENCdUP22rrv9hlfLqnKlb5bBx6bq+ezlnHf4Qkf4sZKj7ugzxtJJVSychrkv48XaU
         iWoDoyYE4DNkg66sGCp0UTzkETaL92up2bj6pkUQzaVUm+R9mAMk5yHZogNjY6W6as
         LsXiTFXu2LhAO6KqrOn/nU1g6p/SvNdrwQefR5HE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 399/849] drm: fb_helper: fix CONFIG_FB dependency
Date:   Mon, 15 Nov 2021 17:58:02 +0100
Message-Id: <20211115165433.756935028@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 606b102876e3741851dfb09d53f3ee57f650a52c ]

With CONFIG_FB=m and CONFIG_DRM=y, we get a link error in the fb helper:

aarch64-linux-ld: drivers/gpu/drm/drm_fb_helper.o: in function `drm_fb_helper_alloc_fbi':
(.text+0x10cc): undefined reference to `framebuffer_alloc'

Tighten the dependency so it is only allowed in the case that DRM can
link against FB.

Fixes: f611b1e7624c ("drm: Avoid circular dependencies for CONFIG_FB")
Link: https://lore.kernel.org/all/20210721152211.2706171-1-arnd@kernel.org/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210927142816.2069269-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 7ff89690a976a..061f4382c796e 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -98,7 +98,7 @@ config DRM_DEBUG_DP_MST_TOPOLOGY_REFS
 config DRM_FBDEV_EMULATION
 	bool "Enable legacy fbdev support for your modesetting driver"
 	depends on DRM
-	depends on FB
+	depends on FB=y || FB=DRM
 	select DRM_KMS_HELPER
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
-- 
2.33.0



