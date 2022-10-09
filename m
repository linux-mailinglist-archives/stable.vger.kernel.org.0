Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB8C5F8E83
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 22:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiJIU7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 16:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbiJIU5t (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 16:57:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DB32E68E;
        Sun,  9 Oct 2022 13:54:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7DC8B80DC2;
        Sun,  9 Oct 2022 20:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F9DC433D6;
        Sun,  9 Oct 2022 20:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665348836;
        bh=/hfU9Hs/EoqRC2bMqwxFdnQrXTEESji2BHKsq/LzPyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Anzz/tYnpUrFGqbXv0957OJemUe7G4aS4F7WGJw+Sdgyasvsh2dWWRnE/26n47U3a
         N+sHjp1ou9L9SZEP3dR+WyC43fAkL0+RmIiEcUBVwrOTLNSjK5Q9oi13jJRSNax+MP
         7S8el2lyYpYLMa4B+QkAJbQXfqPtF5dydACxo2orBIuVtLFBjZgjDPZw80QRt/qsDL
         gTs7MJlcgmhS7RCx1DDRS1+oZM2VYYymXSQxVafzGaJGNCM8OtnuLdU5szbiZ8mS/E
         mgvuXGopbABEd91byiOXhd3tqc33RbFvRZpe1WUZiQkQqfIFLi50vYrypCM2xR2c22
         7VLMzELVqkR9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arvid Norlander <lkml@vorpal.se>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 03/10] ACPI: video: Add Toshiba Satellite/Portege Z830 quirk
Date:   Sun,  9 Oct 2022 16:53:42 -0400
Message-Id: <20221009205350.1203176-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009205350.1203176-1-sashal@kernel.org>
References: <20221009205350.1203176-1-sashal@kernel.org>
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
index eb04b2f828ee..cf6c9ffe04a2 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -498,6 +498,22 @@ static const struct dmi_system_id video_dmi_table[] = {
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

