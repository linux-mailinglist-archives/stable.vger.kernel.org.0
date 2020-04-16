Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212CF1AC796
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392556AbgDPNzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:55:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392564AbgDPNzk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:55:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D64B20732;
        Thu, 16 Apr 2020 13:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045339;
        bh=EIiAOcYnfzGp7XuH9q6GsIa+EaoX1J+3C8SmVM4CoXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJ06tjzD1DqS3RKJOETGmkLk0a+x2umz6NpVqgVKW2AVFm3YAGpjYDpNG50RnHyjt
         NWaZaKGKd5BCHRKi/31SMKMDY4VWR+FBeH/u5gTTjA5u8/MZbXeoxIIkOhLLHbmtWz
         ysXwrTHgDuWd7jxJFfaO6dONm1H8R9bKeaQOCQm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ond=C5=99ej=20Caletka?= <ondrej@caletka.cz>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.6 092/254] ACPICA: Allow acpi_any_gpe_status_set() to skip one GPE
Date:   Thu, 16 Apr 2020 15:23:01 +0200
Message-Id: <20200416131337.435287642@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 0ce792d660bda990c675eaf14ce09594a9b85cbf upstream.

The check carried out by acpi_any_gpe_status_set() is not precise enough
for the suspend-to-idle implementation in Linux and in some cases it is
necessary make it skip one GPE (specifically, the EC GPE) from the check
to prevent a race condition leading to a premature system resume from
occurring.

For this reason, redefine acpi_any_gpe_status_set() to take the number
of a GPE to skip as an argument.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206629
Tested-by: Ondřej Caletka <ondrej@caletka.cz>
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpica/achware.h |    2 -
 drivers/acpi/acpica/evxfgpe.c |   17 ++++++++++-----
 drivers/acpi/acpica/hwgpe.c   |   47 +++++++++++++++++++++++++++++++++---------
 drivers/acpi/sleep.c          |    2 -
 include/acpi/acpixf.h         |    2 -
 5 files changed, 53 insertions(+), 17 deletions(-)

--- a/drivers/acpi/acpica/achware.h
+++ b/drivers/acpi/acpica/achware.h
@@ -101,7 +101,7 @@ acpi_status acpi_hw_enable_all_runtime_g
 
 acpi_status acpi_hw_enable_all_wakeup_gpes(void);
 
-u8 acpi_hw_check_all_gpes(void);
+u8 acpi_hw_check_all_gpes(acpi_handle gpe_skip_device, u32 gpe_skip_number);
 
 acpi_status
 acpi_hw_enable_runtime_gpe_block(struct acpi_gpe_xrupt_info *gpe_xrupt_info,
--- a/drivers/acpi/acpica/evxfgpe.c
+++ b/drivers/acpi/acpica/evxfgpe.c
@@ -799,17 +799,19 @@ ACPI_EXPORT_SYMBOL(acpi_enable_all_wakeu
  *
  * FUNCTION:    acpi_any_gpe_status_set
  *
- * PARAMETERS:  None
+ * PARAMETERS:  gpe_skip_number      - Number of the GPE to skip
  *
  * RETURN:      Whether or not the status bit is set for any GPE
  *
- * DESCRIPTION: Check the status bits of all enabled GPEs and return TRUE if any
- *              of them is set or FALSE otherwise.
+ * DESCRIPTION: Check the status bits of all enabled GPEs, except for the one
+ *              represented by the "skip" argument, and return TRUE if any of
+ *              them is set or FALSE otherwise.
  *
  ******************************************************************************/
-u32 acpi_any_gpe_status_set(void)
+u32 acpi_any_gpe_status_set(u32 gpe_skip_number)
 {
 	acpi_status status;
+	acpi_handle gpe_device;
 	u8 ret;
 
 	ACPI_FUNCTION_TRACE(acpi_any_gpe_status_set);
@@ -819,7 +821,12 @@ u32 acpi_any_gpe_status_set(void)
 		return (FALSE);
 	}
 
-	ret = acpi_hw_check_all_gpes();
+	status = acpi_get_gpe_device(gpe_skip_number, &gpe_device);
+	if (ACPI_FAILURE(status)) {
+		gpe_device = NULL;
+	}
+
+	ret = acpi_hw_check_all_gpes(gpe_device, gpe_skip_number);
 	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
 
 	return (ret);
--- a/drivers/acpi/acpica/hwgpe.c
+++ b/drivers/acpi/acpica/hwgpe.c
@@ -444,12 +444,19 @@ acpi_hw_enable_wakeup_gpe_block(struct a
 	return (AE_OK);
 }
 
+struct acpi_gpe_block_status_context {
+	struct acpi_gpe_register_info *gpe_skip_register_info;
+	u8 gpe_skip_mask;
+	u8 retval;
+};
+
 /******************************************************************************
  *
  * FUNCTION:    acpi_hw_get_gpe_block_status
  *
  * PARAMETERS:  gpe_xrupt_info      - GPE Interrupt info
  *              gpe_block           - Gpe Block info
+ *              context             - GPE list walk context data
  *
  * RETURN:      Success
  *
@@ -460,12 +467,13 @@ acpi_hw_enable_wakeup_gpe_block(struct a
 static acpi_status
 acpi_hw_get_gpe_block_status(struct acpi_gpe_xrupt_info *gpe_xrupt_info,
 			     struct acpi_gpe_block_info *gpe_block,
-			     void *ret_ptr)
+			     void *context)
 {
+	struct acpi_gpe_block_status_context *c = context;
 	struct acpi_gpe_register_info *gpe_register_info;
 	u64 in_enable, in_status;
 	acpi_status status;
-	u8 *ret = ret_ptr;
+	u8 ret_mask;
 	u32 i;
 
 	/* Examine each GPE Register within the block */
@@ -485,7 +493,11 @@ acpi_hw_get_gpe_block_status(struct acpi
 			continue;
 		}
 
-		*ret |= in_enable & in_status;
+		ret_mask = in_enable & in_status;
+		if (ret_mask && c->gpe_skip_register_info == gpe_register_info) {
+			ret_mask &= ~c->gpe_skip_mask;
+		}
+		c->retval |= ret_mask;
 	}
 
 	return (AE_OK);
@@ -561,24 +573,41 @@ acpi_status acpi_hw_enable_all_wakeup_gp
  *
  * FUNCTION:    acpi_hw_check_all_gpes
  *
- * PARAMETERS:  None
+ * PARAMETERS:  gpe_skip_device      - GPE devoce of the GPE to skip
+ *              gpe_skip_number      - Number of the GPE to skip
  *
  * RETURN:      Combined status of all GPEs
  *
- * DESCRIPTION: Check all enabled GPEs in all GPE blocks and return TRUE if the
+ * DESCRIPTION: Check all enabled GPEs in all GPE blocks, except for the one
+ *              represented by the "skip" arguments, and return TRUE if the
  *              status bit is set for at least one of them of FALSE otherwise.
  *
  ******************************************************************************/
 
-u8 acpi_hw_check_all_gpes(void)
+u8 acpi_hw_check_all_gpes(acpi_handle gpe_skip_device, u32 gpe_skip_number)
 {
-	u8 ret = 0;
+	struct acpi_gpe_block_status_context context = {
+		.gpe_skip_register_info = NULL,
+		.retval = 0,
+	};
+	struct acpi_gpe_event_info *gpe_event_info;
+	acpi_cpu_flags flags;
 
 	ACPI_FUNCTION_TRACE(acpi_hw_check_all_gpes);
 
-	(void)acpi_ev_walk_gpe_list(acpi_hw_get_gpe_block_status, &ret);
+	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+
+	gpe_event_info = acpi_ev_get_gpe_event_info(gpe_skip_device,
+						    gpe_skip_number);
+	if (gpe_event_info) {
+		context.gpe_skip_register_info = gpe_event_info->register_info;
+		context.gpe_skip_mask = acpi_hw_get_gpe_register_bit(gpe_event_info);
+	}
+
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 
-	return (ret != 0);
+	(void)acpi_ev_walk_gpe_list(acpi_hw_get_gpe_block_status, &context);
+	return (context.retval != 0);
 }
 
 #endif				/* !ACPI_REDUCED_HARDWARE */
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -1026,7 +1026,7 @@ static bool acpi_s2idle_wake(void)
 		 * status bit from unset to set between the checks with the
 		 * status bits of all the other GPEs unset.
 		 */
-		if (acpi_any_gpe_status_set() && !acpi_ec_dispatch_gpe())
+		if (acpi_any_gpe_status_set(U32_MAX) && !acpi_ec_dispatch_gpe())
 			return true;
 
 		/*
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -752,7 +752,7 @@ ACPI_HW_DEPENDENT_RETURN_UINT32(u32 acpi
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_disable_all_gpes(void))
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_enable_all_runtime_gpes(void))
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_enable_all_wakeup_gpes(void))
-ACPI_HW_DEPENDENT_RETURN_UINT32(u32 acpi_any_gpe_status_set(void))
+ACPI_HW_DEPENDENT_RETURN_UINT32(u32 acpi_any_gpe_status_set(u32 gpe_skip_number))
 ACPI_HW_DEPENDENT_RETURN_UINT32(u32 acpi_any_fixed_event_status_set(void))
 
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status


