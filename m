Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1352B2E41BA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437988AbgL1OHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:07:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:40666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437817AbgL1OGL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:06:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13E01207B2;
        Mon, 28 Dec 2020 14:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164330;
        bh=H8chfZMdhhDa44bhTU0lU6LWFMJfWquDGTBHpam9FH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPGhX9dJ391uKYnSJ+iO0+XjLrYZyf9FcZ+iLf6IQNlni8Ue+TQJQ9Hg/P7aXCrC1
         vamLvv60rDIVvkZHvME4Mt40HNVm7nBCD+VLgKxcrwCeLNpctrZWbu+JQu1JJVFWOs
         SpIDrzeknvOHOmqebK2K/bs/iRwoXboP9BfG+H1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 141/717] drm/meson: Free RDMA resources after tearing down DRM
Date:   Mon, 28 Dec 2020 13:42:19 +0100
Message-Id: <20201228125027.715231935@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit fa62ee25280ff6ae1f720f363263cb5e7743a8c8 ]

Removing the meson DRM module results in the following splat:

[ 2179.451346] Hardware name:  , BIOS 2021.01-rc2-00012-gde865f7ee1 11/16/2020
[ 2179.458316] Workqueue: events drm_mode_rmfb_work_fn [drm]
[ 2179.463597] pstate: 80c00009 (Nzcv daif +PAN +UAO -TCO BTYPE=--)
[ 2179.469558] pc : meson_rdma_writel_sync+0x44/0xb0 [meson_drm]
[ 2179.475243] lr : meson_g12a_afbcd_reset+0x34/0x60 [meson_drm]
[ 2179.480930] sp : ffffffc01212bb70
[ 2179.484207] x29: ffffffc01212bb70 x28: ffffff8044f66f00
[ 2179.489469] x27: ffffff8045b13800 x26: 0000000000000001
[ 2179.494730] x25: 0000000000000000 x24: 0000000000000001
[ 2179.499991] x23: 0000000000000000 x22: 0000000000000000
[ 2179.505252] x21: 0000000000280000 x20: 0000000000001a01
[ 2179.510513] x19: ffffff8046029480 x18: 0000000000000000
[ 2179.515775] x17: 0000000000000000 x16: 0000000000000000
[ 2179.521036] x15: 0000000000000000 x14: 0000000000000000
[ 2179.526297] x13: 0040000000000326 x12: 0309030303260300
[ 2179.531558] x11: 03000000054004a0 x10: 0418054004000400
[ 2179.536820] x9 : ffffffc008fe4914 x8 : ffffff8040a1adc0
[ 2179.542081] x7 : 0000000000000000 x6 : ffffff8042aa0080
[ 2179.547342] x5 : ffffff8044f66f00 x4 : ffffffc008fe5bc8
[ 2179.552603] x3 : 0000000000010101 x2 : 0000000000000001
[ 2179.557865] x1 : 0000000000000000 x0 : 0000000000000000
[ 2179.563127] Call trace:
[ 2179.565548]  meson_rdma_writel_sync+0x44/0xb0 [meson_drm]
[ 2179.570894]  meson_g12a_afbcd_reset+0x34/0x60 [meson_drm]
[ 2179.576241]  meson_plane_atomic_disable+0x38/0xb0 [meson_drm]
[ 2179.581966]  drm_atomic_helper_commit_planes+0x1e0/0x21c [drm_kms_helper]
[ 2179.588684]  drm_atomic_helper_commit_tail_rpm+0x68/0xb0 [drm_kms_helper]
[ 2179.595410]  commit_tail+0xac/0x190 [drm_kms_helper]
[ 2179.600326]  drm_atomic_helper_commit+0x16c/0x390 [drm_kms_helper]
[ 2179.606484]  drm_atomic_commit+0x58/0x70 [drm]
[ 2179.610880]  drm_framebuffer_remove+0x398/0x434 [drm]
[ 2179.615881]  drm_mode_rmfb_work_fn+0x68/0x8c [drm]
[ 2179.620575]  process_one_work+0x1cc/0x49c
[ 2179.624538]  worker_thread+0x200/0x444
[ 2179.628246]  kthread+0x14c/0x160
[ 2179.631439]  ret_from_fork+0x10/0x38

caused by the fact that the RDMA buffer has already been freed,
resulting in meson_rdma_writel_sync() getting a NULL pointer.

Move the afbcd reset and meson_rdma_free calls after the DRM
unregistration is complete so that the teardown can safely complete.

Fixes: d1b5e41e13a7 ("drm/meson: Add AFBCD module driver")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201116200744.495826-2-maz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_drv.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/meson/meson_drv.c b/drivers/gpu/drm/meson/meson_drv.c
index 8b9c8dd788c41..324fa489f1c46 100644
--- a/drivers/gpu/drm/meson/meson_drv.c
+++ b/drivers/gpu/drm/meson/meson_drv.c
@@ -389,15 +389,15 @@ static void meson_drv_unbind(struct device *dev)
 		meson_canvas_free(priv->canvas, priv->canvas_id_vd1_2);
 	}
 
-	if (priv->afbcd.ops) {
-		priv->afbcd.ops->reset(priv);
-		meson_rdma_free(priv);
-	}
-
 	drm_dev_unregister(drm);
 	drm_irq_uninstall(drm);
 	drm_kms_helper_poll_fini(drm);
 	drm_dev_put(drm);
+
+	if (priv->afbcd.ops) {
+		priv->afbcd.ops->reset(priv);
+		meson_rdma_free(priv);
+	}
 }
 
 static const struct component_master_ops meson_drv_master_ops = {
-- 
2.27.0



