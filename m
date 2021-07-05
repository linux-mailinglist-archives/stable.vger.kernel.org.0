Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3043BBEE5
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbhGEPa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:30:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231535AbhGEPa5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:30:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C9B961964;
        Mon,  5 Jul 2021 15:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498900;
        bh=F0ZOtPaLg7ZLUv7+BtbmeLGwPX6I3v75FrJSUcAv5ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=huDSiHpvFROUq0ysbML0Utq8M2LqzJBGTPhw+SlqypbwJfW1Xp+IL39XiHaEzRdok
         z+7UUKcBr/lWp6+lYhqgJ28UcBB7l7bXv/6bMjoBXrOb2LF+wXSSMhdpi2BTInkuYU
         KgDNiUEijF3jQqsjDkf7lgDDisF0WqDUNZ1DgAXkjo8zNGJHRkyGgfWSvoTKSUjCGV
         2YZc7KhFktAE3HECD+9yUPZqgY7qf7rEB4x0Atkfu6PaaKBHmwPBlHNpSdUWGztH/c
         JdLC3v1fayXQSQZrREK+sPNb4WTCROpMu/FVMD5q2CkdvUsnJbYYGsx3jUgvru8+cl
         zpuulgFGrEwig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 03/59] ACPI: PM: s2idle: Add missing LPS0 functions for AMD
Date:   Mon,  5 Jul 2021 11:27:19 -0400
Message-Id: <20210705152815.1520546-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705152815.1520546-1-sashal@kernel.org>
References: <20210705152815.1520546-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit f59a905b962c34642e862b5edec35c0eda72d70d ]

These are supposedly not required for AMD platforms,
but at least some HP laptops seem to require it to
properly turn off the keyboard backlight.

Based on a patch from Marcin Bachry <hegel666@gmail.com>.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1230
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/s2idle.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/x86/s2idle.c b/drivers/acpi/x86/s2idle.c
index 2b69536cdccb..2d7ddb8a8cb6 100644
--- a/drivers/acpi/x86/s2idle.c
+++ b/drivers/acpi/x86/s2idle.c
@@ -42,6 +42,8 @@ static const struct acpi_device_id lps0_device_ids[] = {
 
 /* AMD */
 #define ACPI_LPS0_DSM_UUID_AMD      "e3f32452-febc-43ce-9039-932122d37721"
+#define ACPI_LPS0_ENTRY_AMD         2
+#define ACPI_LPS0_EXIT_AMD          3
 #define ACPI_LPS0_SCREEN_OFF_AMD    4
 #define ACPI_LPS0_SCREEN_ON_AMD     5
 
@@ -408,6 +410,7 @@ int acpi_s2idle_prepare_late(void)
 
 	if (acpi_s2idle_vendor_amd()) {
 		acpi_sleep_run_lps0_dsm(ACPI_LPS0_SCREEN_OFF_AMD);
+		acpi_sleep_run_lps0_dsm(ACPI_LPS0_ENTRY_AMD);
 	} else {
 		acpi_sleep_run_lps0_dsm(ACPI_LPS0_SCREEN_OFF);
 		acpi_sleep_run_lps0_dsm(ACPI_LPS0_ENTRY);
@@ -422,6 +425,7 @@ void acpi_s2idle_restore_early(void)
 		return;
 
 	if (acpi_s2idle_vendor_amd()) {
+		acpi_sleep_run_lps0_dsm(ACPI_LPS0_EXIT_AMD);
 		acpi_sleep_run_lps0_dsm(ACPI_LPS0_SCREEN_ON_AMD);
 	} else {
 		acpi_sleep_run_lps0_dsm(ACPI_LPS0_EXIT);
-- 
2.30.2

