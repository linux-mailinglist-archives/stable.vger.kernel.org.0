Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDF5245149F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345546AbhKOULJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:11:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344861AbhKOTZh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08BD7633EA;
        Mon, 15 Nov 2021 19:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003139;
        bh=f8gty+WLiHutbHNkQOaSNnv+f+jGd0BikuIYN65v1LQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hhASbQLu/ek8LqjaVBNjKuLe/OpxwYNK3psnjEHmI0lEfYWPLEezVhIZoLGczdima
         kCuoTT2782JLH9dVKnv9VwnfBum+xwk4p3hz6XN01pe7NcJdRq7JawSE/bpMmNdNuP
         FR/UaO/m+Pk9NmIJSnsWix+KFcFXUwL8y2MGelGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Acked-by: Jani Nikula" <jani.nikula@intel.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 808/917] drm: fb_helper: improve CONFIG_FB dependency
Date:   Mon, 15 Nov 2021 18:05:03 +0100
Message-Id: <20211115165456.391822721@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 9d6366e743f37d36ef69347924ead7bcc596076e ]

My previous patch correctly addressed the possible link failure, but as
Jani points out, the dependency is now stricter than it needs to be.

Change it again, to allow DRM_FBDEV_EMULATION to be used when
DRM_KMS_HELPER and FB are both loadable modules and DRM is linked into
the kernel.

As a side-effect, the option is now only visible when at least one DRM
driver makes use of DRM_KMS_HELPER. This is better, because the option
has no effect otherwise.

Fixes: 606b102876e3 ("drm: fb_helper: fix CONFIG_FB dependency")
Suggested-by: Acked-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20211029120307.1407047-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/Kconfig | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 9199f53861cac..6ae4269118af3 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -102,9 +102,8 @@ config DRM_DEBUG_DP_MST_TOPOLOGY_REFS
 
 config DRM_FBDEV_EMULATION
 	bool "Enable legacy fbdev support for your modesetting driver"
-	depends on DRM
-	depends on FB=y || FB=DRM
-	select DRM_KMS_HELPER
+	depends on DRM_KMS_HELPER
+	depends on FB=y || FB=DRM_KMS_HELPER
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-- 
2.33.0



