Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A10450D60
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239320AbhKOR4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:56:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:40782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239153AbhKORyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:54:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4804E632BD;
        Mon, 15 Nov 2021 17:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997595;
        bh=ZZ8x2XZC0tg2Sx2zJtYUZu4bgy6Z9QEYp3T+x/yTBNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=urshJhPrc+mEVZz2dpQEXBcVetOiDzsZd4tpRu8+VQCDoUZeUt1Xc+Axuir1xJ5G3
         isdpe4OqvU/wbVQHclYszB7+ZTQJy3AGiLiyW1TD2R3kHodxHEL2Lje3grxJpGuR7n
         o9nMnPW57LC85fKeJzzY0GrOUwv6rB1JCLQuox/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Reik Keutterling <spielkind@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 205/575] ACPICA: Avoid evaluating methods too early during system resume
Date:   Mon, 15 Nov 2021 17:58:50 +0100
Message-Id: <20211115165350.802507407@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 2fee91f57b213..bd84d7f95e5f9 100644
--- a/drivers/acpi/acpica/acglobal.h
+++ b/drivers/acpi/acpica/acglobal.h
@@ -226,6 +226,8 @@ extern struct acpi_bit_register_info
     acpi_gbl_bit_register_info[ACPI_NUM_BITREG];
 ACPI_GLOBAL(u8, acpi_gbl_sleep_type_a);
 ACPI_GLOBAL(u8, acpi_gbl_sleep_type_b);
+ACPI_GLOBAL(u8, acpi_gbl_sleep_type_a_s0);
+ACPI_GLOBAL(u8, acpi_gbl_sleep_type_b_s0);
 
 /*****************************************************************************
  *
diff --git a/drivers/acpi/acpica/hwesleep.c b/drivers/acpi/acpica/hwesleep.c
index d9be5d0545d4c..4836a4b8b38b8 100644
--- a/drivers/acpi/acpica/hwesleep.c
+++ b/drivers/acpi/acpica/hwesleep.c
@@ -147,17 +147,13 @@ acpi_status acpi_hw_extended_sleep(u8 sleep_state)
 
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
index 317ae870336b7..fcc84d196238a 100644
--- a/drivers/acpi/acpica/hwsleep.c
+++ b/drivers/acpi/acpica/hwsleep.c
@@ -179,7 +179,7 @@ acpi_status acpi_hw_legacy_sleep(u8 sleep_state)
 
 acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state)
 {
-	acpi_status status;
+	acpi_status status = AE_OK;
 	struct acpi_bit_register_info *sleep_type_reg_info;
 	struct acpi_bit_register_info *sleep_enable_reg_info;
 	u32 pm1a_control;
@@ -192,10 +192,7 @@ acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state)
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
@@ -216,9 +213,9 @@ acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state)
 
 			/* Insert the SLP_TYP bits */
 
-			pm1a_control |= (acpi_gbl_sleep_type_a <<
+			pm1a_control |= (acpi_gbl_sleep_type_a_s0 <<
 					 sleep_type_reg_info->bit_position);
-			pm1b_control |= (acpi_gbl_sleep_type_b <<
+			pm1b_control |= (acpi_gbl_sleep_type_b_s0 <<
 					 sleep_type_reg_info->bit_position);
 
 			/* Write the control registers and ignore any errors */
diff --git a/drivers/acpi/acpica/hwxfsleep.c b/drivers/acpi/acpica/hwxfsleep.c
index a4b66f4b27141..f1645d87864c3 100644
--- a/drivers/acpi/acpica/hwxfsleep.c
+++ b/drivers/acpi/acpica/hwxfsleep.c
@@ -217,6 +217,13 @@ acpi_status acpi_enter_sleep_state_prep(u8 sleep_state)
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



