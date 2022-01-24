Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FBD4989BC
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344138AbiAXS6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:58:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53486 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344144AbiAXS4B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:56:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E17FD6153F;
        Mon, 24 Jan 2022 18:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1754C340E5;
        Mon, 24 Jan 2022 18:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050559;
        bh=8CiU7b02IfI9DVn5xiIo5MTYuU5Jo6xdU+CHw3d+S2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C1VScGEM3VmKUEjCfaSbVaa1vRRg1urLgA3QtVJkojolezYzuhO+EJrDnVCapoxbW
         RTyxgOEKl7ASFa12VwfdokGG+Ci0kobwC48H0y72UnkPtLFfgZG1zeNInhOg5jQlDA
         CIoJAfnGSF/jRTZFo+7bJSoEVsBXhkR391vxSDw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Zhou Qingyang <zhou1615@umn.edu>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 039/157] drm/radeon/radeon_kms: Fix a NULL pointer dereference in radeon_driver_open_kms()
Date:   Mon, 24 Jan 2022 19:42:09 +0100
Message-Id: <20220124183934.041026358@linuxfoundation.org>
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

From: Zhou Qingyang <zhou1615@umn.edu>

[ Upstream commit ab50cb9df8896b39aae65c537a30de2c79c19735 ]

In radeon_driver_open_kms(), radeon_vm_bo_add() is assigned to
vm->ib_bo_va and passes and used in radeon_vm_bo_set_addr(). In
radeon_vm_bo_set_addr(), there is a dereference of vm->ib_bo_va,
which could lead to a NULL pointer dereference on failure of
radeon_vm_bo_add().

Fix this bug by adding a check of vm->ib_bo_va.

This bug was found by a static analyzer. The analysis employs
differential checking to identify inconsistent security operations
(e.g., checks or kfrees) between two code paths and confirms that the
inconsistent operations are not recovered in the current function or
the callers, so they constitute bugs.

Note that, as a bug found by static analysis, it can be a false
positive or hard to trigger. Multiple researchers have cross-reviewed
the bug.

Builds with CONFIG_DRM_RADEON=m show no new warnings,
and our static analyzer no longer warns about this code.

Fixes: cc9e67e3d700 ("drm/radeon: fix VM IB handling")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_kms.c | 36 ++++++++++++++++-------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index 61000e3b2e793..e65afdc4838d2 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -630,6 +630,8 @@ void radeon_driver_lastclose_kms(struct drm_device *dev)
 int radeon_driver_open_kms(struct drm_device *dev, struct drm_file *file_priv)
 {
 	struct radeon_device *rdev = dev->dev_private;
+	struct radeon_fpriv *fpriv;
+	struct radeon_vm *vm;
 	int r;
 
 	file_priv->driver_priv = NULL;
@@ -642,8 +644,6 @@ int radeon_driver_open_kms(struct drm_device *dev, struct drm_file *file_priv)
 
 	/* new gpu have virtual address space support */
 	if (rdev->family >= CHIP_CAYMAN) {
-		struct radeon_fpriv *fpriv;
-		struct radeon_vm *vm;
 
 		fpriv = kzalloc(sizeof(*fpriv), GFP_KERNEL);
 		if (unlikely(!fpriv)) {
@@ -654,35 +654,39 @@ int radeon_driver_open_kms(struct drm_device *dev, struct drm_file *file_priv)
 		if (rdev->accel_working) {
 			vm = &fpriv->vm;
 			r = radeon_vm_init(rdev, vm);
-			if (r) {
-				kfree(fpriv);
-				goto out_suspend;
-			}
+			if (r)
+				goto out_fpriv;
 
 			r = radeon_bo_reserve(rdev->ring_tmp_bo.bo, false);
-			if (r) {
-				radeon_vm_fini(rdev, vm);
-				kfree(fpriv);
-				goto out_suspend;
-			}
+			if (r)
+				goto out_vm_fini;
 
 			/* map the ib pool buffer read only into
 			 * virtual address space */
 			vm->ib_bo_va = radeon_vm_bo_add(rdev, vm,
 							rdev->ring_tmp_bo.bo);
+			if (!vm->ib_bo_va) {
+				r = -ENOMEM;
+				goto out_vm_fini;
+			}
+
 			r = radeon_vm_bo_set_addr(rdev, vm->ib_bo_va,
 						  RADEON_VA_IB_OFFSET,
 						  RADEON_VM_PAGE_READABLE |
 						  RADEON_VM_PAGE_SNOOPED);
-			if (r) {
-				radeon_vm_fini(rdev, vm);
-				kfree(fpriv);
-				goto out_suspend;
-			}
+			if (r)
+				goto out_vm_fini;
 		}
 		file_priv->driver_priv = fpriv;
 	}
 
+	if (!r)
+		goto out_suspend;
+
+out_vm_fini:
+	radeon_vm_fini(rdev, vm);
+out_fpriv:
+	kfree(fpriv);
 out_suspend:
 	pm_runtime_mark_last_busy(dev->dev);
 	pm_runtime_put_autosuspend(dev->dev);
-- 
2.34.1



