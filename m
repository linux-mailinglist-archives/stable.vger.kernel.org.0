Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF5764FA3D
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 16:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiLQP2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 10:28:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiLQP2A (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 10:28:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F5F15F17;
        Sat, 17 Dec 2022 07:27:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E972160C13;
        Sat, 17 Dec 2022 15:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9975FC433AA;
        Sat, 17 Dec 2022 15:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671290862;
        bh=SlFOvmMdVICDIUhdLCEFcFnIe5h4iszNQXPFJAN9MsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BIkQtXd189hTENM/23AINZW1BD0+FKssUBQBEGa3Zo9UpitdyO3l/e/F/DxzoGPQQ
         WZte8iTjJS1F164UEpYuSm08DwXZUYXUkRvw0d4X6eJofceH7NaFNQxvPjiwLmnJzs
         mBccZboZqG2PRjX0ZvaWSMDg5rGZb8J/vOvIWEnoGeZT+MA2zwHgiu+Ow/Y52tsy6I
         z0cMtlKgVq2g0qzgFp/TsVFXh2MHIuSqQbBMC4adTnZg8MDA3HDPbyoOXuFa8Rk2NG
         VPTsp09eG/i1hBVZEwVB4enaKd7OeCnwKXGzyF5OZFyKd8AGVJ6RYZlN/yJz35/8WJ
         LFKcFTpIwoalQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mia Kanashi <chad@redpilled.dev>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 06/22] ACPI: EC: Add quirk for the HP Pavilion Gaming 15-cx0041ur
Date:   Sat, 17 Dec 2022 10:27:07 -0500
Message-Id: <20221217152727.98061-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217152727.98061-1-sashal@kernel.org>
References: <20221217152727.98061-1-sashal@kernel.org>
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

From: Mia Kanashi <chad@redpilled.dev>

[ Upstream commit b423f240a66ad928c4cb5ec6055dfc90ce8d894e ]

Added GPE quirk entry for the HP Pavilion Gaming 15-cx0041ur.
There is a quirk entry for the 15-cx0xxx laptops, but this one has
different DMI_PRODUCT_NAME.

Notably backlight keys and other ACPI events now function correctly.

Signed-off-by: Mia Kanashi <chad@redpilled.dev>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 9b42628cf21b..9751b84c1b22 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1875,6 +1875,16 @@ static const struct dmi_system_id ec_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion Gaming Laptop 15-cx0xxx"),
 		},
 	},
+	{
+		/*
+		 * HP Pavilion Gaming Laptop 15-cx0041ur
+		 */
+		.callback = ec_honor_dsdt_gpe,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP 15-cx0041ur"),
+		},
+	},
 	{
 		/*
 		 * Samsung hardware
-- 
2.35.1

