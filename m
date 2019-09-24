Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71318BCE7B
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410856AbfIXQvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:51:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410852AbfIXQvK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:51:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32D8A2054F;
        Tue, 24 Sep 2019 16:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343870;
        bh=LJFHYulFXPRz00hr0S/1MEy5i14KMx4YvcI4Bj48vZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DjnxyTvO7/k2skMfzV/wwh8N+XM2a+g9s1B0JcLjcQltQsoQQq9dmcJAlQnfyrX/L
         1DIv8yBcVpqC5WP3MltKDFM3wRjUGOcryvdPI4bPIv/dRxpWHiC4bMDu0sZf9zYtGS
         KVhm/UiPs2vlkJmDaecmbSwcGQtWQJP5dUFdExIA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     hexin <hexin.op@gmail.com>, hexin <hexin15@baidu.com>,
        Liu Qi <liuqi16@baidu.com>, Zhang Yu <zhangyu31@baidu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 20/28] vfio_pci: Restore original state on release
Date:   Tue, 24 Sep 2019 12:50:23 -0400
Message-Id: <20190924165031.28292-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924165031.28292-1-sashal@kernel.org>
References: <20190924165031.28292-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: hexin <hexin.op@gmail.com>

[ Upstream commit 92c8026854c25093946e0d7fe536fd9eac440f06 ]

vfio_pci_enable() saves the device's initial configuration information
with the intent that it is restored in vfio_pci_disable().  However,
the commit referenced in Fixes: below replaced the call to
__pci_reset_function_locked(), which is not wrapped in a state save
and restore, with pci_try_reset_function(), which overwrites the
restored device state with the current state before applying it to the
device.  Reinstate use of __pci_reset_function_locked() to return to
the desired behavior.

Fixes: 890ed578df82 ("vfio-pci: Use pci "try" reset interface")
Signed-off-by: hexin <hexin15@baidu.com>
Signed-off-by: Liu Qi <liuqi16@baidu.com>
Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 6f5cc67e343e7..15b1cd4ef5a77 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -363,11 +363,20 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 	pci_write_config_word(pdev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE);
 
 	/*
-	 * Try to reset the device.  The success of this is dependent on
-	 * being able to lock the device, which is not always possible.
+	 * Try to get the locks ourselves to prevent a deadlock. The
+	 * success of this is dependent on being able to lock the device,
+	 * which is not always possible.
+	 * We can not use the "try" reset interface here, which will
+	 * overwrite the previously restored configuration information.
 	 */
-	if (vdev->reset_works && !pci_try_reset_function(pdev))
-		vdev->needs_reset = false;
+	if (vdev->reset_works && pci_cfg_access_trylock(pdev)) {
+		if (device_trylock(&pdev->dev)) {
+			if (!__pci_reset_function_locked(pdev))
+				vdev->needs_reset = false;
+			device_unlock(&pdev->dev);
+		}
+		pci_cfg_access_unlock(pdev);
+	}
 
 	pci_restore_state(pdev);
 out:
-- 
2.20.1

