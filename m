Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B5B371B56
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbhECQph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:45:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231367AbhECQmj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:42:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CCDF61462;
        Mon,  3 May 2021 16:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059888;
        bh=DFaUFvaFSzNv+2K395Ty4lHD4aIvOZei9Y2R13qGQcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DfkqC7vNdaMGcAyOgxiBSMy3qp1GPO+o6fPiA9om/NLn+Jl5UZNjZ6y8ynaGzO9Jt
         dRHJNWUXuARjJYgBVxU06kOAvRu8AibJHnVIGEqyUuLvKiwIBPbBcskv/2ynJk1aKj
         lEBmMaebr3SlFYYf/Ue2PcjhBAqf4ZLbUHT/HbEXbBO4VG+b2DTyl69oZnK8HhXJw3
         zG3putMjjYW5PqebXbER82+cyI3LDSylQfVy2T19hz99Krwf96D5f1XnDviSG6Gc/L
         nnLaZRndhWfvIPRpnMejxC0xNvZ3zcEGb472mBv0fY2vs8V6r7eS+KMKlnkiu/NUz8
         99ZoCXDdTG9gQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kenneth Feng <kenneth.feng@amd.com>,
        Kevin Wang <kevin1.wang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.11 045/115] drm/amd/pm: fix workload mismatch on vega10
Date:   Mon,  3 May 2021 12:35:49 -0400
Message-Id: <20210503163700.2852194-45-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163700.2852194-1-sashal@kernel.org>
References: <20210503163700.2852194-1-sashal@kernel.org>
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
index 892f08f2ba42..13b5ae1c106f 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -5161,7 +5161,7 @@ static int vega10_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
 
 out:
 	smum_send_msg_to_smc_with_parameter(hwmgr, PPSMC_MSG_SetWorkloadMask,
-						1 << power_profile_mode,
+						(!power_profile_mode) ? 0 : 1 << (power_profile_mode - 1),
 						NULL);
 	hwmgr->power_profile_mode = power_profile_mode;
 
-- 
2.30.2

