Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC89C6AF397
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjCGTGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:06:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233655AbjCGTGZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:06:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A0FA7AAB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:51:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A71DEB819D0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:51:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DCFC4339B;
        Tue,  7 Mar 2023 18:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215103;
        bh=PJ7wA9HpVFcAQKP+05gDCPFDPCQxapM6QJwPf2u/G5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MpP/ro3rR/GCd9v7VtA4KpsZwGnVGMpcWtumTQH44kRvJMi5qiTXkNA1kFCPorA+N
         w25k3Hqu8ZFJVIkiWpldyBz73d1CAikzL+mGjDFG/aQI55/yoOsf8SKS3wJgqyA4Ah
         YGBsuwBvPGsPh0THzP4dyFTXgkVCFAlY+P7igoG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Werner Sembach <wse@tuxedocomputers.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 151/567] ACPI: resource: Do IRQ override on all TongFang GMxRGxx
Date:   Tue,  7 Mar 2023 17:58:07 +0100
Message-Id: <20230307165912.480954194@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Werner Sembach <wse@tuxedocomputers.com>

[ Upstream commit 17bb7046e7ce038a73ee97eaa804e0300c5199e2 ]

Apply commit 7592b79ba4a9 ("ACPI: resource: do IRQ override on XMG Core 15")
override for all vendors using this mainboard.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Fixes: 9946e39fe8d0 ("ACPI: resource: skip IRQ override on AMD Zen platforms")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index b153e434a796d..f6317bc417ab1 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -435,11 +435,10 @@ static const struct dmi_system_id lenovo_laptop[] = {
 	{ }
 };
 
-static const struct dmi_system_id schenker_gm_rg[] = {
+static const struct dmi_system_id tongfang_gm_rg[] = {
 	{
-		.ident = "XMG CORE 15 (M22)",
+		.ident = "TongFang GMxRGxx/XMG CORE 15 (M22)/TUXEDO Stellaris 15 Gen4 AMD",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "SchenkerTechnologiesGmbH"),
 			DMI_MATCH(DMI_BOARD_NAME, "GMxRGxx"),
 		},
 	},
@@ -478,7 +477,7 @@ static const struct irq_override_cmp override_table[] = {
 	{ asus_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, false },
 	{ lenovo_laptop, 6, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, true },
 	{ lenovo_laptop, 10, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, true },
-	{ schenker_gm_rg, 1, ACPI_EDGE_SENSITIVE, ACPI_ACTIVE_LOW, 1, true },
+	{ tongfang_gm_rg, 1, ACPI_EDGE_SENSITIVE, ACPI_ACTIVE_LOW, 1, true },
 	{ maingear_laptop, 1, ACPI_EDGE_SENSITIVE, ACPI_ACTIVE_LOW, 1, true },
 };
 
-- 
2.39.2



