Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63798664977
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239260AbjAJSVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239262AbjAJSV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:21:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB17E4914F
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:19:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69CE6B81901
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:19:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11C2C433D2;
        Tue, 10 Jan 2023 18:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374746;
        bh=UlT9AyQJrOphxL9D4sOxgWO6v1t53v9ZwcsYV1P4vc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tfrkCOcotPXy1De1kSkUa0TED2mZzCrABQTW6IP3cW/9BaH2eLLQgNxYlgoYc5w6E
         AfXqc8V7QHj/mStZ3OKxBJjOHIM/8FayMYA1ya52Zv9hTDI2ry7RER4x0aFB71aZ1L
         XhM69w2TeRDO7dLgp5i+OpDdmfjE4BzJGn2oetYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/159] drm/amd/display: Report to ACPI video if no panels were found
Date:   Tue, 10 Jan 2023 19:04:27 +0100
Message-Id: <20230110180022.098786948@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c2c26fbea512..6f1cc5ce4c7a 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4372,6 +4372,10 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
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



