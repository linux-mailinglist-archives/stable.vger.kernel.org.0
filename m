Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0463550ACE
	for <lists+stable@lfdr.de>; Sun, 19 Jun 2022 15:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236249AbiFSNRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jun 2022 09:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234547AbiFSNRi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jun 2022 09:17:38 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F798C09;
        Sun, 19 Jun 2022 06:17:37 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id k127so2825136pfd.10;
        Sun, 19 Jun 2022 06:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SUBKv4QmW3O3Urz4wD4ggY9364IV2YnpYiV+iyD5zDA=;
        b=Dg1sOA+XEFfekbdv4RSD80umuXbFOUXiuK6XLz2RcUlMFWGPDulqt2HRmN4E1CM2pq
         lrdiMc+lGpO0NhNXC5MXeIaeRQ6i3CHQExHCF8gaWAQHNf9UeKmYpkZewdMWRXwNAxXk
         JNvC+ryrgpgJcDa/xv5WZFnxXhjh9EyvCtWEzWhC6Q7hfJ0tNzjQrbh7XKrOvh6+mPt5
         8Lbu1Ik6OI7a+mHJj7xRLqL74g1qyYcpTuw+UbHll+P3QXq5fkjUbkbHiu9kcoXd+8YE
         wyn4Tj2N4isNt1JWFlzs7E+gytJ51G5VXDlohf1eOVt+Zui8q1Wqg6BAD0CJutK6vYA4
         pSDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SUBKv4QmW3O3Urz4wD4ggY9364IV2YnpYiV+iyD5zDA=;
        b=ei35jcNWnMQZ9VflyqAGlCnvOzoghReTSfeiOLq0Gt1sn2qy+FbhTPezVUDi+AIsRs
         AeXBBcgkFToGLP88A3oLoIMsM8WsmTd4SxRJYj9g1sbE7QtS5WwpZj6RDkPt8ZCJO1eG
         aeEMxoQjbs5587FzSlpccE279ThMiPf9Nys9adQ5gWIfQku+qvid52GgFzYjD+ymbSyM
         IGD5MYL6SjvDYikkkLvnSLiqm9vNuitWJElw8is2QS1Vkd96wCTTvXSi7W//uz6tqQrx
         v9TB+JxhgSi4wxcCiQujII8GWqMe/xQIPgFEJNhRQEH14ghvzmtc50UNO9xchPZd48M/
         AX+g==
X-Gm-Message-State: AJIora8y9UnuF98iI2fkvnd2zsqBmmWBESlxK2Pwb+SpkSt6T0ZxF9ob
        0qb2zEn8Xn5hyQvsFOn6qbJjg3Hwx4LimQ==
X-Google-Smtp-Source: AGRyM1spgID9Rsc2NM4DF0qiOSIJB+y1K+mkwXWUTna6OVLgCQ/8HE1dmlJTYDk2oMzqHTh/xkmftQ==
X-Received: by 2002:a63:36cc:0:b0:40c:5301:7fe2 with SMTP id d195-20020a6336cc000000b0040c53017fe2mr11076329pga.547.1655644656409;
        Sun, 19 Jun 2022 06:17:36 -0700 (PDT)
Received: from guoguo-omen.lan ([2401:c080:1400:4da2:b701:47d5:9291:4cf9])
        by smtp.gmail.com with ESMTPSA id g1-20020a1709026b4100b001635f7a54e8sm6771857plt.1.2022.06.19.06.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jun 2022 06:17:35 -0700 (PDT)
From:   Chuanhong Guo <gch981213@gmail.com>
To:     linux-acpi@vger.kernel.org
Cc:     Chuanhong Guo <gch981213@gmail.com>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/2] ACPI: skip IRQ1 override on Lenovo ThinkBook 14G4+ ARA
Date:   Sun, 19 Jun 2022 21:16:56 +0800
Message-Id: <20220619131657.37067-2-gch981213@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220619131657.37067-1-gch981213@gmail.com>
References: <20220619131657.37067-1-gch981213@gmail.com>
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

The IRQ is described as (Edge, ActiveLow, Shared, ) in ACPI DSDT and
it's correct. The override makes the keyboard interrupt polarity
inverted, resulting in non-functional keyboard.
Add an entry for skipping the override.

Cc: <stable@vger.kernel.org>
Signed-off-by: Chuanhong Guo <gch981213@gmail.com>
---
Change since v1:
 Match DMI DMI_PRODUCT_NAME for ThinkBook because the board name
 is used for other completely different Lenovo laptops.

 drivers/acpi/resource.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index c2d494784425..b69c229b23dd 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -399,6 +399,17 @@ static const struct dmi_system_id medion_laptop[] = {
 	{ }
 };
 
+static const struct dmi_system_id irq1_edge_low_shared[] = {
+	{
+		.ident = "Lenovo ThinkBook 14 G4+ ARA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21D0"),
+		},
+	},
+	{ }
+};
+
 struct irq_override_cmp {
 	const struct dmi_system_id *system;
 	unsigned char irq;
@@ -409,6 +420,7 @@ struct irq_override_cmp {
 
 static const struct irq_override_cmp skip_override_table[] = {
 	{ medion_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0 },
+	{ irq1_edge_low_shared, 1, ACPI_EDGE_SENSITIVE, ACPI_ACTIVE_LOW, 1 },
 };
 
 static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
-- 
2.36.1

