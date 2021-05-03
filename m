Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51018371A48
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbhECQj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:39:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231838AbhECQiE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:38:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 072FF613EB;
        Mon,  3 May 2021 16:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059796;
        bh=PMZe4y1Pv49clBBjyLBWLR9jo+5UWMwd1nvz/TZA390=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SRPv/P3skeNBVNLSzrVwMqfKoNXd6bFxYK1TC4Bg5IpuT4By6b/hk6i2wNLRsrAV/
         9IIHmMKru6Fx+pYdUbvF9ITB70BzJib7ROqTlp7HF6/0XRI1t3Cjf471CVW+qEIlzO
         u9pbHnAMu6cOPMTISy5J1SLy6P69BiswA8GGfM6xMLiKlL63ebKC83IZ1oYHZXjsLi
         L0RunjFMZf70bzZehKdgkI5tLAlZOM/8PZiEsOg/OpJsGUOwDsZCCloxtOQeNORyXW
         5PgSi1v6PY9Dq3qR1jA7SmJORSw9gzd+ClmUwzgEPxTtr3HRApXhsX+OKkZUs5NvhC
         gdFLSCq0bxg8Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kenneth Feng <kenneth.feng@amd.com>,
        Kevin Wang <kevin1.wang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 053/134] drm/amd/pm: fix workload mismatch on vega10
Date:   Mon,  3 May 2021 12:33:52 -0400
Message-Id: <20210503163513.2851510-53-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163513.2851510-1-sashal@kernel.org>
References: <20210503163513.2851510-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kenneth Feng <kenneth.feng@amd.com>

[ Upstream commit 0979d43259e13846d86ba17e451e17fec185d240 ]

Workload number mapped to the correct one.
This issue is only on vega10.

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Kevin Wang <kevin1.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
index 599ec9726601..959143eff651 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -5160,7 +5160,7 @@ static int vega10_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
 
 out:
 	smum_send_msg_to_smc_with_parameter(hwmgr, PPSMC_MSG_SetWorkloadMask,
-						1 << power_profile_mode,
+						(!power_profile_mode) ? 0 : 1 << (power_profile_mode - 1),
 						NULL);
 	hwmgr->power_profile_mode = power_profile_mode;
 
-- 
2.30.2

