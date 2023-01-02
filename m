Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6D265B0D9
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbjABL2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236062AbjABL2H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:28:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FF060D4
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:27:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29B6660E83
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DDA7C433EF;
        Mon,  2 Jan 2023 11:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658836;
        bh=+vQl3lzwOCJzm2X9dwIqlDQEsVAcx8dkDdtXtofvDD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CGQfRR+tE0B5vcuu7+A9t/8xal4m6ayyr/RDtryyT4i4zDAH455BjJZm10IS0YAxw
         S/KvHLW0/jiUvL7HPAHgI5KSL7yW5nTKyR2Tya0p5vZ4moWgWnT9qCX7E+UXPH9TtU
         i2BDNQ7NlWYUaE1L76GpozgWrGRFQHTpdC8AB+Q0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adrian Freund <adrian@freund.io>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 18/74] ACPI: resource: do IRQ override on Lenovo 14ALC7
Date:   Mon,  2 Jan 2023 12:21:51 +0100
Message-Id: <20230102110552.827655659@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
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

From: Adrian Freund <adrian@freund.io>

[ Upstream commit f3cb9b740869712d448edf3b9ef5952b847caf8b ]

Commit bfcdf58380b1 ("ACPI: resource: do IRQ override on LENOVO IdeaPad")
added an override for Lenovo IdeaPad 5 16ALC7. The 14ALC7 variant also
suffers from a broken touchscreen and trackpad.

Fixes: 9946e39fe8d0 ("ACPI: resource: skip IRQ override on AMD Zen platforms")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216804
Signed-off-by: Adrian Freund <adrian@freund.io>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 504378cc79a2..98daea0db979 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -417,7 +417,14 @@ static const struct dmi_system_id asus_laptop[] = {
 	{ }
 };
 
-static const struct dmi_system_id lenovo_82ra[] = {
+static const struct dmi_system_id lenovo_laptop[] = {
+	{
+		.ident = "LENOVO IdeaPad Flex 5 14ALC7",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "82R9"),
+		},
+	},
 	{
 		.ident = "LENOVO IdeaPad Flex 5 16ALC7",
 		.matches = {
@@ -451,8 +458,8 @@ struct irq_override_cmp {
 static const struct irq_override_cmp override_table[] = {
 	{ medion_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, false },
 	{ asus_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, false },
-	{ lenovo_82ra, 6, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, true },
-	{ lenovo_82ra, 10, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, true },
+	{ lenovo_laptop, 6, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, true },
+	{ lenovo_laptop, 10, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, true },
 	{ schenker_gm_rg, 1, ACPI_EDGE_SENSITIVE, ACPI_ACTIVE_LOW, 1, true },
 };
 
-- 
2.35.1



