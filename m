Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7914560F20
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 04:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbiF3CYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 22:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbiF3CYj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 22:24:39 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741EE22B33;
        Wed, 29 Jun 2022 19:24:38 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id n10so15803629plp.0;
        Wed, 29 Jun 2022 19:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AeTBtkFa9BSaGOkSSQvtd8eJW0/kdfqE/0LY3WLRWxs=;
        b=MAv+y9mxgyvkGzC8caBlcgzg5oLCAzMQ95p5/Idh6ox+vcn9o9sEehd27UQ6pjSPF4
         OQSQHpIdZhafjwU2dnslxaW8kkwPNcm8QCgkRJleZycJWEpXF+hIXvBhm1OAmDA0VSEU
         mSyYK98WwsUQvoCxIRhUXm9f/Bue4Dm2s7CqmByUd4UnHqFHIw1C2SSXj0burHjRDgR9
         CrNOHPr8GbygvusZM5lGmPgkuqjtoFp7PZVFWO1j3q1WjRL5X+HMVU9RnxrMBIm5lhvy
         uFoR7865ImA30mwK7RUHLbcnrvHsasQoLSQZXEDtHVMC++1o8w86Qo3iTzmcIFlTJK3a
         YMYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AeTBtkFa9BSaGOkSSQvtd8eJW0/kdfqE/0LY3WLRWxs=;
        b=W4lVNKEpHpvX7pnbMXlv13R7XpxsROHTyPwH9t3ZEChheUzrP8DkXVrCRSaz2WdI0u
         t2m0yeZXFFLgL2f92JBFk8XJuZJzfl6A6M6rRqbC1DDk/olyYSwzloD9FVOCDENFZM6e
         ZE25rmrdXBJZNQvk2iJRgc8RyGJGioTyJ0LH0GWkmXGDi3qXOihX+FT+NAcNPNENd479
         Vrbijsov3CvuYIOqdD8ERmtJpIkkLe8PQu3MIusxxG80Ze4/mZZ+zTizOr8eONEJcmhb
         VUeg5TXsskD4qPdMByTCT8G7dNJ+xM63fhl+GmJKar1HC257yhbVuZ356wtTBDmv81V6
         t3fA==
X-Gm-Message-State: AJIora91t3XJ0ajkIcOFxeUP8KKtCGH+aUpK+pEQwVO1rStaM2jPhwVj
        08m5IAqRje8bRCiJyf6dRZrTAj60ajACKw==
X-Google-Smtp-Source: AGRyM1s9c7trza6xxaxexw9PtKyJ4TndADx2KHDpB/KOGUbhZ/LvewcTp0QdUKXRePa3vyfzbr8ttA==
X-Received: by 2002:a17:90b:3b81:b0:1ed:3655:d0c8 with SMTP id pc1-20020a17090b3b8100b001ed3655d0c8mr9368801pjb.56.1656555877824;
        Wed, 29 Jun 2022 19:24:37 -0700 (PDT)
Received: from guoguo-omen.lan ([2401:c080:1400:4da2:b701:47d5:9291:4cf9])
        by smtp.gmail.com with ESMTPSA id z9-20020a1709027e8900b0016b865ea2d6sm5881252pla.82.2022.06.29.19.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 19:24:36 -0700 (PDT)
From:   Chuanhong Guo <gch981213@gmail.com>
To:     linux-acpi@vger.kernel.org
Cc:     Chuanhong Guo <gch981213@gmail.com>, stable@vger.kernel.org,
        Tighe Donnelly <tighe.donnelly@protonmail.com>,
        Kent Hou Man <knthmn0@gmail.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5] ACPI: skip IRQ1 override on 3 Ryzen 6000 laptops
Date:   Thu, 30 Jun 2022 10:23:17 +0800
Message-Id: <20220630022317.15734-1-gch981213@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The IRQ1 of these laptops with Ryzen 6000 and Insyde UEFI are active
low and defined in legacy format in ACPI DSDT. The kernel override
makes the keyboard interrupt polarity inverted, resulting in
non-functional keyboard.

Skip legacy IRQ override for:
Lenovo ThinkBook 14G4+ ARA
Redmi Book Pro 15 2022 Ryzen
Asus Zenbook S 13 OLED UM5302

Cc: <stable@vger.kernel.org>
Signed-off-by: Tighe Donnelly <tighe.donnelly@protonmail.com>
Signed-off-by: Kent Hou Man <knthmn0@gmail.com>
Signed-off-by: Chuanhong Guo <gch981213@gmail.com>
---
Changes since v1:
 Match DMI_PRODUCT_NAME for ThinkBook because the board name
 is used for other completely different Lenovo laptops.
 Add a patch for RedmiBook

Changes since v2:
 Fix alphabetical order in skip_override_table
 Add a patch for Asus Zenbook

Changes since v3:
 Merge patches as requested
 Fix another alphabetical ordering between two structs

Changes since v4:
 rename the ident in RedmiBook entry.
  There's also an Intel version of this series, so
  rename it to make it specific.
 reword commit title

 drivers/acpi/resource.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index c2d494784425..0491da180fc5 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -381,6 +381,31 @@ unsigned int acpi_dev_get_irq_type(int triggering, int polarity)
 }
 EXPORT_SYMBOL_GPL(acpi_dev_get_irq_type);
 
+static const struct dmi_system_id irq1_edge_low_shared[] = {
+	{
+		.ident = "Asus Zenbook S 13 OLED UM5302",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "UM5302TA"),
+		},
+	},
+	{
+		.ident = "Lenovo ThinkBook 14 G4+ ARA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21D0"),
+		},
+	},
+	{
+		.ident = "Redmi Book Pro 15 2022 Ryzen",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TIMI"),
+			DMI_MATCH(DMI_BOARD_NAME, "TM2113"),
+		},
+	},
+	{ }
+};
+
 static const struct dmi_system_id medion_laptop[] = {
 	{
 		.ident = "MEDION P15651",
@@ -408,6 +433,7 @@ struct irq_override_cmp {
 };
 
 static const struct irq_override_cmp skip_override_table[] = {
+	{ irq1_edge_low_shared, 1, ACPI_EDGE_SENSITIVE, ACPI_ACTIVE_LOW, 1 },
 	{ medion_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0 },
 };
 
-- 
2.36.1

