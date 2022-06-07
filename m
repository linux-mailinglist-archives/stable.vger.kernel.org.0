Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF83A5411F5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356710AbiFGTnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356776AbiFGTjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:39:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98B7FF583;
        Tue,  7 Jun 2022 11:14:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23EA060C1B;
        Tue,  7 Jun 2022 18:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F7CC385A2;
        Tue,  7 Jun 2022 18:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625667;
        bh=AblWjtA8CPTC3IoqQWt8yq7oRCv0iVKowhnhrwAHlr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z5znlLxSlTxhax7qU6lMxhLNa1AoRL41xOcBGQowaNyAlBJgn4cIz+CU/6J3rnkhF
         jry+RQiHm2zj4dovc9CQ0B8hU+04eaPNL3er9ukBv5aYukvXzelxELsaS7lqXY5NzC
         YbOY8V0/B217Ewsc9cG7WRSNcCA4cdJInkxAUHZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 100/772] ASoC: Intel: bytcr_rt5640: Add quirk for the HP Pro Tablet 408
Date:   Tue,  7 Jun 2022 18:54:52 +0200
Message-Id: <20220607164951.995428749@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit ce216cfa84a4e1c23b105e652c550bdeaac9e922 ]

Add a quirk for the HP Pro Tablet 408, this BYTCR tablet has no CHAN
package in its ACPI tables and uses SSP0-AIF1 rather then SSP0-AIF2 which
is the default for BYTCR devices.

It also uses DMIC1 for the internal mic rather then the default IN3
and it uses JD2 rather then the default JD1 for jack-detect.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=211485
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220427134918.527381-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index 2ace32c03ec9..b5ac226c59e1 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -773,6 +773,18 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 					BYT_RT5640_OVCD_SF_0P75 |
 					BYT_RT5640_MCLK_EN),
 	},
+	{	/* HP Pro Tablet 408 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pro Tablet 408"),
+		},
+		.driver_data = (void *)(BYT_RT5640_DMIC1_MAP |
+					BYT_RT5640_JD_SRC_JD2_IN4N |
+					BYT_RT5640_OVCD_TH_1500UA |
+					BYT_RT5640_OVCD_SF_0P75 |
+					BYT_RT5640_SSP0_AIF1 |
+					BYT_RT5640_MCLK_EN),
+	},
 	{	/* HP Stream 7 */
 		.matches = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-- 
2.35.1



