Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F05E194CD9
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 00:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgCZX1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 19:27:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728159AbgCZXZC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 19:25:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6ACD21707;
        Thu, 26 Mar 2020 23:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585265101;
        bh=TOlzQZqFBlXXk6vVW3nEQ7OnPHurudRh2uEU+6f1lvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1ijmhJ07r5cQ5V+GQ/wAvyxZcHh6HIAZhwPkrjdwomjNwkjWkzbHD7sH5Jcj7xW6
         Puy0dGqRpoLXBJndQ31urDnH5tP08XE+2qoeioayuuKYd1QiNKFDSIF3TKwhC20rxw
         M+5RJT+d1eUk+uHgxlYP4evFJegW3AdbJgeFEMAE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 05/15] drm/bochs: downgrade pci_request_region failure from error to warning
Date:   Thu, 26 Mar 2020 19:24:45 -0400
Message-Id: <20200326232455.8029-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326232455.8029-1-sashal@kernel.org>
References: <20200326232455.8029-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerd Hoffmann <kraxel@redhat.com>

[ Upstream commit 8c34cd1a7f089dc03933289c5d4a4d1489549828 ]

Shutdown of firmware framebuffer has a bunch of problems.  Because
of this the framebuffer region might still be reserved even after
drm_fb_helper_remove_conflicting_pci_framebuffers() returned.

Don't consider pci_request_region() failure for the framebuffer
region as fatal error to workaround this issue.

Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Link: http://patchwork.freedesktop.org/patch/msgid/20200313084152.2734-1-kraxel@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bochs/bochs_hw.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bochs/bochs_hw.c b/drivers/gpu/drm/bochs/bochs_hw.c
index a39b0343c197d..401c218567af9 100644
--- a/drivers/gpu/drm/bochs/bochs_hw.c
+++ b/drivers/gpu/drm/bochs/bochs_hw.c
@@ -97,10 +97,8 @@ int bochs_hw_init(struct drm_device *dev, uint32_t flags)
 		size = min(size, mem);
 	}
 
-	if (pci_request_region(pdev, 0, "bochs-drm") != 0) {
-		DRM_ERROR("Cannot request framebuffer\n");
-		return -EBUSY;
-	}
+	if (pci_request_region(pdev, 0, "bochs-drm") != 0)
+		DRM_WARN("Cannot request framebuffer, boot fb still active?\n");
 
 	bochs->fb_map = ioremap(addr, size);
 	if (bochs->fb_map == NULL) {
-- 
2.20.1

