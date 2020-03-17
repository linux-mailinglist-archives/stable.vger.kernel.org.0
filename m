Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7CD61880FD
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729193AbgCQLNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:13:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728963AbgCQLNJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:13:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E9CA206EC;
        Tue, 17 Mar 2020 11:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443588;
        bh=Qug1L98ZOVgs7A3T9Nz4VumZo9JX5os4V3ilimJkW8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C1L+7uk3Ef3mM7Cgpzeu5uS4g2ZzjQGRj6Ns9x78M/P6x3/DNALvli5E/XmSYDVsc
         SdbZXAPkrEhVOa7GxDw4UxadQmKpxpQDfCVpjMLQ5YnVBgZ5ZkNRwZ42K6ZrlKXysD
         6bnwvVEmhpHBbgbs46PuyHqqAvU/xp1Wy8luY9Kk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Xu <colin.xu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: [PATCH 5.5 132/151] drm/i915/gvt: Fix unnecessary schedule timer when no vGPU exits
Date:   Tue, 17 Mar 2020 11:55:42 +0100
Message-Id: <20200317103335.816809879@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenyu Wang <zhenyuw@linux.intel.com>

commit 04d6067f1f19e70a418f92fa3170cf7fe53b7fdf upstream.

>From commit f25a49ab8ab9 ("drm/i915/gvt: Use vgpu_lock to protect per
vgpu access") the vgpu idr destroy is moved later than vgpu resource
destroy, then it would fail to stop timer for schedule policy clean
which to check vgpu idr for any left vGPU. So this trys to destroy
vgpu idr earlier.

Cc: Colin Xu <colin.xu@intel.com>
Fixes: f25a49ab8ab9 ("drm/i915/gvt: Use vgpu_lock to protect per vgpu access")
Acked-by: Colin Xu <colin.xu@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20200229055445.31481-1-zhenyuw@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gvt/vgpu.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/gvt/vgpu.c
+++ b/drivers/gpu/drm/i915/gvt/vgpu.c
@@ -272,10 +272,17 @@ void intel_gvt_destroy_vgpu(struct intel
 {
 	struct intel_gvt *gvt = vgpu->gvt;
 
-	mutex_lock(&vgpu->vgpu_lock);
-
 	WARN(vgpu->active, "vGPU is still active!\n");
 
+	/*
+	 * remove idr first so later clean can judge if need to stop
+	 * service if no active vgpu.
+	 */
+	mutex_lock(&gvt->lock);
+	idr_remove(&gvt->vgpu_idr, vgpu->id);
+	mutex_unlock(&gvt->lock);
+
+	mutex_lock(&vgpu->vgpu_lock);
 	intel_gvt_debugfs_remove_vgpu(vgpu);
 	intel_vgpu_clean_sched_policy(vgpu);
 	intel_vgpu_clean_submission(vgpu);
@@ -290,7 +297,6 @@ void intel_gvt_destroy_vgpu(struct intel
 	mutex_unlock(&vgpu->vgpu_lock);
 
 	mutex_lock(&gvt->lock);
-	idr_remove(&gvt->vgpu_idr, vgpu->id);
 	if (idr_is_empty(&gvt->vgpu_idr))
 		intel_gvt_clean_irq(gvt);
 	intel_gvt_update_vgpu_types(gvt);


