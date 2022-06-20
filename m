Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3816455210A
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 17:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244163AbiFTPbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 11:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237936AbiFTPbC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 11:31:02 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B05C389D;
        Mon, 20 Jun 2022 08:30:58 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id h9-20020a17090a648900b001ecb8596e43so1466508pjj.5;
        Mon, 20 Jun 2022 08:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UneClahiB/8V7fcxqAn05E3dVB9+CO56fTAaJHRcl6o=;
        b=KrilvoE7ma+YKbiv6DZy+y+jdvsxIV57L5+1d9ErWT2SPfqflhij0LxeJfdadCKI3o
         6MoKn63wjw6AyKisPwRRmcwsTHayPTRRQmbyfNvhPIBicI2xYmYyL/LhHL3tLAHVpPzH
         v5I9kgoHK0lU/F5rzq2XppWUl5UsCPjoeUJw9uQENBtMdkIRd/GSO8QadehbwKec62fl
         cJvxXjvVCQtFSaqvyabEqAOxpz2if8nC1pHs8/GFRRdc93VhV+VIoWNtQMVU38w303Pl
         9sE2n3nyjV8OjNClaLO+aFqR8GmFEj3RXZY7DtS1ZhfeBJxNYyITHKLfXkJ+hIZXPC4x
         NBRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UneClahiB/8V7fcxqAn05E3dVB9+CO56fTAaJHRcl6o=;
        b=PliDwes+0A93mJ1FFtwY/PTP1nSU0sJ5u+r6aM2BCSopr2uJX2CqZGdAxlJ2xkqHeL
         XbbUt4qWwjteDtbL5PncCAedPBiCTXGC2qBpjKEEQFdq6+IpbNkw3GsmSz27fDnkcdl5
         9XYoMKcd6N1vwtRe11+Ls8hFC1RfE+heLvpbv8/RBtyTq+0MNwuldK7X7SZf+fvuTyGo
         +8As3fndxEYt4NNF7iyB2Hn+Xq6ISIsGfYo/FabITljKnGDVy1dnp+ZDq+0zUqpubXHu
         17NzdewKw2IYBlf2gM5TqCSzscAZ8EOLe2MsA5NCDAAxGV9YTULFz4QyAV9OPdgLbI1M
         hLEg==
X-Gm-Message-State: AJIora8JQIRvPEJxzfUZg9yNMf7L0qekVqM2Fg8eAt1ZsDo7UEPF2FHU
        QR8k3dscg+QSyhXOK5Y4QqoOFiXMlWNfmA==
X-Google-Smtp-Source: AGRyM1uX7bIyXEqF+8nFHXku7R0MuJZB4Fh8Xw59dBkBKgAH56MQxnmE/grn5NK/3czQRSQ6ePWz6g==
X-Received: by 2002:a17:902:8b85:b0:168:d854:be84 with SMTP id ay5-20020a1709028b8500b00168d854be84mr24454730plb.94.1655739057404;
        Mon, 20 Jun 2022 08:30:57 -0700 (PDT)
Received: from guoguo-omen.lan ([2401:c080:1400:4da2:b701:47d5:9291:4cf9])
        by smtp.gmail.com with ESMTPSA id t63-20020a628142000000b0051c03229a2bsm2038856pfd.21.2022.06.20.08.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 08:30:57 -0700 (PDT)
From:   Chuanhong Guo <gch981213@gmail.com>
To:     linux-acpi@vger.kernel.org
Cc:     Chuanhong Guo <gch981213@gmail.com>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 1/3] ACPI: skip IRQ1 override on Lenovo ThinkBook 14G4+ ARA
Date:   Mon, 20 Jun 2022 23:30:43 +0800
Message-Id: <20220620153045.11129-2-gch981213@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620153045.11129-1-gch981213@gmail.com>
References: <20220620153045.11129-1-gch981213@gmail.com>
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
 Match DMI_PRODUCT_NAME for ThinkBook because the board name
 is used for other completely different Lenovo laptops.

Change since v2:
 fix alphabetical order in skip_override_table

 drivers/acpi/resource.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index c2d494784425..f888c62b8b96 100644
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
@@ -408,6 +419,7 @@ struct irq_override_cmp {
 };
 
 static const struct irq_override_cmp skip_override_table[] = {
+	{ irq1_edge_low_shared, 1, ACPI_EDGE_SENSITIVE, ACPI_ACTIVE_LOW, 1 },
 	{ medion_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0 },
 };
 
-- 
2.36.1

