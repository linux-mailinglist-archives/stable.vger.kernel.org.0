Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F18C16315C
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgBRT7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 14:59:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:38668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726680AbgBRT7r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 14:59:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81D3A2464E;
        Tue, 18 Feb 2020 19:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582055987;
        bh=+Hqck7iMxhv+AYtxEiIKQUM4VhzIE+JRj/EC+OoUySc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FjN6+XsvQu5wQ4UodbjT/ie9Kdv4nFnEv/p3EOZyRXCQs4C5zCYdJnQwK9NaUF600
         2oQ3bDPdMemo1xfBEdHYqWgbhroq5mzbwUAyNyULljcKujbAD92ndFqAW7+WYO7y4L
         nlPQX+dP8rALSgi5e5TMS3qWPs6AJ8hJozchpekM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 10/66] ACPICA: Introduce acpi_any_gpe_status_set()
Date:   Tue, 18 Feb 2020 20:54:37 +0100
Message-Id: <20200218190429.046627339@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
References: <20200218190428.035153861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit ea128834dd76f9a72a35d011c651fa96658f06a7 upstream.

Introduce a new helper function, acpi_any_gpe_status_set(), for
checking the status bits of all enabled GPEs in one go.

It is needed to distinguish spurious SCIs from genuine ones when
deciding whether or not to wake up the system from suspend-to-idle.

Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpica/achware.h |    2 +
 drivers/acpi/acpica/evxfgpe.c |   32 ++++++++++++++++++
 drivers/acpi/acpica/hwgpe.c   |   71 ++++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpixf.h         |    1 
 4 files changed, 106 insertions(+)

--- a/drivers/acpi/acpica/achware.h
+++ b/drivers/acpi/acpica/achware.h
@@ -101,6 +101,8 @@ acpi_status acpi_hw_enable_all_runtime_g
 
 acpi_status acpi_hw_enable_all_wakeup_gpes(void);
 
+u8 acpi_hw_check_all_gpes(void);
+
 acpi_status
 acpi_hw_enable_runtime_gpe_block(struct acpi_gpe_xrupt_info *gpe_xrupt_info,
 				 struct acpi_gpe_block_info *gpe_block,
--- a/drivers/acpi/acpica/evxfgpe.c
+++ b/drivers/acpi/acpica/evxfgpe.c
@@ -795,6 +795,38 @@ acpi_status acpi_enable_all_wakeup_gpes(
 
 ACPI_EXPORT_SYMBOL(acpi_enable_all_wakeup_gpes)
 
+/******************************************************************************
+ *
+ * FUNCTION:    acpi_any_gpe_status_set
+ *
+ * PARAMETERS:  None
+ *
+ * RETURN:      Whether or not the status bit is set for any GPE
+ *
+ * DESCRIPTION: Check the status bits of all enabled GPEs and return TRUE if any
+ *              of them is set or FALSE otherwise.
+ *
+ ******************************************************************************/
+u32 acpi_any_gpe_status_set(void)
+{
+	acpi_status status;
+	u8 ret;
+
+	ACPI_FUNCTION_TRACE(acpi_any_gpe_status_set);
+
+	status = acpi_ut_acquire_mutex(ACPI_MTX_EVENTS);
+	if (ACPI_FAILURE(status)) {
+		return (FALSE);
+	}
+
+	ret = acpi_hw_check_all_gpes();
+	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
+
+	return (ret);
+}
+
+ACPI_EXPORT_SYMBOL(acpi_any_gpe_status_set)
+
 /*******************************************************************************
  *
  * FUNCTION:    acpi_install_gpe_block
--- a/drivers/acpi/acpica/hwgpe.c
+++ b/drivers/acpi/acpica/hwgpe.c
@@ -446,6 +446,53 @@ acpi_hw_enable_wakeup_gpe_block(struct a
 
 /******************************************************************************
  *
+ * FUNCTION:    acpi_hw_get_gpe_block_status
+ *
+ * PARAMETERS:  gpe_xrupt_info      - GPE Interrupt info
+ *              gpe_block           - Gpe Block info
+ *
+ * RETURN:      Success
+ *
+ * DESCRIPTION: Produce a combined GPE status bits mask for the given block.
+ *
+ ******************************************************************************/
+
+static acpi_status
+acpi_hw_get_gpe_block_status(struct acpi_gpe_xrupt_info *gpe_xrupt_info,
+			     struct acpi_gpe_block_info *gpe_block,
+			     void *ret_ptr)
+{
+	struct acpi_gpe_register_info *gpe_register_info;
+	u64 in_enable, in_status;
+	acpi_status status;
+	u8 *ret = ret_ptr;
+	u32 i;
+
+	/* Examine each GPE Register within the block */
+
+	for (i = 0; i < gpe_block->register_count; i++) {
+		gpe_register_info = &gpe_block->register_info[i];
+
+		status = acpi_hw_read(&in_enable,
+				      &gpe_register_info->enable_address);
+		if (ACPI_FAILURE(status)) {
+			continue;
+		}
+
+		status = acpi_hw_read(&in_status,
+				      &gpe_register_info->status_address);
+		if (ACPI_FAILURE(status)) {
+			continue;
+		}
+
+		*ret |= in_enable & in_status;
+	}
+
+	return (AE_OK);
+}
+
+/******************************************************************************
+ *
  * FUNCTION:    acpi_hw_disable_all_gpes
  *
  * PARAMETERS:  None
@@ -510,4 +557,28 @@ acpi_status acpi_hw_enable_all_wakeup_gp
 	return_ACPI_STATUS(status);
 }
 
+/******************************************************************************
+ *
+ * FUNCTION:    acpi_hw_check_all_gpes
+ *
+ * PARAMETERS:  None
+ *
+ * RETURN:      Combined status of all GPEs
+ *
+ * DESCRIPTION: Check all enabled GPEs in all GPE blocks and return TRUE if the
+ *              status bit is set for at least one of them of FALSE otherwise.
+ *
+ ******************************************************************************/
+
+u8 acpi_hw_check_all_gpes(void)
+{
+	u8 ret = 0;
+
+	ACPI_FUNCTION_TRACE(acpi_hw_check_all_gpes);
+
+	(void)acpi_ev_walk_gpe_list(acpi_hw_get_gpe_block_status, &ret);
+
+	return (ret != 0);
+}
+
 #endif				/* !ACPI_REDUCED_HARDWARE */
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -748,6 +748,7 @@ ACPI_HW_DEPENDENT_RETURN_UINT32(u32 acpi
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_disable_all_gpes(void))
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_enable_all_runtime_gpes(void))
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_enable_all_wakeup_gpes(void))
+ACPI_HW_DEPENDENT_RETURN_UINT32(u32 acpi_any_gpe_status_set(void))
 
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
 				acpi_get_gpe_device(u32 gpe_index,


