Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C8231C198
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 19:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbhBOShf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 13:37:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:33734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229989AbhBOShe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 13:37:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FB3C64DEE;
        Mon, 15 Feb 2021 18:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613414213;
        bh=gZ+N1I5HIHR1YRe2mHJvMFBSNe9GgX/g1+pp2iLjckw=;
        h=From:To:Cc:Subject:Date:From;
        b=kwTXWJhjKce59p/BQHOYAhqhKvSPv3OVkKv2Yi3aMz5PZYVZniqifgWFA09StY9+v
         aZ7NE3aeqNShN6/ZbzlSiGwdtVnoK1U2i3+mq1dQtKdBJVaSrIRMxrIs8TJ7Taw3BA
         iUvqJjueR/JDJ6Bu/cGF3cxBg/fCLpVPpvT7hMfD4oCGhkXWacjrGWuRMWW5fJ4wk6
         MDejnVWL+Es34t71bz+upF3xK2twyN06sKLybk4g9t1huPiu60my9SbHbEPVt+e7KE
         JONwZWQwAsU7MemFQwqfboVAc6biZlwx+m1MulpxgWRY4vmSrrwA/rpWScs4KdcgAj
         +GhAi22Hpfarg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quanyang Wang <quanyang.wang@windriver.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 1/6] drm/xlnx: fix kmemleak by sending vblank_event in atomic_disable
Date:   Mon, 15 Feb 2021 13:36:46 -0500
Message-Id: <20210215183651.122001-1-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quanyang Wang <quanyang.wang@windriver.com>

[ Upstream commit a7e02f7796c163ac8297b30223bf24bade9f8a50 ]

When running xrandr to change resolution of DP, the kmemleak as below
can be observed:

unreferenced object 0xffff00080a351000 (size 256):
  comm "Xorg", pid 248, jiffies 4294899614 (age 19.960s)
  hex dump (first 32 bytes):
    98 a0 bc 01 08 00 ff ff 01 00 00 00 00 00 00 00  ................
    ff ff ff ff 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e0bd0f69>] kmemleak_alloc+0x30/0x40
    [<00000000cde2f318>] kmem_cache_alloc+0x3d4/0x588
    [<0000000088ea9bd7>] drm_atomic_helper_setup_commit+0x84/0x5f8
    [<000000002290a264>] drm_atomic_helper_commit+0x58/0x388
    [<00000000f6ea78c3>] drm_atomic_commit+0x4c/0x60
    [<00000000c8e0725e>] drm_atomic_connector_commit_dpms+0xe8/0x110
    [<0000000020ade187>] drm_mode_obj_set_property_ioctl+0x1b0/0x450
    [<00000000918206d6>] drm_connector_property_set_ioctl+0x3c/0x68
    [<000000008d51e7a5>] drm_ioctl_kernel+0xc4/0x118
    [<000000002a819b75>] drm_ioctl+0x214/0x448
    [<000000008ca4e588>] __arm64_sys_ioctl+0xa8/0xf0
    [<0000000034e15a35>] el0_svc_common.constprop.0+0x74/0x190
    [<000000001b93d916>] do_el0_svc+0x24/0x90
    [<00000000ce9230e0>] el0_svc+0x14/0x20
    [<00000000e3607d82>] el0_sync_handler+0xb0/0xb8
    [<000000003e79c15f>] el0_sync+0x174/0x180

This is because there is a scenario that a drm_crtc_commit commit is
allocated but not freed. The drm subsystem require/release references
to a CRTC commit by calling drm_crtc_commit_get/put, and when
drm_crtc_commit_put find that commit.ref.refcount is zero, it will
call __drm_crtc_commit_free to free this CRTC commit. Among these
drm_crtc_commit_get/put pairs, there is a drm_crtc_commit_get in
drm_atomic_helper_setup_commit as below:

...
new_crtc_state->event->base.completion = &commit->flip_done;
new_crtc_state->event->base.completion_release = release_crtc_commit;
drm_crtc_commit_get(commit);
...

This reference to the CRTC commit should be released at the function
release_crtc_commit by calling e->completion_release(e->completion) in
drm_send_event_locked. So we need to call drm_send_event_locked at
two places: handling vblank event in the irq handler and the crtc disable
helper. But in zynqmp_disp_crtc_atomic_disable, it only marks the flip
is done and not call drm_crtc_commit_put. This result that the refcount
of this commit is always non-zero and this commit will never be freed.

Since the function drm_crtc_send_vblank_event has operations both sending
a flip_done signal and releasing reference to the CRTC commit, let's use
it instead.

Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210202064121.173362-1-quanyang.wang@windriver.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xlnx/zynqmp_disp.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/xlnx/zynqmp_disp.c b/drivers/gpu/drm/xlnx/zynqmp_disp.c
index 98bd48f13fd11..8cd8af35cfaac 100644
--- a/drivers/gpu/drm/xlnx/zynqmp_disp.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_disp.c
@@ -1398,19 +1398,11 @@ static void zynqmp_disp_enable(struct zynqmp_disp *disp)
  */
 static void zynqmp_disp_disable(struct zynqmp_disp *disp)
 {
-	struct drm_crtc *crtc = &disp->crtc;
-
 	zynqmp_disp_audio_disable(&disp->audio);
 
 	zynqmp_disp_avbuf_disable_audio(&disp->avbuf);
 	zynqmp_disp_avbuf_disable_channels(&disp->avbuf);
 	zynqmp_disp_avbuf_disable(&disp->avbuf);
-
-	/* Mark the flip is done as crtc is disabled anyway */
-	if (crtc->state->event) {
-		complete_all(crtc->state->event->base.completion);
-		crtc->state->event = NULL;
-	}
 }
 
 static inline struct zynqmp_disp *crtc_to_disp(struct drm_crtc *crtc)
@@ -1499,6 +1491,13 @@ zynqmp_disp_crtc_atomic_disable(struct drm_crtc *crtc,
 
 	drm_crtc_vblank_off(&disp->crtc);
 
+	spin_lock_irq(&crtc->dev->event_lock);
+	if (crtc->state->event) {
+		drm_crtc_send_vblank_event(crtc, crtc->state->event);
+		crtc->state->event = NULL;
+	}
+	spin_unlock_irq(&crtc->dev->event_lock);
+
 	clk_disable_unprepare(disp->pclk);
 	pm_runtime_put_sync(disp->dev);
 }
-- 
2.27.0

