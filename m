Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5909338A165
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbhETJbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:31:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232308AbhETJ3A (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:29:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5AD3613AE;
        Thu, 20 May 2021 09:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502826;
        bh=xo2BE0jRTsQlvSw0irHZvlNT7/Jy4g468u2AeXVwLzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CY7mVauqzRX6vLRMhUe6DUYEGWP/CK9ov6MMxuMPH6/dOKv6E8bMqtAcA2ZYMGB32
         EtFF463bdx2Nh9qWaBvCvBvyGUIwRXaiA2ZKHnVWoYe6O7O4JR3yNE/w0qbPfGpbAo
         e77D4Hikp3a915fxRw9btpmH5iWtc4lSyafz//Qg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Darren Powell <darren.powell@amd.com>,
        Kenneth Feng <kenneth.feng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 31/47] amdgpu/pm: Prevent force of DCEFCLK on NAVI10 and SIENNA_CICHLID
Date:   Thu, 20 May 2021 11:22:29 +0200
Message-Id: <20210520092054.548487797@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.559923764@linuxfoundation.org>
References: <20210520092053.559923764@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darren Powell <darren.powell@amd.com>

[ Upstream commit b117b3964f38a988cb79825950dbd607c02237f3 ]

Writing to dcefclk causes the gpu to become unresponsive, and requires a reboot.
Patch ignores a .force_clk_levels(SMU_DCEFCLK) call and issues an
info message.

Signed-off-by: Darren Powell <darren.powell@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c         | 5 ++++-
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c | 4 +++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
index f2c8719b8395..52df6202a954 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
@@ -1110,7 +1110,6 @@ static int navi10_force_clk_levels(struct smu_context *smu,
 	case SMU_SOCCLK:
 	case SMU_MCLK:
 	case SMU_UCLK:
-	case SMU_DCEFCLK:
 	case SMU_FCLK:
 		/* There is only 2 levels for fine grained DPM */
 		if (navi10_is_support_fine_grained_dpm(smu, clk_type)) {
@@ -1130,6 +1129,10 @@ static int navi10_force_clk_levels(struct smu_context *smu,
 		if (ret)
 			return size;
 		break;
+	case SMU_DCEFCLK:
+		dev_info(smu->adev->dev,"Setting DCEFCLK min/max dpm level is not supported!\n");
+		break;
+
 	default:
 		break;
 	}
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index 31da8fae6fa9..471bbb78884b 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -1018,7 +1018,6 @@ static int sienna_cichlid_force_clk_levels(struct smu_context *smu,
 	case SMU_SOCCLK:
 	case SMU_MCLK:
 	case SMU_UCLK:
-	case SMU_DCEFCLK:
 	case SMU_FCLK:
 		/* There is only 2 levels for fine grained DPM */
 		if (sienna_cichlid_is_support_fine_grained_dpm(smu, clk_type)) {
@@ -1038,6 +1037,9 @@ static int sienna_cichlid_force_clk_levels(struct smu_context *smu,
 		if (ret)
 			goto forec_level_out;
 		break;
+	case SMU_DCEFCLK:
+		dev_info(smu->adev->dev,"Setting DCEFCLK min/max dpm level is not supported!\n");
+		break;
 	default:
 		break;
 	}
-- 
2.30.2



