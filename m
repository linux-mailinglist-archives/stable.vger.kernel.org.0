Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9AF58C061
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243253AbiHHBuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243036AbiHHBtm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:49:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C592DFB7;
        Sun,  7 Aug 2022 18:37:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58099B80E11;
        Mon,  8 Aug 2022 01:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15551C433D6;
        Mon,  8 Aug 2022 01:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922645;
        bh=fJlX3h+MOj3Xfe/dl4vL1uJNZJFo+EAzH1jy8cqdO+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rdgCt1Xsbm8b3908j6jB7HMS3wbBnKyebA1as8FEB8CHyk7w0puZOYOFTo8/9A8oj
         FGhdHFOLHQs7D9BZ3uphAChWub5OeOBn7F/GO7Z8WdF1B4v9rwG/yUXgAxSW96dAyy
         4R9NUVPMUsNgAPKaxbMt3v85Fdhc8qQ+YBO7RHY2TDXTRZX0KmGlfdHS6gs0yFVz0v
         KgSEmW18n9y7KuKpNZA3kl2EJypsdKDPBjmI96fVzon5RE54Cflgs0kIlbRJ/9T3SC
         z9rD6/cH2T2waG4Id+Ag1ClAWoTImrES3wTkWhVzvjRDC9styZtq80sVqhjuWr8yRq
         ky2onrStAcWfw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Armin Wolf <W_Armin@gmx.de>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, jdelvare@suse.com,
        linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 39/45] hwmon: (dell-smm) Add Dell XPS 13 7390 to fan control whitelist
Date:   Sun,  7 Aug 2022 21:35:43 -0400
Message-Id: <20220808013551.315446-39-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013551.315446-1-sashal@kernel.org>
References: <20220808013551.315446-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 385e5f57053ff293282fea84c1c27186d53f66e1 ]

A user reported that the program dell-bios-fan-control
worked on his Dell XPS 13 7390 to switch off automatic
fan control.
Since it uses the same mechanism as the dell_smm_hwmon
module, add this model to the fan control whitelist.

Compile-tested only.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Acked-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/20220612041806.11367-1-W_Armin@gmx.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/dell-smm-hwmon.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
index 9cb1c3588038..597cbb4391bd 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -1198,6 +1198,14 @@ static const struct dmi_system_id i8k_whitelist_fan_control[] __initconst = {
 		},
 		.driver_data = (void *)&i8k_fan_control_data[I8K_FAN_34A3_35A3],
 	},
+	{
+		.ident = "Dell XPS 13 7390",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "XPS 13 7390"),
+		},
+		.driver_data = (void *)&i8k_fan_control_data[I8K_FAN_34A3_35A3],
+	},
 	{ }
 };
 
-- 
2.35.1

