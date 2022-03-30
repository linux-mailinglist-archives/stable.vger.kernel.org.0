Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 159FA4EC0AC
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344292AbiC3Lwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344237AbiC3Lvw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:51:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A082675A5;
        Wed, 30 Mar 2022 04:48:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30DEA615F5;
        Wed, 30 Mar 2022 11:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C028C3410F;
        Wed, 30 Mar 2022 11:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640890;
        bh=yPQlBLQGEvHpOmVboz3fBeiBvatZ09xFfJx8JBLUUOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eREUXjIDNpU33bJAEQnwHyNFXTaOXrvpy9Gw0GMZqevwI6bt1DGJhHEtFa+Nor+Ok
         0Kh7i4/SdayfBmfcbJ4rCIS6Pot3oafZLu2ohnWI+CVA19C2ZQvoamQEDPOShqafO2
         MTbCWkqAFDaR4T9a41n5moRljLJzUt68wOZro+pn+RyfZQRqrVkZeQSQpavvSJN72K
         n96fjbdu1vPbwqQiKZR6qpfPc4BDXy6uqdBrjye116FxTe8KEUW6iZN6A6RlGCtE2b
         yBvVthUs6n0y3pn6tBCBVRYXdulMBlgJAvYe9wQzHPo2Mbk++VgMReyigOIhy5K7Jc
         I7r8g6kNIKh4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.17 54/66] ALSA: intel-nhlt: add helper to detect SSP link mask
Date:   Wed, 30 Mar 2022 07:46:33 -0400
Message-Id: <20220330114646.1669334-54-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114646.1669334-1-sashal@kernel.org>
References: <20220330114646.1669334-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 0c470db0399e17310ed2ba54dd1c25cfa16ce0d3 ]

The NHLT information can be used to figure out which SSPs are enabled
in a platform.

The 'SSP' link type is too broad for machine drivers, since it can
cover the Bluetooth sideband and the analog audio codec connections,
so this helper exposes a parameter to filter with the device
type (DEVICE_I2S refers to analog audio codec in NHLT parlance).

The helper returns a mask, since more than one SSP may be used for
analog audio, e.g. the NHLT spec describes the use of SSP0 for
amplifiers and SSP1 for headset codec. Note that if more than one bit
is set, it's impossible to determine which SSP is connected to what
external component. Additional platform-specific information based on
e.g. DMI quirks would still be required in the machine driver to
configure the relevant dailinks.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Acked-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20220308192610.392950-5-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/intel-nhlt.h | 22 +++++++++++++++-------
 sound/hda/intel-nhlt.c     | 22 ++++++++++++++++++++++
 2 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/include/sound/intel-nhlt.h b/include/sound/intel-nhlt.h
index 089a760d36eb..6fb2d5e378fd 100644
--- a/include/sound/intel-nhlt.h
+++ b/include/sound/intel-nhlt.h
@@ -18,6 +18,13 @@ enum nhlt_link_type {
 	NHLT_LINK_INVALID
 };
 
+enum nhlt_device_type {
+	NHLT_DEVICE_BT = 0,
+	NHLT_DEVICE_DMIC = 1,
+	NHLT_DEVICE_I2S = 4,
+	NHLT_DEVICE_INVALID
+};
+
 #if IS_ENABLED(CONFIG_ACPI) && IS_ENABLED(CONFIG_SND_INTEL_NHLT)
 
 struct wav_fmt {
@@ -41,13 +48,6 @@ struct wav_fmt_ext {
 	u8 sub_fmt[16];
 } __packed;
 
-enum nhlt_device_type {
-	NHLT_DEVICE_BT = 0,
-	NHLT_DEVICE_DMIC = 1,
-	NHLT_DEVICE_I2S = 4,
-	NHLT_DEVICE_INVALID
-};
-
 struct nhlt_specific_cfg {
 	u32 size;
 	u8 caps[];
@@ -133,6 +133,9 @@ void intel_nhlt_free(struct nhlt_acpi_table *addr);
 int intel_nhlt_get_dmic_geo(struct device *dev, struct nhlt_acpi_table *nhlt);
 
 bool intel_nhlt_has_endpoint_type(struct nhlt_acpi_table *nhlt, u8 link_type);
+
+int intel_nhlt_ssp_endpoint_mask(struct nhlt_acpi_table *nhlt, u8 device_type);
+
 struct nhlt_specific_cfg *
 intel_nhlt_get_endpoint_blob(struct device *dev, struct nhlt_acpi_table *nhlt,
 			     u32 bus_id, u8 link_type, u8 vbps, u8 bps,
@@ -163,6 +166,11 @@ static inline bool intel_nhlt_has_endpoint_type(struct nhlt_acpi_table *nhlt,
 	return false;
 }
 
+static inline int intel_nhlt_ssp_endpoint_mask(struct nhlt_acpi_table *nhlt, u8 device_type)
+{
+	return 0;
+}
+
 static inline struct nhlt_specific_cfg *
 intel_nhlt_get_endpoint_blob(struct device *dev, struct nhlt_acpi_table *nhlt,
 			     u32 bus_id, u8 link_type, u8 vbps, u8 bps,
diff --git a/sound/hda/intel-nhlt.c b/sound/hda/intel-nhlt.c
index 128476aa7c61..4063da378283 100644
--- a/sound/hda/intel-nhlt.c
+++ b/sound/hda/intel-nhlt.c
@@ -130,6 +130,28 @@ bool intel_nhlt_has_endpoint_type(struct nhlt_acpi_table *nhlt, u8 link_type)
 }
 EXPORT_SYMBOL(intel_nhlt_has_endpoint_type);
 
+int intel_nhlt_ssp_endpoint_mask(struct nhlt_acpi_table *nhlt, u8 device_type)
+{
+	struct nhlt_endpoint *epnt;
+	int ssp_mask = 0;
+	int i;
+
+	if (!nhlt || (device_type != NHLT_DEVICE_BT && device_type != NHLT_DEVICE_I2S))
+		return 0;
+
+	epnt = (struct nhlt_endpoint *)nhlt->desc;
+	for (i = 0; i < nhlt->endpoint_count; i++) {
+		if (epnt->linktype == NHLT_LINK_SSP && epnt->device_type == device_type) {
+			/* for SSP the virtual bus id is the SSP port */
+			ssp_mask |= BIT(epnt->virtual_bus_id);
+		}
+		epnt = (struct nhlt_endpoint *)((u8 *)epnt + epnt->length);
+	}
+
+	return ssp_mask;
+}
+EXPORT_SYMBOL(intel_nhlt_ssp_endpoint_mask);
+
 static struct nhlt_specific_cfg *
 nhlt_get_specific_cfg(struct device *dev, struct nhlt_fmt *fmt, u8 num_ch,
 		      u32 rate, u8 vbps, u8 bps)
-- 
2.34.1

