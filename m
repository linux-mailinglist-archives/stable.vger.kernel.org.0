Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5927A65B0D7
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236088AbjABL2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236059AbjABL2H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:28:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030055583
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:27:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9199D60F49
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20D8C433D2;
        Mon,  2 Jan 2023 11:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658834;
        bh=pu23rQTEw8zo3Yep009JofGtNrxKgVPgTH1eMiard1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v+TDZSz1bTv+32utDHPCjsHVxgMXXFgW5WIMgzG+F5Tc0dB1jaice6pCR9nHfYSAc
         LqP/xDElTtmyagmvBbKML1zRCYctVY5cHirIVOTTjKOMZJD08+A2yNAQEOhnWrT5r9
         UdSa70vlMqBtqJx8+vcEyeHOgJcb2XEPrs1ikOUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Erik Schumacher <ofenfisch@googlemail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 17/74] ACPI: resource: do IRQ override on XMG Core 15
Date:   Mon,  2 Jan 2023 12:21:50 +0100
Message-Id: <20230102110552.773297533@linuxfoundation.org>
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

From: Erik Schumacher <ofenfisch@googlemail.com>

[ Upstream commit 7592b79ba4a91350b38469e05238308bcfe1019b ]

The Schenker XMG CORE 15 (M22) is Ryzen-6 based and needs IRQ overriding
for the keyboard to work. Adding an entry for this laptop to the
override_table makes the internal keyboard functional again.

Signed-off-by: Erik Schumacher <ofenfisch@googlemail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 30811a9521d4..504378cc79a2 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -428,6 +428,17 @@ static const struct dmi_system_id lenovo_82ra[] = {
 	{ }
 };
 
+static const struct dmi_system_id schenker_gm_rg[] = {
+	{
+		.ident = "XMG CORE 15 (M22)",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SchenkerTechnologiesGmbH"),
+			DMI_MATCH(DMI_BOARD_NAME, "GMxRGxx"),
+		},
+	},
+	{ }
+};
+
 struct irq_override_cmp {
 	const struct dmi_system_id *system;
 	unsigned char irq;
@@ -442,6 +453,7 @@ static const struct irq_override_cmp override_table[] = {
 	{ asus_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, false },
 	{ lenovo_82ra, 6, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, true },
 	{ lenovo_82ra, 10, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, true },
+	{ schenker_gm_rg, 1, ACPI_EDGE_SENSITIVE, ACPI_ACTIVE_LOW, 1, true },
 };
 
 static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
-- 
2.35.1



