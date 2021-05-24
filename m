Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41C438EA27
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbhEXOw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:52:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233747AbhEXOtw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:49:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BD0F613F9;
        Mon, 24 May 2021 14:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867657;
        bh=liBbmSEWTgGrl45+w2Z8Zd42KpUNMD5HI4NCGB0wRkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XmzC3Bjxizc0MIRBWgHGY1ehvK/98efD65hAz0R8QbS1gDQIwndyWm1gg3Wee99ky
         mJF/MkZC7cKx1XuvP++3W5y02zMnOiAcAlZz+52XKptX3z2KA4EmNITFTNsus5Npk2
         trcaR6IOk8TYebm2ylFUuADhDyofN6Rh0xirU74meAV8bgDAILUyTyuHkkRkc+RuOH
         abqH5/Jql6jNwJyfiiwo7fNXz1LqiA2ZrUchg28p8gyMJWxpDNrONodNxueEzKGNOX
         tPvEwMB4HDmP6uIqVJoM+iITjCCOjpaBO1uVArnhlRfIRi/qExfL7UYYb2063TE6NR
         Y/a5P5T/r2MIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lang Yu <Lang.Yu@amd.com>,
        =?UTF-8?q?Christian=20K=C3=83nig?= <christian.koenig@amd.com>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 59/63] drm/amd/amdgpu: fix a potential deadlock in gpu reset
Date:   Mon, 24 May 2021 10:46:16 -0400
Message-Id: <20210524144620.2497249-59-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144620.2497249-1-sashal@kernel.org>
References: <20210524144620.2497249-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lang Yu <Lang.Yu@amd.com>

[ Upstream commit 9c2876d56f1ce9b6b2072f1446fb1e8d1532cb3d ]

When amdgpu_ib_ring_tests failed, the reset logic called
amdgpu_device_ip_suspend twice, then deadlock occurred.
Deadlock log:

[  805.655192] amdgpu 0000:04:00.0: amdgpu: ib ring test failed (-110).
[  806.290952] [drm] free PSP TMR buffer

[  806.319406] ============================================
[  806.320315] WARNING: possible recursive locking detected
[  806.321225] 5.11.0-custom #1 Tainted: G        W  OEL
[  806.322135] --------------------------------------------
[  806.323043] cat/2593 is trying to acquire lock:
[  806.323825] ffff888136b1cdc8 (&adev->dm.dc_lock){+.+.}-{3:3}, at: dm_suspend+0xb8/0x1d0 [amdgpu]
[  806.325668]
               but task is already holding lock:
[  806.326664] ffff888136b1cdc8 (&adev->dm.dc_lock){+.+.}-{3:3}, at: dm_suspend+0xb8/0x1d0 [amdgpu]
[  806.328430]
               other info that might help us debug this:
[  806.329539]  Possible unsafe locking scenario:

[  806.330549]        CPU0
[  806.330983]        ----
[  806.331416]   lock(&adev->dm.dc_lock);
[  806.332086]   lock(&adev->dm.dc_lock);
[  806.332738]
                *** DEADLOCK ***

[  806.333747]  May be due to missing lock nesting notation

[  806.334899] 3 locks held by cat/2593:
[  806.335537]  #0: ffff888100d3f1b8 (&attr->mutex){+.+.}-{3:3}, at: simple_attr_read+0x4e/0x110
[  806.337009]  #1: ffff888136b1fd78 (&adev->reset_sem){++++}-{3:3}, at: amdgpu_device_lock_adev+0x42/0x94 [amdgpu]
[  806.339018]  #2: ffff888136b1cdc8 (&adev->dm.dc_lock){+.+.}-{3:3}, at: dm_suspend+0xb8/0x1d0 [amdgpu]
[  806.340869]
               stack backtrace:
[  806.341621] CPU: 6 PID: 2593 Comm: cat Tainted: G        W  OEL    5.11.0-custom #1
[  806.342921] Hardware name: AMD Celadon-CZN/Celadon-CZN, BIOS WLD0C23N_Weekly_20_12_2 12/23/2020
[  806.344413] Call Trace:
[  806.344849]  dump_stack+0x93/0xbd
[  806.345435]  __lock_acquire.cold+0x18a/0x2cf
[  806.346179]  lock_acquire+0xca/0x390
[  806.346807]  ? dm_suspend+0xb8/0x1d0 [amdgpu]
[  806.347813]  __mutex_lock+0x9b/0x930
[  806.348454]  ? dm_suspend+0xb8/0x1d0 [amdgpu]
[  806.349434]  ? amdgpu_device_indirect_rreg+0x58/0x70 [amdgpu]
[  806.350581]  ? _raw_spin_unlock_irqrestore+0x47/0x50
[  806.351437]  ? dm_suspend+0xb8/0x1d0 [amdgpu]
[  806.352437]  ? rcu_read_lock_sched_held+0x4f/0x80
[  806.353252]  ? rcu_read_lock_sched_held+0x4f/0x80
[  806.354064]  mutex_lock_nested+0x1b/0x20
[  806.354747]  ? mutex_lock_nested+0x1b/0x20
[  806.355457]  dm_suspend+0xb8/0x1d0 [amdgpu]
[  806.356427]  ? soc15_common_set_clockgating_state+0x17d/0x19 [amdgpu]
[  806.357736]  amdgpu_device_ip_suspend_phase1+0x78/0xd0 [amdgpu]
[  806.360394]  amdgpu_device_ip_suspend+0x21/0x70 [amdgpu]
[  806.362926]  amdgpu_device_pre_asic_reset+0xb3/0x270 [amdgpu]
[  806.365560]  amdgpu_device_gpu_recover.cold+0x679/0x8eb [amdgpu]

Signed-off-by: Lang Yu <Lang.Yu@amd.com>
Acked-by: Christian KÃnig <christian.koenig@amd.com>
Reviewed-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 5eee251e3335..85d90e857693 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4356,7 +4356,6 @@ static int amdgpu_do_asic_reset(struct amdgpu_hive_info *hive,
 			r = amdgpu_ib_ring_tests(tmp_adev);
 			if (r) {
 				dev_err(tmp_adev->dev, "ib ring test failed (%d).\n", r);
-				r = amdgpu_device_ip_suspend(tmp_adev);
 				need_full_reset = true;
 				r = -EAGAIN;
 				goto end;
-- 
2.30.2

