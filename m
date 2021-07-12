Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D29C3C4CCB
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238718AbhGLHIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:08:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243179AbhGLHEl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:04:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2DEC611C2;
        Mon, 12 Jul 2021 07:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073313;
        bh=F0ZOtPaLg7ZLUv7+BtbmeLGwPX6I3v75FrJSUcAv5ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AvzXfex61AbWbuRjQ8oJ/dWt1eKNQJ/oWqoTGqsZ4y6xu41PHIJDUmy1XQY0nOp6d
         FTZlcBe4AH7eIrnHhOsuZkEgNnZ0ch97A1916ZWcMYoxsKhmEb6mH+7v9vZVJXK0pu
         7usnCnucJs1xLtUqtTYAAoqxRGs0jnbDfu+AxRJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 198/700] ACPI: PM: s2idle: Add missing LPS0 functions for AMD
Date:   Mon, 12 Jul 2021 08:04:41 +0200
Message-Id: <20210712060954.856229429@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



