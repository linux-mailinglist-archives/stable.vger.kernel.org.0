Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73FD545BA20
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbhKXMHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:07:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:34004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241576AbhKXMGs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:06:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8119D61053;
        Wed, 24 Nov 2021 12:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755419;
        bh=CVN7Pg3DzWj+3ld+QJ3WMZBOUmMMCUImgyRhxWRPKT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TqQHZZm82CGlX1aYDd72Hgbu0bodhn9HL3uI+bzYwFcdLD57UU1dxCPkMKAH76OX1
         KHnrUTQoyV6rOsCkOpDMKKPEisemaX1vHGDf31kyWl6TOJQ4pOFVZ73iI2llKIrHxj
         w4304j4fcTL329CY+ha4f34sP1IBVjvZxBwII2TI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Reik Keutterling <spielkind@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 055/162] ACPICA: Avoid evaluating methods too early during system resume
Date:   Wed, 24 Nov 2021 12:55:58 +0100
Message-Id: <20211124115700.121479190@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit d3c4b6f64ad356c0d9ddbcf73fa471e6a841cc5c ]

ACPICA commit 0762982923f95eb652cf7ded27356b247c9774de

During wakeup from system-wide sleep states, acpi_get_sleep_type_data()
is called and it tries to get memory from the slab allocator in order
to evaluate a control method, but if KFENCE is enabled in the kernel,
the memory allocation attempt causes an IRQ work to be queued and a
self-IPI to be sent to the CPU running the code which requires the
memory controller to be ready, so if that happens too early in the
wakeup path, it doesn't work.

Prevent that from taking place by calling acpi_get_sleep_type_data()
for S0 upfront, when preparing to enter a given sleep state, and
saving the data obtained by it for later use during system wakeup.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=214271
Reported-by: Reik Keutterling <spielkind@gmail.com>
Tested-by: Reik Keutterling <spielkind@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/acglobal.h  |  2 ++
 drivers/acpi/acpica/hwesleep.c  |  8 ++------
 drivers/acpi/acpica/hwsleep.c   | 11 ++++-------
 drivers/acpi/acpica/hwxfsleep.c |  7 +++++++
 4 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/acpica/acglobal.h b/drivers/acpi/acpica/acglobal.h
index faa97604d878e..f178d11597c09 100644
--- a/drivers/acpi/acpica/acglobal.h
+++ b/drivers/acpi/acpica/acglobal.h
@@ -256,6 +256,8 @@ extern struct acpi_bit_register_info
 
 ACPI_GLOBAL(u8, acpi_gbl_sleep_type_a);
 ACPI_GLOBAL(u8, acpi_gbl_sleep_type_b);
+ACPI_GLOBAL(u8, acpi_gbl_sleep_type_a_s0);
+ACPI_GLOBAL(u8, acpi_gbl_sleep_type_b_s0);
 
 /*****************************************************************************
  *
diff --git a/drivers/acpi/acpica/hwesleep.c b/drivers/acpi/acpica/hwesleep.c
index e5599f6108083..e4998cc0ce283 100644
--- a/drivers/acpi/acpica/hwesleep.c
+++ b/drivers/acpi/acpica/hwesleep.c
@@ -184,17 +184,13 @@ acpi_status acpi_hw_extended_sleep(u8 sleep_state)
 
 acpi_status acpi_hw_extended_wake_prep(u8 sleep_state)
 {
-	acpi_status status;
 	u8 sleep_type_value;
 
 	ACPI_FUNCTION_TRACE(hw_extended_wake_prep);
 
-	status = acpi_get_sleep_type_data(ACPI_STATE_S0,
-					  &acpi_gbl_sleep_type_a,
-					  &acpi_gbl_sleep_type_b);
-	if (ACPI_SUCCESS(status)) {
+	if (acpi_gbl_sleep_type_a_s0 != ACPI_SLEEP_TYPE_INVALID) {
 		sleep_type_value =
-		    ((acpi_gbl_sleep_type_a << ACPI_X_SLEEP_TYPE_POSITION) &
+		    ((acpi_gbl_sleep_type_a_s0 << ACPI_X_SLEEP_TYPE_POSITION) &
 		     ACPI_X_SLEEP_TYPE_MASK);
 
 		(void)acpi_write((u64)(sleep_type_value | ACPI_X_SLEEP_ENABLE),
diff --git a/drivers/acpi/acpica/hwsleep.c b/drivers/acpi/acpica/hwsleep.c
index 7d21cae6d6028..7e44ba8c6a1ab 100644
--- a/drivers/acpi/acpica/hwsleep.c
+++ b/drivers/acpi/acpica/hwsleep.c
@@ -217,7 +217,7 @@ acpi_status acpi_hw_legacy_sleep(u8 sleep_state)
 
 acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state)
 {
-	acpi_status status;
+	acpi_status status = AE_OK;
 	struct acpi_bit_register_info *sleep_type_reg_info;
 	struct acpi_bit_register_info *sleep_enable_reg_info;
 	u32 pm1a_control;
@@ -230,10 +230,7 @@ acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state)
 	 * This is unclear from the ACPI Spec, but it is required
 	 * by some machines.
 	 */
-	status = acpi_get_sleep_type_data(ACPI_STATE_S0,
-					  &acpi_gbl_sleep_type_a,
-					  &acpi_gbl_sleep_type_b);
-	if (ACPI_SUCCESS(status)) {
+	if (acpi_gbl_sleep_type_a_s0 != ACPI_SLEEP_TYPE_INVALID) {
 		sleep_type_reg_info =
 		    acpi_hw_get_bit_register_info(ACPI_BITREG_SLEEP_TYPE);
 		sleep_enable_reg_info =
@@ -254,9 +251,9 @@ acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state)
 
 			/* Insert the SLP_TYP bits */
 
-			pm1a_control |= (acpi_gbl_sleep_type_a <<
+			pm1a_control |= (acpi_gbl_sleep_type_a_s0 <<
 					 sleep_type_reg_info->bit_position);
-			pm1b_control |= (acpi_gbl_sleep_type_b <<
+			pm1b_control |= (acpi_gbl_sleep_type_b_s0 <<
 					 sleep_type_reg_info->bit_position);
 
 			/* Write the control registers and ignore any errors */
diff --git a/drivers/acpi/acpica/hwxfsleep.c b/drivers/acpi/acpica/hwxfsleep.c
index d62a61612b3f1..b04e2b0f62246 100644
--- a/drivers/acpi/acpica/hwxfsleep.c
+++ b/drivers/acpi/acpica/hwxfsleep.c
@@ -372,6 +372,13 @@ acpi_status acpi_enter_sleep_state_prep(u8 sleep_state)
 		return_ACPI_STATUS(status);
 	}
 
+	status = acpi_get_sleep_type_data(ACPI_STATE_S0,
+					  &acpi_gbl_sleep_type_a_s0,
+					  &acpi_gbl_sleep_type_b_s0);
+	if (ACPI_FAILURE(status)) {
+		acpi_gbl_sleep_type_a_s0 = ACPI_SLEEP_TYPE_INVALID;
+	}
+
 	/* Execute the _PTS method (Prepare To Sleep) */
 
 	arg_list.count = 1;
-- 
2.33.0



