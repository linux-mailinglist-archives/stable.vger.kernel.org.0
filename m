Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B3E4E9418
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240810AbiC1L0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240982AbiC1LYl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:24:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839CB55BDD;
        Mon, 28 Mar 2022 04:22:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEC30B81058;
        Mon, 28 Mar 2022 11:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA45C340F3;
        Mon, 28 Mar 2022 11:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466573;
        bh=RDdhik/g8aZ3wGxV6J8LDZnusm4htCVrLUo3WnbvOjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gfFYd6PN5/aTQ2MC4t87LHDzO6M4Ickpc8/qd8Rom8mm/rddTiThrBr4yazstBrOy
         MLnGKANYh+WRzB21dIMne3NdcDBu/zqdULp0bS1CJw6LdQHJ0wL7CUMyTvy/CiPwQL
         XpeFYJ6tW+iQTGj4OpKgJFR85vtU1ZibrX26TssysC3kKl8DtXr+31rtbbarYO2AMN
         sruj6lXIXBg7JMm0ZM8s1huYi4+B2plSV1/abnmDncKASngnMTHw3OE1FiE+aYBld2
         cdnw1H6ee8FIQur8XbroMkT+X/AWwzz+wULUhViAkkWwfox4rJiEz9wT/KgtECu+mx
         0/kuPqtHdINeA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mario Limonciello <Mario.Limonciello@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 29/29] Revert "ACPI: Pass the same capabilities to the _OSC regardless of the query flag"
Date:   Mon, 28 Mar 2022 07:21:31 -0400
Message-Id: <20220328112132.1555683-29-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328112132.1555683-1-sashal@kernel.org>
References: <20220328112132.1555683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 2ca8e6285250c07a2e5a22ecbfd59b5a4ef73484 ]

Revert commit 159d8c274fd9 ("ACPI: Pass the same capabilities to the
_OSC regardless of the query flag") which caused legitimate usage
scenarios (when the platform firmware does not want the OS to control
certain platform features controlled by the system bus scope _OSC) to
break and was misguided by some misleading language in the _OSC
definition in the ACPI specification (in particular, Section 6.2.11.1.3
"Sequence of _OSC Calls" that contradicts other perts of the _OSC
definition).

Link: https://lore.kernel.org/linux-acpi/CAJZ5v0iStA0JmO0H3z+VgQsVuQONVjKPpw0F5HKfiq=Gb6B5yw@mail.gmail.com
Reported-by: Mario Limonciello <Mario.Limonciello@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Huang Rui <ray.huang@amd.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/bus.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index dd535b4b9a16..3500744e6862 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -332,21 +332,32 @@ static void acpi_bus_osc_negotiate_platform_control(void)
 	if (ACPI_FAILURE(acpi_run_osc(handle, &context)))
 		return;
 
-	kfree(context.ret.pointer);
+	capbuf_ret = context.ret.pointer;
+	if (context.ret.length <= OSC_SUPPORT_DWORD) {
+		kfree(context.ret.pointer);
+		return;
+	}
 
-	/* Now run _OSC again with query flag clear */
+	/*
+	 * Now run _OSC again with query flag clear and with the caps
+	 * supported by both the OS and the platform.
+	 */
 	capbuf[OSC_QUERY_DWORD] = 0;
+	capbuf[OSC_SUPPORT_DWORD] = capbuf_ret[OSC_SUPPORT_DWORD];
+	kfree(context.ret.pointer);
 
 	if (ACPI_FAILURE(acpi_run_osc(handle, &context)))
 		return;
 
 	capbuf_ret = context.ret.pointer;
-	osc_sb_apei_support_acked =
-		capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_APEI_SUPPORT;
-	osc_pc_lpi_support_confirmed =
-		capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_PCLPI_SUPPORT;
-	osc_sb_native_usb4_support_confirmed =
-		capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_NATIVE_USB4_SUPPORT;
+	if (context.ret.length > OSC_SUPPORT_DWORD) {
+		osc_sb_apei_support_acked =
+			capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_APEI_SUPPORT;
+		osc_pc_lpi_support_confirmed =
+			capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_PCLPI_SUPPORT;
+		osc_sb_native_usb4_support_confirmed =
+			capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_NATIVE_USB4_SUPPORT;
+	}
 
 	kfree(context.ret.pointer);
 }
-- 
2.34.1

