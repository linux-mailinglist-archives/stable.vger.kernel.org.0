Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2BC419CCB
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238356AbhI0RcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:32:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238718AbhI0RaJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF1B461260;
        Mon, 27 Sep 2021 17:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632763086;
        bh=bg4armjhIn88eWJC+InccEAOQ7x8kIRg46LfKAHspJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tC3iqpBb5UfykgvXz01KxzO0/40VeEC7iyWoGXZK5TVAVcDmmVopx9wD1AQNPYrdI
         r3mRkG78B+9/1xj2K/sDN5SODyDbOYb3jiHYTmhixdjkzH86H32VWijgVpWPRTNKmZ
         P69IYNCU00G5mkULrETXPjYkzJstVkBUVEa/AmKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Simon Ser <contact@emersion.fr>,
        Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <hwentlan@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 130/162] amd/display: downgrade validation failure log level
Date:   Mon, 27 Sep 2021 19:02:56 +0200
Message-Id: <20210927170237.926256349@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Ser <contact@emersion.fr>

[ Upstream commit 7bbee36d71502ab9a341505da89a017c7ae2e6b2 ]

In amdgpu_dm_atomic_check, dc_validate_global_state is called. On
failure this logs a warning to the kernel journal. However warnings
shouldn't be used for atomic test-only commit failures: user-space
might be perfoming a lot of atomic test-only commits to find the
best hardware configuration.

Downgrade the log to a regular DRM atomic message. While at it, use
the new device-aware logging infrastructure.

This fixes error messages in the kernel when running gamescope [1].

[1]: https://github.com/Plagman/gamescope/issues/245

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Simon Ser <contact@emersion.fr>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Harry Wentland <hwentlan@amd.com>
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 6a4c6c47dcfa..a4a4bb43c108 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10469,7 +10469,8 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 			goto fail;
 		status = dc_validate_global_state(dc, dm_state->context, false);
 		if (status != DC_OK) {
-			DC_LOG_WARNING("DC global validation failure: %s (%d)",
+			drm_dbg_atomic(dev,
+				       "DC global validation failure: %s (%d)",
 				       dc_status_to_str(status), status);
 			ret = -EINVAL;
 			goto fail;
-- 
2.33.0



