Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408D0419B1E
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236785AbhI0RPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:15:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237256AbhI0RO1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:14:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F084F61372;
        Mon, 27 Sep 2021 17:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762604;
        bh=7Am295yXP2+roJTg6xQdBmZnwSTCwOsbDEkI2MsflAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0MRukzfmHyTXKw4kPHyzJKeUZuS/d+3NnkSS7V8lrrlZfcsKJ1MGlrGsEKUMbnFpG
         79Smb7FsviGo0KdMUII1+QyVLTvKShZvFNWUBb3YSDtx7r+FvKRIJAfc9jmUgLolCH
         hKtmyeOYdOFk4su97owQjF1AJ/hWxLagMIHErXpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Simon Ser <contact@emersion.fr>,
        Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <hwentlan@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/103] amd/display: downgrade validation failure log level
Date:   Mon, 27 Sep 2021 19:02:57 +0200
Message-Id: <20210927170228.704247683@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
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
index bc9df3f216f5..ce21a21ddb23 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8962,7 +8962,8 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
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



