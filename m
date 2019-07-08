Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 596D062410
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730122AbfGHP2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:28:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730266AbfGHP2j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:28:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F283204EC;
        Mon,  8 Jul 2019 15:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599718;
        bh=8TSg+YEiKH5AXP83bcgN+KQurxzli4KcEYlUUHeC2uA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m8UaNsl/F+bBMh1kvcdHRWobaZnhq6z/zr0AXsLFSoTr3ydFAyicfrsfNREys+kAv
         MS41X+jdC+lMFwz1tvl/WPKKyyU0lx5B9VfxmQmcToWs478msRb7iAisdmuFsEeNa6
         2IZ5y3rVlNA3PRnBGsLTgc6ye3onZIVBd+hwYvEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Slava Abramov <slava.abramov@amd.com>
Subject: [PATCH 4.19 55/90] drm/amd/powerplay: use hardware fan control if no powerplay fan table
Date:   Mon,  8 Jul 2019 17:13:22 +0200
Message-Id: <20190708150525.271037783@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

commit f78c581e22d4b33359ac3462e8d0504735df01f4 upstream.

Otherwise, you may get divided-by-zero error or corrput the SMU fan
control feature.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Tested-by: Slava Abramov <slava.abramov@amd.com>
Acked-by: Slava Abramov <slava.abramov@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/powerplay/hwmgr/process_pptables_v1_0.c |    4 +++-
 drivers/gpu/drm/amd/powerplay/inc/hwmgr.h                   |    1 +
 drivers/gpu/drm/amd/powerplay/smumgr/polaris10_smumgr.c     |    4 ++++
 3 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/powerplay/hwmgr/process_pptables_v1_0.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/process_pptables_v1_0.c
@@ -916,8 +916,10 @@ static int init_thermal_controller(
 			PHM_PlatformCaps_ThermalController
 		  );
 
-	if (0 == powerplay_table->usFanTableOffset)
+	if (0 == powerplay_table->usFanTableOffset) {
+		hwmgr->thermal_controller.use_hw_fan_control = 1;
 		return 0;
+	}
 
 	fan_table = (const PPTable_Generic_SubTable_Header *)
 		(((unsigned long)powerplay_table) +
--- a/drivers/gpu/drm/amd/powerplay/inc/hwmgr.h
+++ b/drivers/gpu/drm/amd/powerplay/inc/hwmgr.h
@@ -677,6 +677,7 @@ struct pp_thermal_controller_info {
 	uint8_t ucType;
 	uint8_t ucI2cLine;
 	uint8_t ucI2cAddress;
+	uint8_t use_hw_fan_control;
 	struct pp_fan_info fanInfo;
 	struct pp_advance_fan_control_parameters advanceFanControlParameters;
 };
--- a/drivers/gpu/drm/amd/powerplay/smumgr/polaris10_smumgr.c
+++ b/drivers/gpu/drm/amd/powerplay/smumgr/polaris10_smumgr.c
@@ -2038,6 +2038,10 @@ static int polaris10_thermal_setup_fan_t
 		return 0;
 	}
 
+	/* use hardware fan control */
+	if (hwmgr->thermal_controller.use_hw_fan_control)
+		return 0;
+
 	tmp64 = hwmgr->thermal_controller.advanceFanControlParameters.
 			usPWMMin * duty100;
 	do_div(tmp64, 10000);


