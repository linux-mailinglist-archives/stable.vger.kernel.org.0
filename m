Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3AD8499C7E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1579467AbiAXWFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:05:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1575682AbiAXV7I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:59:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C2BC02B8CE;
        Mon, 24 Jan 2022 12:39:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4420D61536;
        Mon, 24 Jan 2022 20:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E72C340E7;
        Mon, 24 Jan 2022 20:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056763;
        bh=6YAm3CPq34GvsX3b4vYCVruJOM6/PYsnnpJpjUe6TT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bW55PtcHBOCXXGdV2vmMT6kcWjIWWxezfaPBU+HCO17HAUfmZN+le4Y2X7EoT7SPl
         Zk9pUxBvM514xIDCwzXT87WYVz0KmuNzFf0EpW40jp4awLZyjzo2hjUK1fd81eQ+KS
         4C/Vl3oDLVP9Jmxs2o+47NLPEGDd6mHHkJ0jfb3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bob Moore <robert.moore@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 593/846] ACPICA: Hardware: Do not flush CPU cache when entering S4 and S5
Date:   Mon, 24 Jan 2022 19:41:50 +0100
Message-Id: <20220124184121.495001279@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

[ Upstream commit 1d4e0b3abb168b2ee1eca99c527cffa1b80b6161 ]

ACPICA commit 3dd7e1f3996456ef81bfe14cba29860e8d42949e

According to ACPI 6.4, Section 16.2, the CPU cache flushing is
required on entering to S1, S2, and S3, but the ACPICA code
flushes the CPU cache regardless of the sleep state.

Blind cache flush on entering S5 causes problems for TDX.

Flushing happens with WBINVD that is not supported in the TDX
environment.

TDX only supports S5 and adjusting ACPICA code to conform to the
spec more strictly fixes the issue.

Link: https://github.com/acpica/acpica/commit/3dd7e1f3
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/hwesleep.c  | 4 +++-
 drivers/acpi/acpica/hwsleep.c   | 4 +++-
 drivers/acpi/acpica/hwxfsleep.c | 2 --
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/acpica/hwesleep.c b/drivers/acpi/acpica/hwesleep.c
index 808fdf54aeebf..7ee2939c08cd4 100644
--- a/drivers/acpi/acpica/hwesleep.c
+++ b/drivers/acpi/acpica/hwesleep.c
@@ -104,7 +104,9 @@ acpi_status acpi_hw_extended_sleep(u8 sleep_state)
 
 	/* Flush caches, as per ACPI specification */
 
-	ACPI_FLUSH_CPU_CACHE();
+	if (sleep_state < ACPI_STATE_S4) {
+		ACPI_FLUSH_CPU_CACHE();
+	}
 
 	status = acpi_os_enter_sleep(sleep_state, sleep_control, 0);
 	if (status == AE_CTRL_TERMINATE) {
diff --git a/drivers/acpi/acpica/hwsleep.c b/drivers/acpi/acpica/hwsleep.c
index 34a3825f25d37..5efa3d8e483e0 100644
--- a/drivers/acpi/acpica/hwsleep.c
+++ b/drivers/acpi/acpica/hwsleep.c
@@ -110,7 +110,9 @@ acpi_status acpi_hw_legacy_sleep(u8 sleep_state)
 
 	/* Flush caches, as per ACPI specification */
 
-	ACPI_FLUSH_CPU_CACHE();
+	if (sleep_state < ACPI_STATE_S4) {
+		ACPI_FLUSH_CPU_CACHE();
+	}
 
 	status = acpi_os_enter_sleep(sleep_state, pm1a_control, pm1b_control);
 	if (status == AE_CTRL_TERMINATE) {
diff --git a/drivers/acpi/acpica/hwxfsleep.c b/drivers/acpi/acpica/hwxfsleep.c
index e4cde23a29061..ba77598ee43e8 100644
--- a/drivers/acpi/acpica/hwxfsleep.c
+++ b/drivers/acpi/acpica/hwxfsleep.c
@@ -162,8 +162,6 @@ acpi_status acpi_enter_sleep_state_s4bios(void)
 		return_ACPI_STATUS(status);
 	}
 
-	ACPI_FLUSH_CPU_CACHE();
-
 	status = acpi_hw_write_port(acpi_gbl_FADT.smi_command,
 				    (u32)acpi_gbl_FADT.s4_bios_request, 8);
 	if (ACPI_FAILURE(status)) {
-- 
2.34.1



