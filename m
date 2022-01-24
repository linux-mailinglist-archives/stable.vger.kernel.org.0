Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB9549A9D0
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323638AbiAYD3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:29:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354079AbiAXVFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:05:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A5BC06809B;
        Mon, 24 Jan 2022 12:05:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18D83B811FB;
        Mon, 24 Jan 2022 20:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4026FC340E5;
        Mon, 24 Jan 2022 20:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054729;
        bh=J3h6L2kwUZJ7G0s0Kn2R/BUw7Zxwyn30CVsABOeUez4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=az0ZmAnwJ4Tfyx1RyLT5SM9/oRRgo/ErohZAzuhLggCYppBILzg/PHtvHA5/9+EkG
         cNEcwrCY6AEjEHg0m8epaGMCmm7iOgdtdsykqQmQQ/T4YVnbFaAPfnMYY1+7oxxqGQ
         oC69jT3SlhmZewGdacb9CsndQJ017wrTtrlWsMcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Jan Stancek <jstancek@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 484/563] drm/radeon: fix error handling in radeon_driver_open_kms
Date:   Mon, 24 Jan 2022 19:44:09 +0100
Message-Id: <20220124184041.188741901@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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


