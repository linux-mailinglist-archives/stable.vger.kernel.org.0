Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 589434F2DEC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355481AbiDEKUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345264AbiDEJWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:22:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED2D3FBFC;
        Tue,  5 Apr 2022 02:10:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB0FB61576;
        Tue,  5 Apr 2022 09:10:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB561C385A2;
        Tue,  5 Apr 2022 09:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149804;
        bh=zDnDnqnkUnkvRiU0Bpg3UFg6AFN8i60eOTOfhbTGywk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gNWlgUft0Pfa0IYpiY3nbrX0zcWgfc4nx0pqX/uqsUnBc8xvAqoE5VSDJ4PdIpw2M
         BZkpdEs+iBIGEl+vnepW1cNAi3CPZwLUNx+UuloGe13sFkur30Db4ew2x8hJZgAMCJ
         o2xLRM4EzyufMDh6D+TvYE3lBF1lyiHKfZAljPJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rander Wang <rander.wang@intel.com>,
        Anthony I Gilea <i@cpp.in>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0848/1017] ASoC: Intel: sof_sdw: fix quirks for 2022 HP Spectre x360 13"
Date:   Tue,  5 Apr 2022 09:29:21 +0200
Message-Id: <20220405070419.410977809@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anthony I Gilea <i@cpp.in>

[ Upstream commit ce73ef6ec67104d1fcc4c5911d77ce83288a0998 ]

HP changed the DMI identification for 2022 devices:
Product Name: HP Spectre x360 Conv 13-ap0001na
Product Name: 8709
This patch relaxes the DMI_MATCH criterion to work with all versions of this product.

Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Anthony I Gilea <i@cpp.in>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220304204532.54675-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/dmi-quirks.c   | 2 +-
 sound/soc/intel/boards/sof_sdw.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index 0ca2a3e3a02e..747983743a14 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -59,7 +59,7 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP Spectre x360 Convertible"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Spectre x360 Conv"),
 		},
 		.driver_data = (void *)intel_tgl_bios,
 	},
diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 54eefaff62a7..182e23bc2f34 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -184,7 +184,7 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 		.callback = sof_sdw_quirk_cb,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP Spectre x360 Convertible"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Spectre x360 Conv"),
 		},
 		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
 					SOF_SDW_PCH_DMIC |
-- 
2.34.1



