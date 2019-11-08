Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E18A7F461B
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388314AbfKHLkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:40:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:52930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388183AbfKHLkC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:40:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AE39222C2;
        Fri,  8 Nov 2019 11:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213202;
        bh=i2tWQS8K0Ossgcc5vBYSM8RWjs14zDUfRjUMgb8DQSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RI6D1H6WT2fLDZwloPGP2np3P381NSN9GYXoNXBGBIqQBf1FP83xmUZlJh26XbDGH
         XNGcMyCSHaOROvwMzT5GHM6XuMhwcxAFSV4R3iOLXhIFcCqn1kqBp7aNZVnKs9WzBf
         2cjQ7CknoIyUPYs/qNiQb0bVs9KJL6gXUCAOLY9w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Wu <peter@lekensteyn.nl>, Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org,
        spice-devel@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 085/205] qxl: fix null-pointer crash during suspend
Date:   Fri,  8 Nov 2019 06:35:52 -0500
Message-Id: <20191108113752.12502-85-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Wu <peter@lekensteyn.nl>

[ Upstream commit 7948a2b15873319d1bff4d37c09b9f2bf87b9021 ]

"crtc->helper_private" is not initialized by the QXL driver and thus the
"crtc_funcs->disable" call would crash (resulting in suspend failure).
Fix this by converting the suspend/resume functions to use the
drm_mode_config_helper_* helpers.

Tested system sleep with QEMU 3.0 using "echo mem > /sys/power/state".
During suspend the following message is visible from QEMU:

    spice/server/display-channel.c:2425:display_channel_validate_surface: canvas address is 0x7fd05da68308 for 0 (and is NULL)
    spice/server/display-channel.c:2426:display_channel_validate_surface: failed on 0

This seems to be triggered by QXL_IO_NOTIFY_CMD after
QXL_IO_DESTROY_PRIMARY_ASYNC, but aside from the warning things still
seem to work (tested with both the GTK and -spice options).

Signed-off-by: Peter Wu <peter@lekensteyn.nl>
Link: http://patchwork.freedesktop.org/patch/msgid/20180904202747.14968-1-peter@lekensteyn.nl
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/qxl/qxl_drv.c | 26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/qxl/qxl_drv.c b/drivers/gpu/drm/qxl/qxl_drv.c
index 2445e75cf7ea6..d00f45eed03ca 100644
--- a/drivers/gpu/drm/qxl/qxl_drv.c
+++ b/drivers/gpu/drm/qxl/qxl_drv.c
@@ -136,20 +136,11 @@ static int qxl_drm_freeze(struct drm_device *dev)
 {
 	struct pci_dev *pdev = dev->pdev;
 	struct qxl_device *qdev = dev->dev_private;
-	struct drm_crtc *crtc;
-
-	drm_kms_helper_poll_disable(dev);
-
-	console_lock();
-	qxl_fbdev_set_suspend(qdev, 1);
-	console_unlock();
+	int ret;
 
-	/* unpin the front buffers */
-	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
-		const struct drm_crtc_helper_funcs *crtc_funcs = crtc->helper_private;
-		if (crtc->enabled)
-			(*crtc_funcs->disable)(crtc);
-	}
+	ret = drm_mode_config_helper_suspend(dev);
+	if (ret)
+		return ret;
 
 	qxl_destroy_monitors_object(qdev);
 	qxl_surf_evict(qdev);
@@ -175,14 +166,7 @@ static int qxl_drm_resume(struct drm_device *dev, bool thaw)
 	}
 
 	qxl_create_monitors_object(qdev);
-	drm_helper_resume_force_mode(dev);
-
-	console_lock();
-	qxl_fbdev_set_suspend(qdev, 0);
-	console_unlock();
-
-	drm_kms_helper_poll_enable(dev);
-	return 0;
+	return drm_mode_config_helper_resume(dev);
 }
 
 static int qxl_pm_suspend(struct device *dev)
-- 
2.20.1

