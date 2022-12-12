Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EACCF64A159
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbiLLNjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbiLLNif (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:38:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68080DF4A
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:37:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24AB6B8068B
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:37:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C3AC433F0;
        Mon, 12 Dec 2022 13:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852271;
        bh=1RtQOr6Pm3gzyXCV3JM2ZfhuUTmH4IJTkWD3almcbfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ieayzy0/blVVhqJCNg1lmsanYMlXRZT1IWizVE8XuzN6vu7HIHM+x0nbezM+97vg1
         UeADhroFlQRByuvFxV3K3WPib10JV8+pwFu6kJ/uguY/LU5dntMrDW2rjE0pkYtn/s
         uhOeMEqvdHIGGKrgY8QOiqeNe5cv/gmtm6uHFBZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 048/157] soundwire: dmi-quirks: add remapping for HP Omen 16-k0005TX
Date:   Mon, 12 Dec 2022 14:16:36 +0100
Message-Id: <20221212130936.482261581@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit df55100551a34bddab02dff48d0296bda0659c02 ]

The DSDT for this device has a number of problems:
a) it lists rt711 on link0 and link1, but link1 is disabled
b) the rt711 entry on link0 uses the wrong v2 instead of v3 (SDCA)
c) the rt1316 amplifier on link3 is not listed.

Add a remapping table to work-around these BIOS shenanigans.

BugLink: https://github.com/thesofproject/sof/issues/5955
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20220823030919.2346629-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/dmi-quirks.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index 747983743a14..f81cdd83ec26 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -55,7 +55,26 @@ static const struct adr_remap dell_sku_0A3E[] = {
 	{}
 };
 
+/*
+ * The HP Omen 16-k0005TX does not expose the correct version of RT711 on link0
+ * and does not expose a RT1316 on link3
+ */
+static const struct adr_remap hp_omen_16[] = {
+	/* rt711-sdca on link0 */
+	{
+		0x000020025d071100ull,
+		0x000030025d071101ull
+	},
+	/* rt1316-sdca on link3 */
+	{
+		0x000120025d071100ull,
+		0x000330025d131601ull
+	},
+	{}
+};
+
 static const struct dmi_system_id adr_remap_quirk_table[] = {
+	/* TGL devices */
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
@@ -78,6 +97,14 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		},
 		.driver_data = (void *)dell_sku_0A3E,
 	},
+	/* ADL devices */
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OMEN by HP Gaming Laptop 16-k0xxx"),
+		},
+		.driver_data = (void *)hp_omen_16,
+	},
 	{}
 };
 
-- 
2.35.1



