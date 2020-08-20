Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A0624BAEF
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbgHTMUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:20:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729924AbgHTJzq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:55:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0895D2067C;
        Thu, 20 Aug 2020 09:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917345;
        bh=HAPb4srVV8co5wIjXy1C6+XY4jLcuHnudIAZvr0Xsrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pFYqhWfgdXMz4/ZuixwQxcr0bPDYVkS7k9IcuqLlXXfSXV3MyNb/H8ViAJ26AQPsb
         Ohc3BHESfnzkbYm8jo1xelEL6R32H9i7zY6NITIUzo8BXH7Ldq8/jI89DNQLRczyBY
         NNMVSEThFxCLD+1082nnxTHenjCKHhXMH3NHnI3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sandeep Raghuraman <sandy.8925@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.19 92/92] drm/amdgpu: Fix bug where DPM is not enabled after hibernate and resume
Date:   Thu, 20 Aug 2020 11:22:17 +0200
Message-Id: <20200820091542.424191325@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
References: <20200820091537.490965042@linuxfoundation.org>
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
@@ -2723,7 +2723,10 @@ static int ci_initialize_mc_reg_table(st
 
 static bool ci_is_dpm_running(struct pp_hwmgr *hwmgr)
 {
-	return ci_is_smc_ram_running(hwmgr);
+	return (1 == PHM_READ_INDIRECT_FIELD(hwmgr->device,
+					     CGS_IND_REG__SMC, FEATURE_STATUS,
+					     VOLTAGE_CONTROLLER_ON))
+		? true : false;
 }
 
 static int ci_smu_init(struct pp_hwmgr *hwmgr)


