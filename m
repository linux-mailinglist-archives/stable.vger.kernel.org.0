Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC90924BB7D
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbgHTM3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:29:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727822AbgHTJvY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:51:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 213F92067C;
        Thu, 20 Aug 2020 09:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917083;
        bh=mdP55MQ5hZd+LjwfofX9mTruh9HHZctyninsRPIAus0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdzFLyoMCU1P+EZ9TDiOvO3PKx/evM+d6mO3M8j5BkexnkxR/jbf54Kkm/b8BKhVB
         eQEbVekR+xmrZ1YErECGNEhvbgnxzUofxrB++UQoojZClNt5f1Uk39eXrZBnx8FrjD
         eObQoLC1vdevOcQ/mHF9PH9w2EnICelJGGvSYp8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sandeep Raghuraman <sandy.8925@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 151/152] drm/amdgpu: Fix bug where DPM is not enabled after hibernate and resume
Date:   Thu, 20 Aug 2020 11:21:58 +0200
Message-Id: <20200820091601.569990290@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sandeep Raghuraman <sandy.8925@gmail.com>

commit f87812284172a9809820d10143b573d833cd3f75 upstream.

Reproducing bug report here:
After hibernating and resuming, DPM is not enabled. This remains the case
even if you test hibernate using the steps here:
https://www.kernel.org/doc/html/latest/power/basic-pm-debugging.html

I debugged the problem, and figured out that in the file hardwaremanager.c,
in the function, phm_enable_dynamic_state_management(), the check
'if (!hwmgr->pp_one_vf && smum_is_dpm_running(hwmgr) && !amdgpu_passthrough(adev) && adev->in_suspend)'
returns true for the hibernate case, and false for the suspend case.

This means that for the hibernate case, the AMDGPU driver doesn't enable DPM
(even though it should) and simply returns from that function.
In the suspend case, it goes ahead and enables DPM, even though it doesn't need to.

I debugged further, and found out that in the case of suspend, for the
CIK/Hawaii GPUs, smum_is_dpm_running(hwmgr) returns false, while in the case of
hibernate, smum_is_dpm_running(hwmgr) returns true.

For CIK, the ci_is_dpm_running() function calls the ci_is_smc_ram_running() function,
which is ultimately used to determine if DPM is currently enabled or not,
and this seems to provide the wrong answer.

I've changed the ci_is_dpm_running() function to instead use the same method that
some other AMD GPU chips do (e.g Fiji), which seems to read the voltage controller.
I've tested on my R9 390 and it seems to work correctly for both suspend and
hibernate use cases, and has been stable so far.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=208839
Signed-off-by: Sandeep Raghuraman <sandy.8925@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c
+++ b/drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c
@@ -2725,7 +2725,10 @@ static int ci_initialize_mc_reg_table(st
 
 static bool ci_is_dpm_running(struct pp_hwmgr *hwmgr)
 {
-	return ci_is_smc_ram_running(hwmgr);
+	return (1 == PHM_READ_INDIRECT_FIELD(hwmgr->device,
+					     CGS_IND_REG__SMC, FEATURE_STATUS,
+					     VOLTAGE_CONTROLLER_ON))
+		? true : false;
 }
 
 static int ci_smu_init(struct pp_hwmgr *hwmgr)


