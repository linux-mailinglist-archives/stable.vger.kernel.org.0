Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 838BF5F8E46
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 22:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbiJIUze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 16:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbiJIUzA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 16:55:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1E031DD0;
        Sun,  9 Oct 2022 13:53:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 016B960C85;
        Sun,  9 Oct 2022 20:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61125C433C1;
        Sun,  9 Oct 2022 20:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665348782;
        bh=psaJ9l6m2dT3AwTJ14Cd2vhLcC+Ys2U7Ajn7QpIyigg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lcJCiNfQNy6NoIPCB+XnlH1oWry5Ng09R2iT32NgWUWH3TCrYG7e3FgHyrwFGd6Bg
         pCIo63DKotJzq+fUeQkzILyvWa9AKTZp+eMdyzXtD/X7S87RJlbVFHda97sfpHfBX0
         FglW0xa2hh0aEazUeXs6jPkC0DIRtCQ2lWtWsYNGFRvkhZ3GEqVuTDlo7bmI12y9GH
         EuH3vn6gaVuDB9uygn9tNjBUDpwmGYGSf4V7MhgmZa6kN4VBqgHtR7/15dd3yFyTmS
         qladHtzr2Wu+q8faXTQhKlJxFIKH+uFSOXul5GLq+H/8uDOhZ71omAPlJB6cJByxgK
         d2kXipnx2yXWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Luya Tshimbalanga <luya@fedoraproject.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        andriy.shevchenko@linux.intel.com, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 13/16] ACPI: x86: Add a quirk for Dell Inspiron 14 2-in-1 for StorageD3Enable
Date:   Sun,  9 Oct 2022 16:52:22 -0400
Message-Id: <20221009205226.1202133-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009205226.1202133-1-sashal@kernel.org>
References: <20221009205226.1202133-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit 018d6711c26e4bd26e20a819fcc7f8ab902608f3 ]

Dell Inspiron 14 2-in-1 has two ACPI nodes under GPP1 both with _ADR of
0, both without _HID.  It's ambiguous which the kernel should take, but
it seems to take "DEV0".  Unfortunately "DEV0" is missing the device
property `StorageD3Enable` which is present on "NVME".

To avoid this causing problems for suspend, add a quirk for this system
to behave like `StorageD3Enable` property was found.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216440
Reported-and-tested-by: Luya Tshimbalanga <luya@fedoraproject.org>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index 664070fc8349..d7cdd8406c84 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -207,9 +207,26 @@ static const struct x86_cpu_id storage_d3_cpu_ids[] = {
 	{}
 };
 
+static const struct dmi_system_id force_storage_d3_dmi[] = {
+	{
+		/*
+		 * _ADR is ambiguous between GPP1.DEV0 and GPP1.NVME
+		 * but .NVME is needed to get StorageD3Enable node
+		 * https://bugzilla.kernel.org/show_bug.cgi?id=216440
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 14 7425 2-in-1"),
+		}
+	},
+	{}
+};
+
 bool force_storage_d3(void)
 {
-	return x86_match_cpu(storage_d3_cpu_ids);
+	const struct dmi_system_id *dmi_id = dmi_first_match(force_storage_d3_dmi);
+
+	return dmi_id || x86_match_cpu(storage_d3_cpu_ids);
 }
 
 /*
-- 
2.35.1

