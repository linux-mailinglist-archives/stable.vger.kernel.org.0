Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A67D5CD805
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfJFR4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730176AbfJFRft (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:35:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79AD62080F;
        Sun,  6 Oct 2019 17:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383349;
        bh=3LtsCDgG2wyB0+Zp2EqzJWjVdQVP2cXvkkS19JZpOP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IToYLT5BOsijvhu02fQDIKUT6YalbHjFdNQnA0Bab9VUWeYe+EOTkrVkyPtReOPLX
         hCrhIM4+5FrlF+5T5OfOVecTxw9rt3/rS21jlGvw8QQH6NZ7ib9NYPIOkICYgkFBun
         yQEK1H2dSwQYFvVW5p6jlj7BHmDEfJJy2Pfisr6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jean Delvare <jdelvare@suse.de>,
        Ken Wang <Qingqing.Wang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "David (ChunMing) Zhou" <David1.Zhou@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 070/137] drm/amdgpu/si: fix ASIC tests
Date:   Sun,  6 Oct 2019 19:20:54 +0200
Message-Id: <20191006171214.985222700@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171209.403038733@linuxfoundation.org>
References: <20191006171209.403038733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean Delvare <jdelvare@suse.de>

[ Upstream commit 77efe48a729588527afb4d5811b9e0acb29f5e51 ]

Comparing adev->family with CHIP constants is not correct.
adev->family can only be compared with AMDGPU_FAMILY constants and
adev->asic_type is the struct member to compare with CHIP constants.
They are separate identification spaces.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Fixes: 62a37553414a ("drm/amdgpu: add si implementation v10")
Cc: Ken Wang <Qingqing.Wang@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: "David (ChunMing) Zhou" <David1.Zhou@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/si.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/si.c b/drivers/gpu/drm/amd/amdgpu/si.c
index 9d8df68893b9d..1e34dfc143556 100644
--- a/drivers/gpu/drm/amd/amdgpu/si.c
+++ b/drivers/gpu/drm/amd/amdgpu/si.c
@@ -1867,7 +1867,7 @@ static void si_program_aspm(struct amdgpu_device *adev)
 			if (orig != data)
 				si_pif_phy1_wreg(adev,PB1_PIF_PWRDOWN_1, data);
 
-			if ((adev->family != CHIP_OLAND) && (adev->family != CHIP_HAINAN)) {
+			if ((adev->asic_type != CHIP_OLAND) && (adev->asic_type != CHIP_HAINAN)) {
 				orig = data = si_pif_phy0_rreg(adev,PB0_PIF_PWRDOWN_0);
 				data &= ~PLL_RAMP_UP_TIME_0_MASK;
 				if (orig != data)
@@ -1916,14 +1916,14 @@ static void si_program_aspm(struct amdgpu_device *adev)
 
 			orig = data = si_pif_phy0_rreg(adev,PB0_PIF_CNTL);
 			data &= ~LS2_EXIT_TIME_MASK;
-			if ((adev->family == CHIP_OLAND) || (adev->family == CHIP_HAINAN))
+			if ((adev->asic_type == CHIP_OLAND) || (adev->asic_type == CHIP_HAINAN))
 				data |= LS2_EXIT_TIME(5);
 			if (orig != data)
 				si_pif_phy0_wreg(adev,PB0_PIF_CNTL, data);
 
 			orig = data = si_pif_phy1_rreg(adev,PB1_PIF_CNTL);
 			data &= ~LS2_EXIT_TIME_MASK;
-			if ((adev->family == CHIP_OLAND) || (adev->family == CHIP_HAINAN))
+			if ((adev->asic_type == CHIP_OLAND) || (adev->asic_type == CHIP_HAINAN))
 				data |= LS2_EXIT_TIME(5);
 			if (orig != data)
 				si_pif_phy1_wreg(adev,PB1_PIF_CNTL, data);
-- 
2.20.1



