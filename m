Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7924575E9
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237200AbhKSRnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:43:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:44938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237153AbhKSRm4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:42:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03234611F2;
        Fri, 19 Nov 2021 17:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343594;
        bh=eIoi5cb2uZ1SjAlT+hsn1si6Fb8c/lJZZRrAwsiuqmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q9QRxKnUwg7UFXcz7sd5KoHvc7jNi5TeI+GYJlSJaU90XuiGxZkU5D9CHupMxpQ0W
         0VLXjPcM5c6ydPHBjwURKgBejgb1ArhDh/7hQCde6TJDNvJEccz1kyMJVw3S9Q/XYu
         +rBOfTu0AcuhnVWDLJLs/6dQWqcD/vzd28Lp7px0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 02/20] Revert "drm: fb_helper: improve CONFIG_FB dependency"
Date:   Fri, 19 Nov 2021 18:39:20 +0100
Message-Id: <20211119171444.717200425@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119171444.640508836@linuxfoundation.org>
References: <20211119171444.640508836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 94e18f5a5dd1b5e3b89c665fc5ff780858b1c9f6 which is
commit 9d6366e743f37d36ef69347924ead7bcc596076e upstream.

It causes some build problems as reported by Jiri.

Link: https://lore.kernel.org/r/9fdb2bf1-de52-1b9d-4783-c61ce39e8f51@kernel.org
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/Kconfig |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -102,8 +102,9 @@ config DRM_DEBUG_DP_MST_TOPOLOGY_REFS
 
 config DRM_FBDEV_EMULATION
 	bool "Enable legacy fbdev support for your modesetting driver"
-	depends on DRM_KMS_HELPER
-	depends on FB=y || FB=DRM_KMS_HELPER
+	depends on DRM
+	depends on FB=y || FB=DRM
+	select DRM_KMS_HELPER
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT


