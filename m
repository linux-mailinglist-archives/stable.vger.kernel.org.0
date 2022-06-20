Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217BC552107
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 17:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243427AbiFTPbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 11:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244472AbiFTPbF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 11:31:05 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3CBB51;
        Mon, 20 Jun 2022 08:31:04 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id g8so10061507plt.8;
        Mon, 20 Jun 2022 08:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2O16LCpgM6TvHkr4tsHFJKXyDWr4WK5RTNspHfle58g=;
        b=Z673sdX4vTRUV4veoRY4P2eP8rTbiscRsyFcvP9q5i/ICTe/QPO94ytZa0PJgCH3WV
         UsiMDO4sc+pBy6PPGXh1imACrMAm2CwdEDO+SFov5Ioiq1MsRgypwzNFYfiCacZyG89s
         CViIcHcD8N7bWprl9mUDJEFXvAujIxf8ZTg0smWFGw6KPRnE2SLPVGrHarLsU3u2wjdU
         DQaxCMzJJkrkK8RAOoDptcETRRZG6ttfcQLyL/5H1O744rFdXQcnf7tzDvxqAQmSPB6H
         OENDJGWauWD37D82DT/tpFFIaQH5so09V8fsuMC4BhrVs1Y93oL1V3KUN3HeHqvxfAhQ
         vVUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2O16LCpgM6TvHkr4tsHFJKXyDWr4WK5RTNspHfle58g=;
        b=NvsNXUYbJy0wvpuxp3dopysJoyTBjtew15KokavVoYaQUPK11xobaFVo7CfbKRJ4aq
         mQkU/KI/Rs334OIyxbC8wZyzN6IxZ5y8YJN/KqNCNEh9BWvsPuXNI+5102vg9FlR+oT4
         2GQaPqw2DCZt3Q9ykNjzyTMM+hEmGS1k5rsN73UEEeYR6NgQWozL+EAsgjHfLFlt9Ru9
         vjwa60j6N09TVkWj0IgjXgPVl62vIN6YsL1W/5gT+1PGAQc7mAiFRIPQtLKPIF4d0m5Q
         wK2QLr1zW5J/Tem3EWuZC4poJUIPCDdRYpcQne4j6nPRFZs7GzMm45I+TN+Xyh7K61Gs
         nEIg==
X-Gm-Message-State: AJIora9weBjkSIc6h9kzwVY5ntWtgVJOzKknCSHqHpXUAgS37/cWgCos
        4y0ggjpT6WsK2REXJQuWgVkrrg85h3jGew==
X-Google-Smtp-Source: AGRyM1vZag1xQtRKGN30uW8Cb1Jlh9wXT8NPSw/p+dueKdMFYf3qtSJEAg+grbuwu7D/A24csrxhrg==
X-Received: by 2002:a17:90b:38c1:b0:1ea:8403:9305 with SMTP id nn1-20020a17090b38c100b001ea84039305mr27318565pjb.11.1655739063864;
        Mon, 20 Jun 2022 08:31:03 -0700 (PDT)
Received: from guoguo-omen.lan ([2401:c080:1400:4da2:b701:47d5:9291:4cf9])
        by smtp.gmail.com with ESMTPSA id t63-20020a628142000000b0051c03229a2bsm2038856pfd.21.2022.06.20.08.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 08:31:03 -0700 (PDT)
From:   Chuanhong Guo <gch981213@gmail.com>
To:     linux-acpi@vger.kernel.org
Cc:     Chuanhong Guo <gch981213@gmail.com>, stable@vger.kernel.org,
        Kent Hou Man <knthmn0@gmail.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 3/3] ACPI: skip IRQ1 override on Asus Zenbook S 13 OLED UM5302
Date:   Mon, 20 Jun 2022 23:30:45 +0800
Message-Id: <20220620153045.11129-4-gch981213@gmail.com>
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

From: Kent Hou Man <knthmn0@gmail.com>

This laptop also defines its active-low keyboard IRQ in legacy format.
Add IRQ override skipping for it.

Cc: <stable@vger.kernel.org>
Signed-off-by: Kent Hou Man <knthmn0@gmail.com>
Signed-off-by: Chuanhong Guo <gch981213@gmail.com>
---
Change since v2: none

 drivers/acpi/resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 30c0d85b2bf2..eff615f51d07 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -400,6 +400,13 @@ static const struct dmi_system_id medion_laptop[] = {
 };
 
 static const struct dmi_system_id irq1_edge_low_shared[] = {
+	{
+		.ident = "Asus Zenbook S 13 OLED UM5302",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "UM5302TA"),
+		},
+	},
 	{
 		.ident = "Lenovo ThinkBook 14 G4+ ARA",
 		.matches = {
-- 
2.36.1

