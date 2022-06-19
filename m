Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C671C550AD2
	for <lists+stable@lfdr.de>; Sun, 19 Jun 2022 15:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236608AbiFSNRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jun 2022 09:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234547AbiFSNRm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jun 2022 09:17:42 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726F4E70;
        Sun, 19 Jun 2022 06:17:40 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id y13-20020a17090a154d00b001eaaa3b9b8dso7962210pja.2;
        Sun, 19 Jun 2022 06:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y4ZAlYmM9NAh7Jy0y3cENEFi8vBtUGBTB65jZWB6h3U=;
        b=OZsHniZMtdGjvsLZPZjk70X2jr5ejROLKEYS5vnH5YtqShPVDPMR1S6ArEWQYpabqg
         pyTycf0FHIvLGxzN5Tvn0qy8DwnvCdi2KKaw6+p2c6m5BZFRRmyUO7WJ66EWINNrEg/w
         Pqr5JuJAEtVxTID63AxUZZPqeq2H0fs0wkb67Ur2k2BN1SMr/Fgwz/Xufuw64YLtwAzy
         Sp3KZ4cGB7XpQeV+eZTydwSXLryL6AcM2fdkRCZ5JgTjJ+JFeXN6LjvOAJXr9ArW1KG6
         EfBEz1h26p2heOT6oFSYKQvsyia1iuBrZabO3UJXUTTDFo1qoJL3EeHHNPNQ95437vvu
         kN1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y4ZAlYmM9NAh7Jy0y3cENEFi8vBtUGBTB65jZWB6h3U=;
        b=SnTr5VqCqk1V7AP9PdWcwweysRemwmn49SBQ3q4r7Olufs3klYGDYC4DD67YK3EEB3
         H/RpTfPbRhbYxiTwVNWcZK42+H8J27dwY1Z0u+ewabs3Qvi9yz+L00meZsSSc5ARb5Xa
         6R2h30ItP+BOrJAw0uRUBGvCoVlR9bQ1Wvn9j67K2yjFM/OMW26E4fi586TWxr/zEHzI
         WVAP/a8ug10xr+ixbPCXI8BqNUOwI0Ilf/F5tvvYmw9QOluBCyKqxI1NG+JLtWBuA3EG
         8c6fW/kXXByyNx+DMvdfESFEGHsLdHGAac/Jj1UGOw/NPRoC8JJDS4fLRhqgaqlYwEUH
         vTDA==
X-Gm-Message-State: AJIora8iExUlnZXDtY0Q4cnBZjwi7NXgTMjOl87v4u9hX/aGKeknE8BD
        L7t6R/dH9ODMV//hjVr+Wy9d9mQ8kieCtw==
X-Google-Smtp-Source: AGRyM1u7CzSJW3yJ78YxHDUNN5NfBxasYkkYQxLo01XtsDUQsdfe4dFutwGF5AJdsTMbmZUSUpn6Gw==
X-Received: by 2002:a17:90a:e503:b0:1ec:84b2:6404 with SMTP id t3-20020a17090ae50300b001ec84b26404mr10237512pjy.169.1655644659738;
        Sun, 19 Jun 2022 06:17:39 -0700 (PDT)
Received: from guoguo-omen.lan ([2401:c080:1400:4da2:b701:47d5:9291:4cf9])
        by smtp.gmail.com with ESMTPSA id g1-20020a1709026b4100b001635f7a54e8sm6771857plt.1.2022.06.19.06.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jun 2022 06:17:39 -0700 (PDT)
From:   Chuanhong Guo <gch981213@gmail.com>
To:     linux-acpi@vger.kernel.org
Cc:     Chuanhong Guo <gch981213@gmail.com>, stable@vger.kernel.org,
        Tighe Donnelly <tighe.donnelly@protonmail.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 2/2] ACPI: skip IRQ1 override on Redmi Book Pro 15 2022
Date:   Sun, 19 Jun 2022 21:16:57 +0800
Message-Id: <20220619131657.37067-3-gch981213@gmail.com>
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

 drivers/acpi/resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index b69c229b23dd..d9d8d546f340 100644
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

