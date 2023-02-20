Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E38869CDAD
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbjBTNvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbjBTNvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:51:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE4F1E5C1
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:51:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A0B160D41
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:51:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0C6C433D2;
        Mon, 20 Feb 2023 13:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901095;
        bh=YZBQsxnwoPa/p8Zp/+6TVx/q1nqcMmpnG85ZFtgp79k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fKsIgDGMxtVzD0uAlXcRSKEnUcacxQMSvCWXJ9crt/JeNdvxklZ3dRgneGs/MdBm1
         tLc92D1jTcJF8oYvppt4skh6cQEpfmGvh6tVPctNg90socAgKckUJ7JJMfimqoi4Yx
         XCehB5pUuuvNGhFRtLt+VkpJ+xZNHoV7O/vfI+eM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mario Limonciello <mario.limonciello@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 04/83] ACPI / x86: Add support for LPS0 callback handler
Date:   Mon, 20 Feb 2023 14:35:37 +0100
Message-Id: <20230220133553.822998004@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 20e1d6402a71dba7ad2b81f332a3c14c7d3b939b ]

Currenty the latest thing run during a suspend to idle attempt is
the LPS0 `prepare_late` callback and the earliest thing is the
`resume_early` callback.

There is a desire for the `amd-pmc` driver to suspend later in the
suspend process (ideally the very last thing), so create a callback
that it or any other driver can hook into to do this.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/20220317141445.6498-1-mario.limonciello@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Stable-dep-of: 8e60615e8932 ("platform/x86/amd: pmc: Disable IRQ1 wakeup for RN/CZN")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/s2idle.c | 40 +++++++++++++++++++++++++++++++++++++++
 include/linux/acpi.h      | 10 +++++++++-
 2 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/x86/s2idle.c b/drivers/acpi/x86/s2idle.c
index 2af1ae1721021..4a11a38764321 100644
--- a/drivers/acpi/x86/s2idle.c
+++ b/drivers/acpi/x86/s2idle.c
@@ -86,6 +86,8 @@ struct lpi_device_constraint_amd {
 	int min_dstate;
 };
 
+static LIST_HEAD(lps0_s2idle_devops_head);
+
 static struct lpi_constraints *lpi_constraints_table;
 static int lpi_constraints_table_size;
 static int rev_id;
@@ -434,6 +436,8 @@ static struct acpi_scan_handler lps0_handler = {
 
 int acpi_s2idle_prepare_late(void)
 {
+	struct acpi_s2idle_dev_ops *handler;
+
 	if (!lps0_device_handle || sleep_no_lps0)
 		return 0;
 
@@ -464,14 +468,26 @@ int acpi_s2idle_prepare_late(void)
 		acpi_sleep_run_lps0_dsm(ACPI_LPS0_MS_ENTRY,
 				lps0_dsm_func_mask_microsoft, lps0_dsm_guid_microsoft);
 	}
+
+	list_for_each_entry(handler, &lps0_s2idle_devops_head, list_node) {
+		if (handler->prepare)
+			handler->prepare();
+	}
+
 	return 0;
 }
 
 void acpi_s2idle_restore_early(void)
 {
+	struct acpi_s2idle_dev_ops *handler;
+
 	if (!lps0_device_handle || sleep_no_lps0)
 		return;
 
+	list_for_each_entry(handler, &lps0_s2idle_devops_head, list_node)
+		if (handler->restore)
+			handler->restore();
+
 	/* Modern standby exit */
 	if (lps0_dsm_func_mask_microsoft > 0)
 		acpi_sleep_run_lps0_dsm(ACPI_LPS0_MS_EXIT,
@@ -514,4 +530,28 @@ void acpi_s2idle_setup(void)
 	s2idle_set_ops(&acpi_s2idle_ops_lps0);
 }
 
+int acpi_register_lps0_dev(struct acpi_s2idle_dev_ops *arg)
+{
+	if (!lps0_device_handle || sleep_no_lps0)
+		return -ENODEV;
+
+	lock_system_sleep();
+	list_add(&arg->list_node, &lps0_s2idle_devops_head);
+	unlock_system_sleep();
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(acpi_register_lps0_dev);
+
+void acpi_unregister_lps0_dev(struct acpi_s2idle_dev_ops *arg)
+{
+	if (!lps0_device_handle || sleep_no_lps0)
+		return;
+
+	lock_system_sleep();
+	list_del(&arg->list_node);
+	unlock_system_sleep();
+}
+EXPORT_SYMBOL_GPL(acpi_unregister_lps0_dev);
+
 #endif /* CONFIG_SUSPEND */
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 6224b1e32681c..2d7df5cea2494 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -1005,7 +1005,15 @@ void acpi_os_set_prepare_extended_sleep(int (*func)(u8 sleep_state,
 
 acpi_status acpi_os_prepare_extended_sleep(u8 sleep_state,
 					   u32 val_a, u32 val_b);
-
+#ifdef CONFIG_X86
+struct acpi_s2idle_dev_ops {
+	struct list_head list_node;
+	void (*prepare)(void);
+	void (*restore)(void);
+};
+int acpi_register_lps0_dev(struct acpi_s2idle_dev_ops *arg);
+void acpi_unregister_lps0_dev(struct acpi_s2idle_dev_ops *arg);
+#endif /* CONFIG_X86 */
 #ifndef CONFIG_IA64
 void arch_reserve_mem_area(acpi_physical_address addr, size_t size);
 #else
-- 
2.39.0



