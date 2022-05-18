Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D4752BA8D
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 14:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236457AbiERM1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 08:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236487AbiERM1O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 08:27:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D1EAFB15;
        Wed, 18 May 2022 05:27:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D6F0B81FB6;
        Wed, 18 May 2022 12:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB71C34115;
        Wed, 18 May 2022 12:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876828;
        bh=ylNL2KoBbgg1rlNKg/jmvhK/PANiXZGeYbNkevaViIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JS9Npbuc7Jm6FwtiopPVD5EKXjbYS7qEsBlVir7X7MOnbDA0bW6s7svEQpLLi+uFW
         Y4iguSzszUm6coaUVH2vm6fFq/6ApLvRpeykim1HYzfCDrX9Hc0W+PqBrZNapsVUJw
         Kc/WiJQrTsp3ScdCA3VjSANsALaSq87rFXjST9KzZ/KVeooTKEXSfnfqI1Qai34SRq
         aJFE5+8pbTH2HMhB2R4qxA0WEXP0k04MPBcGO//OswkTBu8W6t1kLGJKmz/SmLvivJ
         pLYigroyt+flQXTGsK//pyofEj4DvQTTSDEpzjUn31pu7zHZHjjo9y35xzDPPlPQqv
         TkII8lg5iGcrQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Pearson <markpearson@lenovo.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, hmh@hmh.eng.br,
        markgross@kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 10/23] platform/x86: thinkpad_acpi: Correct dual fan probe
Date:   Wed, 18 May 2022 08:26:23 -0400
Message-Id: <20220518122641.342120-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122641.342120-1-sashal@kernel.org>
References: <20220518122641.342120-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Pearson <markpearson@lenovo.com>

[ Upstream commit aa2fef6f40e6ccc22e932b36898f260f0e5a021a ]

There was an issue with the dual fan probe whereby the probe was
failing as it assuming that second_fan support was not available.

Corrected the logic so the probe works correctly. Cleaned up so
quirks only used if 2nd fan not detected.

Tested on X1 Carbon 10 (2 fans), X1 Carbon 9 (2 fans) and T490 (1 fan)

Signed-off-by: Mark Pearson <markpearson@lenovo.com>
Link: https://lore.kernel.org/r/20220502191200.63470-1-markpearson@lenovo.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index c43586f1cb4b..0ea71416d292 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -8766,24 +8766,27 @@ static int __init fan_init(struct ibm_init_struct *iibm)
 			fan_status_access_mode = TPACPI_FAN_RD_TPEC;
 			if (quirks & TPACPI_FAN_Q1)
 				fan_quirk1_setup();
-			if (quirks & TPACPI_FAN_2FAN) {
-				tp_features.second_fan = 1;
-				pr_info("secondary fan support enabled\n");
-			}
-			if (quirks & TPACPI_FAN_2CTL) {
-				tp_features.second_fan = 1;
-				tp_features.second_fan_ctl = 1;
-				pr_info("secondary fan control enabled\n");
-			}
 			/* Try and probe the 2nd fan */
+			tp_features.second_fan = 1; /* needed for get_speed to work */
 			res = fan2_get_speed(&speed);
 			if (res >= 0) {
 				/* It responded - so let's assume it's there */
 				tp_features.second_fan = 1;
 				tp_features.second_fan_ctl = 1;
 				pr_info("secondary fan control detected & enabled\n");
+			} else {
+				/* Fan not auto-detected */
+				tp_features.second_fan = 0;
+				if (quirks & TPACPI_FAN_2FAN) {
+					tp_features.second_fan = 1;
+					pr_info("secondary fan support enabled\n");
+				}
+				if (quirks & TPACPI_FAN_2CTL) {
+					tp_features.second_fan = 1;
+					tp_features.second_fan_ctl = 1;
+					pr_info("secondary fan control enabled\n");
+				}
 			}
-
 		} else {
 			pr_err("ThinkPad ACPI EC access misbehaving, fan status and control unavailable\n");
 			return -ENODEV;
-- 
2.35.1

