Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F0D65B0B0
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbjABL11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:27:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235970AbjABL04 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:26:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09D76458
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:25:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E47F60F54
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75309C433D2;
        Mon,  2 Jan 2023 11:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658734;
        bh=KARuFOCbrAtg12Jo2kQpnf9kB8gMkJWKfghoyxl1sPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hAQhNjHBtt/uVES7UTUtaRVEruGaLBwI4+JHPqrvIfe4nxE6jR2i/1pEbcT7mcbBi
         JrVsM/qSi92uxKgN7qxrwXYnV6xF45dCKKZMQjVAL5bc+WT2KWW+MtCL1NG1C+nNvD
         kdGbhHVa0AOHkvRwzt/JIZ5gT9QZgVuXB51BRpaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mario Limonciello <mario.limonciello@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 51/71] ACPI: x86: s2idle: Force AMD GUID/_REV 2 on HP Elitebook 865
Date:   Mon,  2 Jan 2023 12:22:16 +0100
Message-Id: <20230102110553.629403211@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
References: <20230102110551.509937186@linuxfoundation.org>
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

commit 3ea45390e9c0d35805ef8357ace55594fd4233d0 upstream.

HP Elitebook 865 supports both the AMD GUID w/ _REV 2 and Microsoft
GUID with _REV 0. Both have very similar code but the AMD GUID
has a special workaround that is specific to a problem with
spurious wakeups on systems with Qualcomm WLAN.

This is believed to be a bug in the Qualcomm WLAN F/W (it doesn't
affect any other WLAN H/W). If this WLAN firmware is fixed this
quirk can be dropped.

Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/x86/s2idle.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/acpi/x86/s2idle.c b/drivers/acpi/x86/s2idle.c
index 5350c73564b6..422415cb14f4 100644
--- a/drivers/acpi/x86/s2idle.c
+++ b/drivers/acpi/x86/s2idle.c
@@ -401,6 +401,13 @@ static const struct acpi_device_id amd_hid_ids[] = {
 	{}
 };
 
+static int lps0_prefer_amd(const struct dmi_system_id *id)
+{
+	pr_debug("Using AMD GUID w/ _REV 2.\n");
+	rev_id = 2;
+	return 0;
+}
+
 static int lps0_prefer_microsoft(const struct dmi_system_id *id)
 {
 	pr_debug("Preferring Microsoft GUID.\n");
@@ -462,6 +469,19 @@ static const struct dmi_system_id s2idle_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "ROG Flow X16 GV601"),
 		},
 	},
+	{
+		/*
+		 * AMD Rembrandt based HP EliteBook 835/845/865 G9
+		 * Contains specialized AML in AMD/_REV 2 path to avoid
+		 * triggering a bug in Qualcomm WLAN firmware. This may be
+		 * removed in the future if that firmware is fixed.
+		 */
+		.callback = lps0_prefer_amd,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8990"),
+		},
+	},
 	{}
 };
 
-- 
2.39.0



