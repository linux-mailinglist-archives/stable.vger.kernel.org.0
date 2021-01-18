Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF972FA2F7
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404845AbhARO0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:26:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:39804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390164AbhARLos (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:44:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B868D2222A;
        Mon, 18 Jan 2021 11:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970227;
        bh=atM/We5CsFzw3dFfBXTIftb+fTP0t+mUCTgaENwNCyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ib0eJuBFvZMbPNqinArYQhFN9bf7ynSMgJp4JYAMfGg7HTza6/yqiYd1GbzQ9Ppg0
         KNouFb3KDnqLc5yQjD+IS7XdAjUYwkX+QxYfZZr0WMJo5+dCaxflKfNNSAENbLqNma
         oE/JWBuhMazfQOjn6sFQYumLJrdYmPi0wIpSHcaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaojian Du <Xiaojian.Du@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/152] drm/amd/pm: fix the failure when change power profile for renoir
Date:   Mon, 18 Jan 2021 12:34:25 +0100
Message-Id: <20210118113357.068522903@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaojian Du <Xiaojian.Du@amd.com>

[ Upstream commit 44cb39e19a05ca711bcb6e776e0a4399223204a0 ]

This patch is to fix the failure when change power profile to
"profile_peak" for renoir.

Signed-off-by: Xiaojian Du <Xiaojian.Du@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c | 1 +
 drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c
index 66c1026489bee..425c48e100e4f 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c
@@ -188,6 +188,7 @@ static int renoir_get_dpm_clk_limited(struct smu_context *smu, enum smu_clk_type
 			return -EINVAL;
 		*freq = clk_table->SocClocks[dpm_level].Freq;
 		break;
+	case SMU_UCLK:
 	case SMU_MCLK:
 		if (dpm_level >= NUM_FCLK_DPM_LEVELS)
 			return -EINVAL;
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c
index 660f403d5770c..7907c9e0b5dec 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c
@@ -222,6 +222,7 @@ int smu_v12_0_set_soft_freq_limited_range(struct smu_context *smu, enum smu_clk_
 	break;
 	case SMU_FCLK:
 	case SMU_MCLK:
+	case SMU_UCLK:
 		ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_SetHardMinFclkByFreq, min, NULL);
 		if (ret)
 			return ret;
-- 
2.27.0



