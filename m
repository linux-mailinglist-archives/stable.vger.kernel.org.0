Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB57461F31
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243268AbhK2Sor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:44:47 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:56550 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380086AbhK2Smq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:42:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2DB2BCE12FD;
        Mon, 29 Nov 2021 18:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FDFC53FC7;
        Mon, 29 Nov 2021 18:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211165;
        bh=r0/d1W9OUm2281L+QL1xYPmIMNiUshozO+Fm8Erda38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ULYYLXqST8VHP7nlnyLzJoBdg4dHbx21NA4CuRcMGN6c9iW4JsLgZFlRVdKBUawxQ
         VjGTlSS9S/CbeB8lWWI+aVCyr0D+9D5Ts4fbyK2YThPfe2Qphe7LcAzcT0C761HFVn
         IBjnYrH4NF4wd8M/7sRyvBMtWtffKp3ugJCRHEEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mohammed Gamal <mgamal@redhat.com>,
        Deepak Rawat <drawat.floss@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 127/179] drm/hyperv: Fix device removal on Gen1 VMs
Date:   Mon, 29 Nov 2021 19:18:41 +0100
Message-Id: <20211129181723.143657351@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mohammed Gamal <mgamal@redhat.com>

[ Upstream commit e048834c209a02e3776bcc47d43c6d863e3a67ca ]

The Hyper-V DRM driver tries to free MMIO region on removing
the device regardless of VM type, while Gen1 VMs don't use MMIO
and hence causing the kernel to crash on a NULL pointer dereference.

Fix this by making deallocating MMIO only on Gen2 machines and implement
removal for Gen1

Fixes: 76c56a5affeb ("drm/hyperv: Add DRM driver for hyperv synthetic video device")

Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
Reviewed-by: Deepak Rawat <drawat.floss@gmail.com>
Signed-off-by: Deepak Rawat <drawat.floss@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211119112900.300537-1-mgamal@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/hyperv/hyperv_drm_drv.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/hyperv/hyperv_drm_drv.c b/drivers/gpu/drm/hyperv/hyperv_drm_drv.c
index cd818a6291835..00e53de4812bb 100644
--- a/drivers/gpu/drm/hyperv/hyperv_drm_drv.c
+++ b/drivers/gpu/drm/hyperv/hyperv_drm_drv.c
@@ -225,12 +225,29 @@ static int hyperv_vmbus_remove(struct hv_device *hdev)
 {
 	struct drm_device *dev = hv_get_drvdata(hdev);
 	struct hyperv_drm_device *hv = to_hv(dev);
+	struct pci_dev *pdev;
 
 	drm_dev_unplug(dev);
 	drm_atomic_helper_shutdown(dev);
 	vmbus_close(hdev->channel);
 	hv_set_drvdata(hdev, NULL);
-	vmbus_free_mmio(hv->mem->start, hv->fb_size);
+
+	/*
+	 * Free allocated MMIO memory only on Gen2 VMs.
+	 * On Gen1 VMs, release the PCI device
+	 */
+	if (efi_enabled(EFI_BOOT)) {
+		vmbus_free_mmio(hv->mem->start, hv->fb_size);
+	} else {
+		pdev = pci_get_device(PCI_VENDOR_ID_MICROSOFT,
+				      PCI_DEVICE_ID_HYPERV_VIDEO, NULL);
+		if (!pdev) {
+			drm_err(dev, "Unable to find PCI Hyper-V video\n");
+			return -ENODEV;
+		}
+		pci_release_region(pdev, 0);
+		pci_dev_put(pdev);
+	}
 
 	return 0;
 }
-- 
2.33.0



