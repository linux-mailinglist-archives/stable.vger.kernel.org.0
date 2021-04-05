Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865CB353F3A
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239397AbhDEJKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:10:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239392AbhDEJKi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:10:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54682613A0;
        Mon,  5 Apr 2021 09:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613822;
        bh=b1u0xQ3xOw06czjnFgcm5d/aVKgUd2RJ+TU+aMfNJKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wuCRTxtQdZ/yRTBjKHM+It+X2sftWg7+xw0o30v9ZhcVi5n1zZemIePdgChQHPC/8
         qLZF2NkUazkvfqxcGpIoUJ/4VyVUXPwQHsOzh+w7kVRrnJK5xd0RYRdvdHwCDZ+Kdd
         OGNR41P/2YMiprFtOCxM0ezmizOJwZiOZ1D/nAhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/126] video: hyperv_fb: Fix a double free in hvfb_probe
Date:   Mon,  5 Apr 2021 10:54:25 +0200
Message-Id: <20210405085034.449202446@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit 37df9f3fedb6aeaff5564145e8162aab912c9284 ]

Function hvfb_probe() calls hvfb_getmem(), expecting upon return that
info->apertures is either NULL or points to memory that should be freed
by framebuffer_release().  But hvfb_getmem() is freeing the memory and
leaving the pointer non-NULL, resulting in a double free if an error
occurs or later if hvfb_remove() is called.

Fix this by removing all kfree(info->apertures) calls in hvfb_getmem().
This will allow framebuffer_release() to free the memory, which follows
the pattern of other fbdev drivers.

Fixes: 3a6fb6c4255c ("video: hyperv: hyperv_fb: Use physical memory for fb on HyperV Gen 1 VMs.")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20210324103724.4189-1-lyl2019@mail.ustc.edu.cn
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/hyperv_fb.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
index c8b0ae676809..4dc9077dd2ac 100644
--- a/drivers/video/fbdev/hyperv_fb.c
+++ b/drivers/video/fbdev/hyperv_fb.c
@@ -1031,7 +1031,6 @@ static int hvfb_getmem(struct hv_device *hdev, struct fb_info *info)
 			PCI_DEVICE_ID_HYPERV_VIDEO, NULL);
 		if (!pdev) {
 			pr_err("Unable to find PCI Hyper-V video\n");
-			kfree(info->apertures);
 			return -ENODEV;
 		}
 
@@ -1129,7 +1128,6 @@ getmem_done:
 	} else {
 		pci_dev_put(pdev);
 	}
-	kfree(info->apertures);
 
 	return 0;
 
@@ -1141,7 +1139,6 @@ err2:
 err1:
 	if (!gen2vm)
 		pci_dev_put(pdev);
-	kfree(info->apertures);
 
 	return -ENOMEM;
 }
-- 
2.30.2



