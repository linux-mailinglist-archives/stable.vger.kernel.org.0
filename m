Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC6F85F8EC5
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 23:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbiJIVG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 17:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbiJIVGh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 17:06:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF25E2F3A3;
        Sun,  9 Oct 2022 14:01:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A9E4B80DC8;
        Sun,  9 Oct 2022 20:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBDCC433D6;
        Sun,  9 Oct 2022 20:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665348886;
        bh=XHcyysHE7tX7QDs1ULU7fgwf6UOTOZ2Xr0MsncCmixE=;
        h=From:To:Cc:Subject:Date:From;
        b=se379FaZ8DzPUGlLzEnXc3lV0TGvuIvZ80M+zrZ5SVN1oP6cBgAco+iy+7FCvrE50
         L25nO4gWHdMr8fiGB5qAYD/BtyyrEqQUGA98wOMGaWWMVEcyOW4oycKHEV7jY7HFkX
         GSnqUHL2tGl/snxEnqLl6IegP/VUvHs1/EgkNc4D2HPIk5tIS8QB3AhopQlziIw5me
         sM7uRJrk2shNE2iBdc3kpggjK17f7BB3zrYUCMbFTURiC0ZOhkNnH7C9TWGNKa5Ory
         h2yVO7zIhoR/3OqFVX3UIEtVNZFIStEGzo2n+XFb0U7UEfzlTZiaVNHfgKWgt+0p6P
         ScnNpDAJhFC6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arvid Norlander <lkml@vorpal.se>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 1/6] ACPI: video: Add Toshiba Satellite/Portege Z830 quirk
Date:   Sun,  9 Oct 2022 16:54:37 -0400
Message-Id: <20221009205443.1203725-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
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

From: Arvid Norlander <lkml@vorpal.se>

[ Upstream commit 574160b8548deff8b80b174f03201e94ab8431e2 ]

Toshiba Satellite Z830 needs the quirk video_disable_backlight_sysfs_if
for proper backlight control after suspend/resume cycles.

Toshiba Portege Z830 is simply the same laptop rebranded for certain
markets (I looked through the manual to other language sections to confirm
this) and thus also needs this quirk.

Thanks to Hans de Goede for suggesting this fix.

Link: https://www.spinics.net/lists/platform-driver-x86/msg34394.html
Suggested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Arvid Norlander <lkml@vorpal.se>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Arvid Norlander <lkml@vorpal.se>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_video.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
index ac54fc03cf81..eb7fca6f9444 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -511,6 +511,22 @@ static const struct dmi_system_id video_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "SATELLITE R830"),
 		},
 	},
+	{
+	 .callback = video_disable_backlight_sysfs_if,
+	 .ident = "Toshiba Satellite Z830",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "SATELLITE Z830"),
+		},
+	},
+	{
+	 .callback = video_disable_backlight_sysfs_if,
+	 .ident = "Toshiba Portege Z830",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "PORTEGE Z830"),
+		},
+	},
 	/*
 	 * Some machine's _DOD IDs don't have bit 31(Device ID Scheme) set
 	 * but the IDs actually follow the Device ID Scheme.
-- 
2.35.1

