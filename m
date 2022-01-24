Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E68C49A932
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322308AbiAYDVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379630AbiAXUSc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:18:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F519C075953;
        Mon, 24 Jan 2022 11:38:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 182CCB8122A;
        Mon, 24 Jan 2022 19:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41097C340E7;
        Mon, 24 Jan 2022 19:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053112;
        bh=J3h6L2kwUZJ7G0s0Kn2R/BUw7Zxwyn30CVsABOeUez4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MnQ2o+rCDG+eV3jR4yMSFYxbFT7XyNfKfzSNN9CKs/iIz3ZJgTMlmy7Cb8XlSNXUk
         tVCJbKxS9cJsfE1SlPb1KnZziOOBNnVwDbwkdZ9g0qHKtiDlOeLpt+HlR/T0Dcdh13
         ayaPe2FTUMGJZaxk83hYYp3iRKkipiHpI7aRpz5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Jan Stancek <jstancek@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 273/320] drm/radeon: fix error handling in radeon_driver_open_kms
Date:   Mon, 24 Jan 2022 19:44:17 +0100
Message-Id: <20220124184003.262333170@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

commit 4722f463896cc0ef1a6f1c3cb2e171e949831249 upstream.

The return value was never initialized so the cleanup code executed when
it isn't even necessary.

Just add proper error handling.

Fixes: ab50cb9df889 ("drm/radeon/radeon_kms: Fix a NULL pointer dereference in radeon_driver_open_kms()")
Signed-off-by: Christian König <christian.koenig@amd.com>
Tested-by: Jan Stancek <jstancek@redhat.com>
Tested-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/radeon_kms.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -652,18 +652,18 @@ int radeon_driver_open_kms(struct drm_de
 		fpriv = kzalloc(sizeof(*fpriv), GFP_KERNEL);
 		if (unlikely(!fpriv)) {
 			r = -ENOMEM;
-			goto out_suspend;
+			goto err_suspend;
 		}
 
 		if (rdev->accel_working) {
 			vm = &fpriv->vm;
 			r = radeon_vm_init(rdev, vm);
 			if (r)
-				goto out_fpriv;
+				goto err_fpriv;
 
 			r = radeon_bo_reserve(rdev->ring_tmp_bo.bo, false);
 			if (r)
-				goto out_vm_fini;
+				goto err_vm_fini;
 
 			/* map the ib pool buffer read only into
 			 * virtual address space */
@@ -671,7 +671,7 @@ int radeon_driver_open_kms(struct drm_de
 							rdev->ring_tmp_bo.bo);
 			if (!vm->ib_bo_va) {
 				r = -ENOMEM;
-				goto out_vm_fini;
+				goto err_vm_fini;
 			}
 
 			r = radeon_vm_bo_set_addr(rdev, vm->ib_bo_va,
@@ -679,19 +679,21 @@ int radeon_driver_open_kms(struct drm_de
 						  RADEON_VM_PAGE_READABLE |
 						  RADEON_VM_PAGE_SNOOPED);
 			if (r)
-				goto out_vm_fini;
+				goto err_vm_fini;
 		}
 		file_priv->driver_priv = fpriv;
 	}
 
-	if (!r)
-		goto out_suspend;
+	pm_runtime_mark_last_busy(dev->dev);
+	pm_runtime_put_autosuspend(dev->dev);
+	return 0;
 
-out_vm_fini:
+err_vm_fini:
 	radeon_vm_fini(rdev, vm);
-out_fpriv:
+err_fpriv:
 	kfree(fpriv);
-out_suspend:
+
+err_suspend:
 	pm_runtime_mark_last_busy(dev->dev);
 	pm_runtime_put_autosuspend(dev->dev);
 	return r;


