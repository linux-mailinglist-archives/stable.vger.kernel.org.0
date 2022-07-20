Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B10057AD32
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238560AbiGTBZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242044AbiGTBY0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:24:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638DD6B243;
        Tue, 19 Jul 2022 18:17:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A15C8B81DE8;
        Wed, 20 Jul 2022 01:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCB2C341CB;
        Wed, 20 Jul 2022 01:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279842;
        bh=tW/gJQs5vhhcg05oS3FsA+HSeGfS/zpI5eAbBePP0A8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VvUfX535MHLg5U+MXFScFjcW4zrKxp09EKXxIn31HgTtJ4AEcW17geLs9zeLDFpt4
         JEooVOIT9/hQKyrdQ6qyvPtgSFI9wHQWoetHkz/cAfR3KmUD7jEQkanJP0GaBbCPi6
         6zLSXxUxOgOSG1TTadJcTVi+ZdRaWCM7mu1LZOqLWjllE2X7k4TfH9TXKNZdD6Co1A
         OMCcHhaxRwzOR2c5G15uZj5OsX5UnC91LHrzG58Vkz3tnB/7LEvtMWM8kApVxaYnnf
         YYeEx1TwPWOdn0xx9bt19bEuWj6JjE0r9kWObsUR5eDnSJfsOrZtDDqPVfxBmFICuo
         mZmxVeMypgEWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 22/25] platform/x86: intel_atomisp2_led: Also turn off the always-on camera LED on the Asus T100TAF
Date:   Tue, 19 Jul 2022 21:16:13 -0400
Message-Id: <20220720011616.1024753-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011616.1024753-1-sashal@kernel.org>
References: <20220720011616.1024753-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit b0d55983b2b885f6f96d6d6898d27a60bd9dc9a2 ]

Like the Asus T100TA the Asus T100TAF has a camera LED which is always
on by default and both also use the same GPIO for the LED.

Relax the DMI match for the Asus T100TA so that it also matches
the T100TAF.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220710173658.221528-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_atomisp2_led.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel_atomisp2_led.c b/drivers/platform/x86/intel_atomisp2_led.c
index 5935dfca166f..10077a61d8c5 100644
--- a/drivers/platform/x86/intel_atomisp2_led.c
+++ b/drivers/platform/x86/intel_atomisp2_led.c
@@ -50,7 +50,8 @@ static const struct dmi_system_id atomisp2_led_systems[] __initconst = {
 	{
 		.matches = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "T100TA"),
+			/* Non exact match to also match T100TAF */
+			DMI_MATCH(DMI_PRODUCT_NAME, "T100TA"),
 		},
 		.driver_data = &asus_t100ta_lookup,
 	},
-- 
2.35.1

