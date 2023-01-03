Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A85D565C66E
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 19:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238413AbjACSkE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 13:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238073AbjACSj7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 13:39:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D620013DE8;
        Tue,  3 Jan 2023 10:39:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FD40B80EBF;
        Tue,  3 Jan 2023 18:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694E8C433D2;
        Tue,  3 Jan 2023 18:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672771188;
        bh=1sB5EN2qD8GrQKjdJZrnAalkGApHEBaqO3LLSQoUEKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IsJSq2HFa5H6ZfeLCecWgA8G5yupVMD38GACWcFBMLrCV7+HlNpv0ukGJClydJ3LQ
         YZOtKapLat11oSzVpyDY+25jLQyuvu4jtjt/xga+7yk6X/DLPDeV8Jvtirwbp4bPia
         QD/mRrwwVIPIhhaLTlXWqHa5QIlE43HV+GzQkpWyxre6xzYGscZIc6htaehsBde6Dt
         59pf4o5vIrS6VbR6OVwq8gXsGFn6yGQbauQLnNZ4ukIwrR8sCm+eVE3JRsu6NDOlFV
         5nyjTiPykGvC31TKz0wD5dLRrRaYGJADWLgGvzonC/Nhe12arphZcnZJFSOFIj6HMH
         VlWB5veT6x6vA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        alexander.deucher@amd.com, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        roman.li@amd.com, aurabindo.pillai@amd.com, mdaenzer@redhat.com,
        Jerry.Zuo@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 04/10] drm/amd/display: Report to ACPI video if no panels were found
Date:   Tue,  3 Jan 2023 13:39:28 -0500
Message-Id: <20230103183934.2022663-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230103183934.2022663-1-sashal@kernel.org>
References: <20230103183934.2022663-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit c573e240609ff781a0246c0c8c8351abd0475287 ]

On desktop APUs amdgpu doesn't create a native backlight device
as no eDP panels are found.  However if the BIOS has reported
backlight control methods in the ACPI tables then an acpi_video0
backlight device will be made 8 seconds after boot.

This has manifested in a power slider on a number of desktop APUs
ranging from Ryzen 5000 through Ryzen 7000 on various motherboard
manufacturers. To avoid this, report to the acpi video detection
that the system does not have any panel connected in the native
driver.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=1783786
Reported-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 512c32327eb1..b73f61ac5dd5 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4371,6 +4371,10 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 		amdgpu_set_panel_orientation(&aconnector->base);
 	}
 
+	/* If we didn't find a panel, notify the acpi video detection */
+	if (dm->adev->flags & AMD_IS_APU && dm->num_of_edps == 0)
+		acpi_video_report_nolcd();
+
 	/* Software is initialized. Now we can register interrupt handlers. */
 	switch (adev->asic_type) {
 #if defined(CONFIG_DRM_AMD_DC_SI)
-- 
2.35.1

