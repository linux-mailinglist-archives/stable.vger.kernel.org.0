Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 737FD157711
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgBJM5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:57:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:43710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728447AbgBJMla (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:30 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8065520873;
        Mon, 10 Feb 2020 12:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338489;
        bh=TTfjELHkrQvxjGJE+euxDLDW+9s1L+edJ4D0jtineI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u9TJ8ys4ZdSoQb9R+Ju8deKr6W8mc/8EPnQQO8fsRmLw3TANCj2A2kQLKJBwtv0Es
         cra7GyeAYf9DHenNxOb/UBlMVui1KldN4OVGuSs8t7AMuW703PKIzAABl0rw25qyAu
         W1X2kYHFlCQR8pQ139Wb/XwpttW0Pn4b5EV7bsDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Coffin <mcoffin13@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.5 273/367] drm/amdgpu/smu_v11_0: Correct behavior of restoring default tables (v2)
Date:   Mon, 10 Feb 2020 04:33:06 -0800
Message-Id: <20200210122449.443658345@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Coffin <mcoffin13@gmail.com>

commit 93c5f1f66c6ad4a3b180c1644f74e1b3b4be7864 upstream.

Previously, the syfs functionality for restoring the default powerplay
table was sourcing it's information from the currently-staged powerplay
table.

This patch adds a step to cache the first overdrive table that we see on
boot, so that it can be used later to "restore" the powerplay table

v2: sqaush my original with Matt's fix

Bug: https://gitlab.freedesktop.org/drm/amd/issues/1020
Signed-off-by: Matt Coffin <mcoffin13@gmail.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.5.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/powerplay/inc/amdgpu_smu.h |    1 
 drivers/gpu/drm/amd/powerplay/navi10_ppt.c     |    7 ++++++
 drivers/gpu/drm/amd/powerplay/smu_v11_0.c      |    6 +++++
 drivers/gpu/drm/amd/powerplay/vega20_ppt.c     |   28 +++++++------------------
 4 files changed, 22 insertions(+), 20 deletions(-)

--- a/drivers/gpu/drm/amd/powerplay/inc/amdgpu_smu.h
+++ b/drivers/gpu/drm/amd/powerplay/inc/amdgpu_smu.h
@@ -263,6 +263,7 @@ struct smu_table_context
 	uint8_t                         thermal_controller_type;
 
 	void				*overdrive_table;
+	void                            *boot_overdrive_table;
 };
 
 struct smu_dpm_context {
--- a/drivers/gpu/drm/amd/powerplay/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/powerplay/navi10_ppt.c
@@ -2020,6 +2020,13 @@ static int navi10_od_edit_dpm_table(stru
 			return ret;
 		od_table->UclkFmax = input[1];
 		break;
+	case PP_OD_RESTORE_DEFAULT_TABLE:
+		if (!(table_context->overdrive_table && table_context->boot_overdrive_table)) {
+			pr_err("Overdrive table was not initialized!\n");
+			return -EINVAL;
+		}
+		memcpy(table_context->overdrive_table, table_context->boot_overdrive_table, sizeof(OverDriveTable_t));
+		break;
 	case PP_OD_COMMIT_DPM_TABLE:
 		navi10_dump_od_table(od_table);
 		ret = smu_update_table(smu, SMU_TABLE_OVERDRIVE, 0, (void *)od_table, true);
--- a/drivers/gpu/drm/amd/powerplay/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/powerplay/smu_v11_0.c
@@ -1807,6 +1807,12 @@ int smu_v11_0_set_default_od_settings(st
 			pr_err("Failed to export overdrive table!\n");
 			return ret;
 		}
+		if (!table_context->boot_overdrive_table) {
+			table_context->boot_overdrive_table = kmemdup(table_context->overdrive_table, overdrive_table_size, GFP_KERNEL);
+			if (!table_context->boot_overdrive_table) {
+				return -ENOMEM;
+			}
+		}
 	}
 	ret = smu_update_table(smu, SMU_TABLE_OVERDRIVE, 0, table_context->overdrive_table, true);
 	if (ret) {
--- a/drivers/gpu/drm/amd/powerplay/vega20_ppt.c
+++ b/drivers/gpu/drm/amd/powerplay/vega20_ppt.c
@@ -1702,22 +1702,11 @@ static int vega20_set_default_od_setting
 	struct smu_table_context *table_context = &smu->smu_table;
 	int ret;
 
-	if (initialize) {
-		if (table_context->overdrive_table)
-			return -EINVAL;
-
-		table_context->overdrive_table = kzalloc(sizeof(OverDriveTable_t), GFP_KERNEL);
-
-		if (!table_context->overdrive_table)
-			return -ENOMEM;
-
-		ret = smu_update_table(smu, SMU_TABLE_OVERDRIVE, 0,
-				       table_context->overdrive_table, false);
-		if (ret) {
-			pr_err("Failed to export over drive table!\n");
-			return ret;
-		}
+	ret = smu_v11_0_set_default_od_settings(smu, initialize, sizeof(OverDriveTable_t));
+	if (ret)
+		return ret;
 
+	if (initialize) {
 		ret = vega20_set_default_od8_setttings(smu);
 		if (ret)
 			return ret;
@@ -2774,12 +2763,11 @@ static int vega20_odn_edit_dpm_table(str
 		break;
 
 	case PP_OD_RESTORE_DEFAULT_TABLE:
-		ret = smu_update_table(smu, SMU_TABLE_OVERDRIVE, 0, table_context->overdrive_table, false);
-		if (ret) {
-			pr_err("Failed to export over drive table!\n");
-			return ret;
+		if (!(table_context->overdrive_table && table_context->boot_overdrive_table)) {
+			pr_err("Overdrive table was not initialized!\n");
+			return -EINVAL;
 		}
-
+		memcpy(table_context->overdrive_table, table_context->boot_overdrive_table, sizeof(OverDriveTable_t));
 		break;
 
 	case PP_OD_COMMIT_DPM_TABLE:


