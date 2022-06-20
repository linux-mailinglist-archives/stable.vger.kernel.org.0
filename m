Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563A45520FD
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 17:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244474AbiFTPbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 11:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243012AbiFTPbD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 11:31:03 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB8863CB;
        Mon, 20 Jun 2022 08:31:01 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id g16-20020a17090a7d1000b001ea9f820449so11086680pjl.5;
        Mon, 20 Jun 2022 08:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3uX8JEY3yzqZx2k+nAoEseHhd0Ih43vt3Z+l+I/7AYs=;
        b=h/DJoM3cu3mZ6u/w4qSBvMivfmV1zJUPsVLCeLa0vSLIIj8eShwAaa33T6yRTr7snk
         kfukuO1tegEL/reVqwitHKGJh8ohe/GydOJlELsTnHJuh48wejtJXgnQ5F6DlU0MvF8d
         gkEcVQOyAF4MGerzmmjcx+T4I2W2m6UjsyIxb+o8xPGfnxcil530YwloK6Vdd5ojiSZ/
         upQ5jXIDNDHehoLQW5k1wByGmn7jmTfB/Q7+nxo/2pJWV1WdNyjgfiPMXje3j6xztLn/
         d9EpD2H6raPGiS7tshVBwDxCy99S4DuYo/TSFYgoidWJQ5ZdJqBIeXdY1z0ozsFQLsUO
         WAJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3uX8JEY3yzqZx2k+nAoEseHhd0Ih43vt3Z+l+I/7AYs=;
        b=aY5RGhN1IcCOxq2FWQMRwDr6p4JQY71TlA0efbjqrFymAmAxvxYLmmePmw4RnhxCYm
         M6IBh09DrHsPqRoyUGiGdSxXJ0Y4mrT6x4VUKkHbzHCGuuwh6eXB27j4ZiATDizY0rJF
         LfjzSnYzJIK8Is2HiQzOPG1XI5iEodl5KGojMPCimyJ5jCSf8llBG/PXhSyYi9HLHevN
         Gl2dA3ODQQzbvgS+IJ9dyeyOPArCk9zHVApDBS1EDF8RNBHd7UpV/KF0Jrx0jV7/Gd+M
         tU7UDvc3cnNdeT6dgWFwNuhDfd8rZs58/vayJilH59C9ZzfytkdFdGLbQgPgL910HL5h
         FTQQ==
X-Gm-Message-State: AJIora80Ru7d5wmJLRHdMwBGWJ1qQpttTRqScGkejbHmpl503DDgzUjE
        xhoQ3z6ZzY+Nt8bYGzeLt90wxvYc30n/Ew==
X-Google-Smtp-Source: AGRyM1uTwHDveS7NtQscN0aXr5CXn23zpM9zU6BhF08wXh0NtiBlY2UH7nIG+7T7f9qgVMjzgNhlsA==
X-Received: by 2002:a17:90b:3812:b0:1ea:d6e6:1386 with SMTP id mq18-20020a17090b381200b001ead6e61386mr27310620pjb.211.1655739060635;
        Mon, 20 Jun 2022 08:31:00 -0700 (PDT)
Received: from guoguo-omen.lan ([2401:c080:1400:4da2:b701:47d5:9291:4cf9])
        by smtp.gmail.com with ESMTPSA id t63-20020a628142000000b0051c03229a2bsm2038856pfd.21.2022.06.20.08.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 08:31:00 -0700 (PDT)
From:   Chuanhong Guo <gch981213@gmail.com>
To:     linux-acpi@vger.kernel.org
Cc:     Chuanhong Guo <gch981213@gmail.com>, stable@vger.kernel.org,
        Tighe Donnelly <tighe.donnelly@protonmail.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 2/3] ACPI: skip IRQ1 override on Redmi Book Pro 15 2022
Date:   Mon, 20 Jun 2022 23:30:44 +0800
Message-Id: <20220620153045.11129-3-gch981213@gmail.com>
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

From: Tighe Donnelly <tighe.donnelly@protonmail.com>

The IRQ is described as (Edge, ActiveLow, Shared, ) in ACPI DSDT and
it's correct. The override makes the keyboard interrupt polarity
inverted, resulting in non-functional keyboard.
Add an entry for skipping the override.

Cc: <stable@vger.kernel.org>
Signed-off-by: Tighe Donnelly <tighe.donnelly@protonmail.com>
Signed-off-by: Chuanhong Guo <gch981213@gmail.com>
---
Change since v1: new patch
Change since v2: none

 drivers/acpi/resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index f888c62b8b96..30c0d85b2bf2 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -407,6 +407,13 @@ static const struct dmi_system_id irq1_edge_low_shared[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "21D0"),
 		},
 	},
+	{
+		.ident = "Redmi Book Pro 15 2022",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TIMI"),
+			DMI_MATCH(DMI_BOARD_NAME, "TM2113"),
+		},
+	},
 	{ }
 };
 
-- 
2.36.1

