Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDB2DCD76F
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728917AbfJFR3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:29:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728913AbfJFR3D (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:29:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E05882133F;
        Sun,  6 Oct 2019 17:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382943;
        bh=5PN5gHuZThoRxTF4pnmnlVuDVJAKrvmI1Q8ep/YnmwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RAObqKIjwoBz2Drc5m/s8ovA49VepZM2KVXH4UHe8akNMXf6Ti5n5K0Q+g0WC1x1D
         R+whq/ha4/8VhrT/xoLME/ysGKAMyDSMX3zREOSbJ3e4Zye5DHXMyuJIyFx/oqJH2p
         +McueLWCQuizfiFLAsUg3geAU2PZJEuBQOllAN+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, hexin <hexin15@baidu.com>,
        Liu Qi <liuqi16@baidu.com>, Zhang Yu <zhangyu31@baidu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 028/106] vfio_pci: Restore original state on release
Date:   Sun,  6 Oct 2019 19:20:34 +0200
Message-Id: <20191006171138.549885140@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
References: <20191006171124.641144086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 6cf00d9f512b7..a92c2868d9021 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -373,11 +373,20 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
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



