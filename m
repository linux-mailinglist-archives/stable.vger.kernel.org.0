Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47853BCBE8
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbhGFLRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:17:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232202AbhGFLRl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:17:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5C1561A14;
        Tue,  6 Jul 2021 11:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570103;
        bh=woZHgorVR7Q0m33QF4ihy7qs1+znD/0nAYjA2QP/kTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ize0dZTODvAeupeSDMYUtdXXCB/tfgFhrbT3QhhEP1T6HxO+3y2nk4He4V2d2oOim
         68QW0T8CN5D7IwZf+buAvrpLBe8HETW5n9jWzyIKkxWL2En/qEEn9vqwN1i7/6gnee
         +4DB1AVsWwtR6s9KIcVxYuekTx0/Rt6ZmyOVMhoBTdSoebhng+l74nSuD91VfN10Ge
         hY+BJMubt8BPJJG/Zdghy+abp7lQ9mPfsgooz9g+on2xU64719ZAGJHaJFjMqiZEC6
         N/76Vxt1K/hNyucJjSYJU09zpPhcR/rZPmGRjpwZ3RKNQOLldy/4bGQu4H54rb195N
         TVz4kxYpb1kmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 037/189] drm/amdgpu/display: restore the backlight on modeset (v2)
Date:   Tue,  6 Jul 2021 07:11:37 -0400
Message-Id: <20210706111409.2058071-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 7230362c78d441020a47d7d5ca81f8a3d07bd9f0 ]

To stay consistent with the user's setting.

v2: rebase on multi-eDP support

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1337
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 875fd187463e..62663e287b21 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8967,6 +8967,12 @@ static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_state *state)
 	/* Update audio instances for each connector. */
 	amdgpu_dm_commit_audio(dev, state);
 
+#if defined(CONFIG_BACKLIGHT_CLASS_DEVICE) ||		\
+	defined(CONFIG_BACKLIGHT_CLASS_DEVICE_MODULE)
+	/* restore the backlight level */
+	if (dm->backlight_dev)
+		amdgpu_dm_backlight_set_level(dm, dm->brightness[0]);
+#endif
 	/*
 	 * send vblank event on all events not handled in flip and
 	 * mark consumed event for drm_atomic_helper_commit_hw_done
-- 
2.30.2

