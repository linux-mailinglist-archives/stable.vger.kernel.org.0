Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89324498B28
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345178AbiAXTMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346253AbiAXTFO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:05:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D909CC0613EB;
        Mon, 24 Jan 2022 11:00:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A68860010;
        Mon, 24 Jan 2022 19:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B76C340E5;
        Mon, 24 Jan 2022 19:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050832;
        bh=xc4nnjOqKkJyiHkaXw1RU+ZlPk2fOnql3U4DXhHAocM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qlve4r/ChbOINb2tLB6APbcZrLeEjCJ4zQ+k4jKXUFPiP9Tm0pJeWV7kvBwlGp5Xn
         u4tPjwmKco+/S6UjHfd8iene8HrXkSdy2xOCtD/hvVJqgFwFd1nNjrWx5hxDYDIAPB
         2leCoi5xmmFY38hfWUUiy5PyGrCaJ4HE17PQUXm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Jan Stancek <jstancek@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.9 127/157] drm/radeon: fix error handling in radeon_driver_open_kms
Date:   Mon, 24 Jan 2022 19:43:37 +0100
Message-Id: <20220124183936.808052553@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
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
@@ -648,18 +648,18 @@ int radeon_driver_open_kms(struct drm_de
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
@@ -667,7 +667,7 @@ int radeon_driver_open_kms(struct drm_de
 							rdev->ring_tmp_bo.bo);
 			if (!vm->ib_bo_va) {
 				r = -ENOMEM;
-				goto out_vm_fini;
+				goto err_vm_fini;
 			}
 
 			r = radeon_vm_bo_set_addr(rdev, vm->ib_bo_va,
@@ -675,19 +675,21 @@ int radeon_driver_open_kms(struct drm_de
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


