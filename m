Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E399D44A2C1
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241886AbhKIBVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:21:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:44340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241740AbhKIBTD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:19:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD3396120A;
        Tue,  9 Nov 2021 01:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420043;
        bh=mHxc0Kuj0RntDLoKqNwYluizF+kIV9w/hMVir4/2bBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dk90bw71FO5i5O+z4M6j2GpHzYxkC1a6EZCjVfaxg0dQaO5nviSpupFYQmGADhxCZ
         aGwc9FLp2fXc/+BkBvdk0d8jWNNRnoqEOrqAShMXyzIZWbcn22A4Lp11UzTtXivC8E
         lAUpAQ/Nnz7OTNqnQwm2IEOYN6UowikfAW973a7hNIxZSQo20X7ZWYj/6B7rKJf3he
         3lXNnaJAnTpmjv0xV2WAyYBu5w3A3txbYclOj+qPoRmNkfLiDlfuBpMrgPD24me8+P
         Wrq+uVXYgFNF+joHmnc6YIauz58gqryG2+MmOJUE/ZvBqBQd0Xmj+cb5fHZ5Yc2pet
         3LtSXGsECWIew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Reik Keutterling <spielkind@gmail.com>,
        Sasha Levin <sashal@kernel.org>, robert.moore@intel.com,
        linux-acpi@vger.kernel.org, devel@acpica.org
Subject: [PATCH AUTOSEL 4.14 19/39] ACPICA: Avoid evaluating methods too early during system resume
Date:   Mon,  8 Nov 2021 20:06:29 -0500
Message-Id: <20211109010649.1191041-19-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010649.1191041-1-sashal@kernel.org>
References: <20211109010649.1191041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

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
index 95eed442703f2..2f4a3fee69e70 100644
--- a/drivers/acpi/acpica/acglobal.h
+++ b/drivers/acpi/acpica/acglobal.h
@@ -255,6 +255,8 @@ extern struct acpi_bit_register_info
 
 ACPI_GLOBAL(u8, acpi_gbl_sleep_type_a);
 ACPI_GLOBAL(u8, acpi_gbl_sleep_type_b);
+ACPI_GLOBAL(u8, acpi_gbl_sleep_type_a_s0);
+ACPI_GLOBAL(u8, acpi_gbl_sleep_type_b_s0);
 
 /*****************************************************************************
  *
diff --git a/drivers/acpi/acpica/hwesleep.c b/drivers/acpi/acpica/hwesleep.c
index 12626d021a9b5..7f8c57177819f 100644
--- a/drivers/acpi/acpica/hwesleep.c
+++ b/drivers/acpi/acpica/hwesleep.c
@@ -181,17 +181,13 @@ acpi_status acpi_hw_extended_sleep(u8 sleep_state)
 
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
index 1fe7387a00e67..2c54d08b20ca6 100644
--- a/drivers/acpi/acpica/hwsleep.c
+++ b/drivers/acpi/acpica/hwsleep.c
@@ -218,7 +218,7 @@ acpi_status acpi_hw_legacy_sleep(u8 sleep_state)
 
 acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state)
 {
-	acpi_status status;
+	acpi_status status = AE_OK;
 	struct acpi_bit_register_info *sleep_type_reg_info;
 	struct acpi_bit_register_info *sleep_enable_reg_info;
 	u32 pm1a_control;
@@ -231,10 +231,7 @@ acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state)
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
@@ -255,9 +252,9 @@ acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state)
 
 			/* Insert the SLP_TYP bits */
 
-			pm1a_control |= (acpi_gbl_sleep_type_a <<
+			pm1a_control |= (acpi_gbl_sleep_type_a_s0 <<
 					 sleep_type_reg_info->bit_position);
-			pm1b_control |= (acpi_gbl_sleep_type_b <<
+			pm1b_control |= (acpi_gbl_sleep_type_b_s0 <<
 					 sleep_type_reg_info->bit_position);
 
 			/* Write the control registers and ignore any errors */
diff --git a/drivers/acpi/acpica/hwxfsleep.c b/drivers/acpi/acpica/hwxfsleep.c
index e5c095ca6083a..827c3242225d9 100644
--- a/drivers/acpi/acpica/hwxfsleep.c
+++ b/drivers/acpi/acpica/hwxfsleep.c
@@ -322,6 +322,13 @@ acpi_status acpi_enter_sleep_state_prep(u8 sleep_state)
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

