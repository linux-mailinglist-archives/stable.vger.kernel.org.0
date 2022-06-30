Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5BB560EA7
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 03:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiF3BcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 21:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiF3BcC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 21:32:02 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D295F326E4;
        Wed, 29 Jun 2022 18:31:59 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 136so11583640pfy.10;
        Wed, 29 Jun 2022 18:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cOCTVqFJoEKeuuX9iBUm+2/q/as6mV39rJ1R2rX6Sds=;
        b=QD/2SmOVVZNXfiNHzWuQ9mURGcwngedIclCng+blqHMDdz1yM1w0E8Qe7ncS1+6h3I
         sLkI9pwX8ped3lqinQLVbUNOop1aSxn6ebyPcSwbBBOP9xPNybwwex5W/O9f/rRnKH7H
         RKcxRfUvDH8RbojMIKEVFki6ZlD9AAYDtctPFZq5/RiMNDRPwhqQAYRZBncCnSY+nKZ5
         +yaoL0RQ+W2e8LA/AIifr/1YbQm6rIuJidskRk615K8dljauQnZPHbLsHFOX5XEktNvV
         O997K4b/0PtpaMZvovvPNFDrsgQ4rSNZ9F2qOGr2Q0WpcR9NVqSMgp94SUzb9HlxiSPT
         Y/GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cOCTVqFJoEKeuuX9iBUm+2/q/as6mV39rJ1R2rX6Sds=;
        b=1/WNcfJR6b7l9/iNlHQlFGFv71gNXpJTILsdYQvQWMNMI12N/BlER6S9yGCKDQO7Sg
         gFoX1qPk7vaCkBY/LXwAE96O4pNZvSfuy6y10O3KUSE47JDbPwN/L0Fn23LsKHcAR1C1
         PvuFuFrTo2em2wcbeUom0ZkWtolYcl9joEhukt1MxMWYKLT1pmGJHQklAI+fhnkGMqAc
         VtQFN93N30CPrwYfCpM4VWzq7FTi5TVK/2wlx9lSm+8JmpZ7hnd3gcGckwKopzfONFqi
         iZmi8ljXiVAQ1SzhrSiACg1JHS7iErHBtm0HLKQwPIofkCPyL1Xbe9P4ZAkD1PLxRFzn
         jMlw==
X-Gm-Message-State: AJIora9QkfT4kN6N+mL4fb6ce0NjdVQV8fZtWX/V0eMaDABbdFyBLCcP
        ZgkCP5t5JUJrkwuTQqqsNFlWUbJIuHbQHw==
X-Google-Smtp-Source: AGRyM1sVhMBsRvuSQW+ElIZjRiceQijkhg4f+7koeZsfC2BoKJrGQYArHSTbrtsx4FtmOy3eQr6G2A==
X-Received: by 2002:a63:5b26:0:b0:40d:9515:b5ac with SMTP id p38-20020a635b26000000b0040d9515b5acmr5514627pgb.51.1656552719220;
        Wed, 29 Jun 2022 18:31:59 -0700 (PDT)
Received: from guoguo-omen.lan ([2401:c080:1400:4da2:b701:47d5:9291:4cf9])
        by smtp.gmail.com with ESMTPSA id 132-20020a62198a000000b0051bc5f4df1csm12124383pfz.154.2022.06.29.18.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 18:31:58 -0700 (PDT)
From:   Chuanhong Guo <gch981213@gmail.com>
To:     linux-acpi@vger.kernel.org
Cc:     Chuanhong Guo <gch981213@gmail.com>, stable@vger.kernel.org,
        Tighe Donnelly <tighe.donnelly@protonmail.com>,
        Kent Hou Man <knthmn0@gmail.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4] ACPI: skip IRQ1 override on 3 laptops
Date:   Thu, 30 Jun 2022 09:31:23 +0800
Message-Id: <20220630013123.9427-1-gch981213@gmail.com>
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
Redmi Book Pro 15 2022
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

 drivers/acpi/resource.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index c2d494784425..470722c50afb 100644
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
+		.ident = "Redmi Book Pro 15 2022",
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

