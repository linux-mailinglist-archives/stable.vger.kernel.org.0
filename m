Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69DA45221C
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243469AbhKPBKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:10:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:44628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244849AbhKOTRq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:17:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B486D634D8;
        Mon, 15 Nov 2021 18:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000684;
        bh=Rt289Er5E6c1ZqXJzJUbGcvBjpk029QBfLxsVSboBfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qbrvZkxWf1f2Ut+jDZYv66qwAK0uPgH8ttz5MuDbStW03OmWndcoM0IZMzdVwUQc8
         d+jkfDka9QUtWSujBiQGySrSIppaXODCm9l/4KQ59zHaPVBMo0ZvEgQu4AsFx0T3Vn
         4OPpB54OJJ8GUg3aKF4XUI8XJC/rW15JGEWtpkek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 753/849] Revert "drm/imx: Annotate dma-fence critical section in commit path"
Date:   Mon, 15 Nov 2021 18:03:56 +0100
Message-Id: <20211115165445.723642624@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 14d9a37c952588930d7226953359fea3ab956d39 ]

This reverts commit f4b34faa08428d813fc3629f882c503487f94a12.

Since commit f4b34faa0842 ("drm/imx: Annotate dma-fence critical section in
commit path") the following possible circular dependency is detected:

[    5.001811] ======================================================
[    5.001817] WARNING: possible circular locking dependency detected
[    5.001824] 5.14.9-01225-g45da36cc6fcc-dirty #1 Tainted: G        W
[    5.001833] ------------------------------------------------------
[    5.001838] kworker/u8:0/7 is trying to acquire lock:
[    5.001848] c1752080 (regulator_list_mutex){+.+.}-{3:3}, at: regulator_lock_dependent+0x40/0x294
[    5.001903]
[    5.001903] but task is already holding lock:
[    5.001909] c176df78 (dma_fence_map){++++}-{0:0}, at: imx_drm_atomic_commit_tail+0x10/0x160
[    5.001957]
[    5.001957] which lock already depends on the new lock.
...

Revert it for now.

Tested on a imx6q-sabresd.

Fixes: f4b34faa0842 ("drm/imx: Annotate dma-fence critical section in commit path")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20211104001112.4035691-1-festevam@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/imx-drm-core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/imx/imx-drm-core.c b/drivers/gpu/drm/imx/imx-drm-core.c
index 76819a8ac37fe..3ccadfa14d6a8 100644
--- a/drivers/gpu/drm/imx/imx-drm-core.c
+++ b/drivers/gpu/drm/imx/imx-drm-core.c
@@ -81,7 +81,6 @@ static void imx_drm_atomic_commit_tail(struct drm_atomic_state *state)
 	struct drm_plane_state *old_plane_state, *new_plane_state;
 	bool plane_disabling = false;
 	int i;
-	bool fence_cookie = dma_fence_begin_signalling();
 
 	drm_atomic_helper_commit_modeset_disables(dev, state);
 
@@ -112,7 +111,6 @@ static void imx_drm_atomic_commit_tail(struct drm_atomic_state *state)
 	}
 
 	drm_atomic_helper_commit_hw_done(state);
-	dma_fence_end_signalling(fence_cookie);
 }
 
 static const struct drm_mode_config_helper_funcs imx_drm_mode_config_helpers = {
-- 
2.33.0



