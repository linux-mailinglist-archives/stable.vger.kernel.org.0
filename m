Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78927469CA9
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358931AbhLFPYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:24:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38978 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356501AbhLFPWM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:22:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 422AD61309;
        Mon,  6 Dec 2021 15:18:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2051AC341C2;
        Mon,  6 Dec 2021 15:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803922;
        bh=WcScSF7kddzukuf+3Gs4FU1f4IK0BYp1yQDTQh7CJ/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XAIPJ+CHVz4mCnK7zViqLNYPA1+o6JFZIMge2M4NOVcT8hAt7rjoWawhM+FGHOa9M
         Hl5ok5I0/iJwXg6YCmg66DtvELImWOK7TRA3B438+N7O70Mk/9ba04TSXdwZZBvOpU
         Sk0r3/wlj3ODuUPfKaFlEXE+DUhY1g8gmPZjViGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 5.10 094/130] drm/msm/a6xx: Allocate enough space for GMU registers
Date:   Mon,  6 Dec 2021 15:56:51 +0100
Message-Id: <20211206145602.900466601@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

commit b4d25abf9720b69a03465b09d0d62d1998ed6708 upstream.

In commit 142639a52a01 ("drm/msm/a6xx: fix crashstate capture for
A650") we changed a6xx_get_gmu_registers() to read 3 sets of
registers. Unfortunately, we didn't change the memory allocation for
the array. That leads to a KASAN warning (this was on the chromeos-5.4
kernel, which has the problematic commit backported to it):

  BUG: KASAN: slab-out-of-bounds in _a6xx_get_gmu_registers+0x144/0x430
  Write of size 8 at addr ffffff80c89432b0 by task A618-worker/209
  CPU: 5 PID: 209 Comm: A618-worker Tainted: G        W         5.4.156-lockdep #22
  Hardware name: Google Lazor Limozeen without Touchscreen (rev5 - rev8) (DT)
  Call trace:
   dump_backtrace+0x0/0x248
   show_stack+0x20/0x2c
   dump_stack+0x128/0x1ec
   print_address_description+0x88/0x4a0
   __kasan_report+0xfc/0x120
   kasan_report+0x10/0x18
   __asan_report_store8_noabort+0x1c/0x24
   _a6xx_get_gmu_registers+0x144/0x430
   a6xx_gpu_state_get+0x330/0x25d4
   msm_gpu_crashstate_capture+0xa0/0x84c
   recover_worker+0x328/0x838
   kthread_worker_fn+0x32c/0x574
   kthread+0x2dc/0x39c
   ret_from_fork+0x10/0x18

  Allocated by task 209:
   __kasan_kmalloc+0xfc/0x1c4
   kasan_kmalloc+0xc/0x14
   kmem_cache_alloc_trace+0x1f0/0x2a0
   a6xx_gpu_state_get+0x164/0x25d4
   msm_gpu_crashstate_capture+0xa0/0x84c
   recover_worker+0x328/0x838
   kthread_worker_fn+0x32c/0x574
   kthread+0x2dc/0x39c
   ret_from_fork+0x10/0x18

Fixes: 142639a52a01 ("drm/msm/a6xx: fix crashstate capture for A650")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20211103153049.1.Idfa574ccb529d17b69db3a1852e49b580132035c@changeid
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
@@ -777,12 +777,12 @@ static void a6xx_get_gmu_registers(struc
 	struct a6xx_gpu *a6xx_gpu = to_a6xx_gpu(adreno_gpu);
 
 	a6xx_state->gmu_registers = state_kcalloc(a6xx_state,
-		2, sizeof(*a6xx_state->gmu_registers));
+		3, sizeof(*a6xx_state->gmu_registers));
 
 	if (!a6xx_state->gmu_registers)
 		return;
 
-	a6xx_state->nr_gmu_registers = 2;
+	a6xx_state->nr_gmu_registers = 3;
 
 	/* Get the CX GMU registers from AHB */
 	_a6xx_get_gmu_registers(gpu, a6xx_state, &a6xx_gmu_reglist[0],


