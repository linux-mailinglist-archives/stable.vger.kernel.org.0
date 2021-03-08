Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F092330DC5
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbhCHMcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:32:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:41054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229740AbhCHMcA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:32:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6142A651CF;
        Mon,  8 Mar 2021 12:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206720;
        bh=A7whDS/huC6IqXvMk/E6oHM1FWrNzq5JIjxngeEa64c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FkHEtVHeYxpSbp4mwyFpbu1Nhg4ijMJFddfzUgRrIexAduKsFqmYBN7XvYxK+/0vD
         QoqK+y6kW5A+7nx84pX4qTdV8SEnPUmfCK1DQ9hka5fSMfeVSYdbrdebtlAO07Uj5P
         0CUtdLmK+CHJ/0F2lTs4E3IOqD6999w4pFBOIb0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 19/22] ALSA: hda: intel-nhlt: verify config type
Date:   Mon,  8 Mar 2021 13:30:36 +0100
Message-Id: <20210308122715.326648429@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122714.391917404@linuxfoundation.org>
References: <20210308122714.391917404@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit a864e8f159b13babf552aff14a5fbe11abc017e4 ]

Multiple bug reports report issues with the SOF and SST drivers when
dealing with single microphone cases.

We currently read the DMIC array information unconditionally but we
don't check that the configuration type is actually a mic array.

When the DMIC link does not rely on a mic array configuration, the
recommendation is to check the format information to infer the maximum
number of channels, and map this to the number of microphones.

This leaves a potential for a mismatch between actual microphones
available in hardware and what the ACPI table contains, but we have no
other source of information.

Note that single microphone configurations can alternatively be
handled with a 'mic array' configuration along with a 'vendor-defined'
geometry.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=201251
BugLink: https://github.com/thesofproject/linux/issues/2725
Fixes: 7a33ea70e1868 ('ALSA: hda: intel-nhlt: handle NHLT VENDOR_DEFINED DMIC geometry')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20210302000146.1177770-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/intel-nhlt.h |  5 ++++
 sound/hda/intel-nhlt.c     | 54 +++++++++++++++++++++++++++++++-------
 2 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/include/sound/intel-nhlt.h b/include/sound/intel-nhlt.h
index f657fd8fc0ad..f38947b9a1b9 100644
--- a/include/sound/intel-nhlt.h
+++ b/include/sound/intel-nhlt.h
@@ -112,6 +112,11 @@ struct nhlt_vendor_dmic_array_config {
 	/* TODO add vendor mic config */
 } __packed;
 
+enum {
+	NHLT_CONFIG_TYPE_GENERIC = 0,
+	NHLT_CONFIG_TYPE_MIC_ARRAY = 1
+};
+
 enum {
 	NHLT_MIC_ARRAY_2CH_SMALL = 0xa,
 	NHLT_MIC_ARRAY_2CH_BIG = 0xb,
diff --git a/sound/hda/intel-nhlt.c b/sound/hda/intel-nhlt.c
index daede96f28ee..baeda6c9716a 100644
--- a/sound/hda/intel-nhlt.c
+++ b/sound/hda/intel-nhlt.c
@@ -64,18 +64,44 @@ int intel_nhlt_get_dmic_geo(struct device *dev, struct nhlt_acpi_table *nhlt)
 	struct nhlt_endpoint *epnt;
 	struct nhlt_dmic_array_config *cfg;
 	struct nhlt_vendor_dmic_array_config *cfg_vendor;
+	struct nhlt_fmt *fmt_configs;
 	unsigned int dmic_geo = 0;
-	u8 j;
+	u16 max_ch = 0;
+	u8 i, j;
 
 	if (!nhlt)
 		return 0;
 
-	epnt = (struct nhlt_endpoint *)nhlt->desc;
+	for (j = 0, epnt = nhlt->desc; j < nhlt->endpoint_count; j++,
+	     epnt = (struct nhlt_endpoint *)((u8 *)epnt + epnt->length)) {
 
-	for (j = 0; j < nhlt->endpoint_count; j++) {
-		if (epnt->linktype == NHLT_LINK_DMIC) {
-			cfg = (struct nhlt_dmic_array_config  *)
-					(epnt->config.caps);
+		if (epnt->linktype != NHLT_LINK_DMIC)
+			continue;
+
+		cfg = (struct nhlt_dmic_array_config  *)(epnt->config.caps);
+		fmt_configs = (struct nhlt_fmt *)(epnt->config.caps + epnt->config.size);
+
+		/* find max number of channels based on format_configuration */
+		if (fmt_configs->fmt_count) {
+			dev_dbg(dev, "%s: found %d format definitions\n",
+				__func__, fmt_configs->fmt_count);
+
+			for (i = 0; i < fmt_configs->fmt_count; i++) {
+				struct wav_fmt_ext *fmt_ext;
+
+				fmt_ext = &fmt_configs->fmt_config[i].fmt_ext;
+
+				if (fmt_ext->fmt.channels > max_ch)
+					max_ch = fmt_ext->fmt.channels;
+			}
+			dev_dbg(dev, "%s: max channels found %d\n", __func__, max_ch);
+		} else {
+			dev_dbg(dev, "%s: No format information found\n", __func__);
+		}
+
+		if (cfg->device_config.config_type != NHLT_CONFIG_TYPE_MIC_ARRAY) {
+			dmic_geo = max_ch;
+		} else {
 			switch (cfg->array_type) {
 			case NHLT_MIC_ARRAY_2CH_SMALL:
 			case NHLT_MIC_ARRAY_2CH_BIG:
@@ -92,13 +118,23 @@ int intel_nhlt_get_dmic_geo(struct device *dev, struct nhlt_acpi_table *nhlt)
 				dmic_geo = cfg_vendor->nb_mics;
 				break;
 			default:
-				dev_warn(dev, "undefined DMIC array_type 0x%0x\n",
-					 cfg->array_type);
+				dev_warn(dev, "%s: undefined DMIC array_type 0x%0x\n",
+					 __func__, cfg->array_type);
+			}
+
+			if (dmic_geo > 0) {
+				dev_dbg(dev, "%s: Array with %d dmics\n", __func__, dmic_geo);
+			}
+			if (max_ch > dmic_geo) {
+				dev_dbg(dev, "%s: max channels %d exceed dmic number %d\n",
+					__func__, max_ch, dmic_geo);
 			}
 		}
-		epnt = (struct nhlt_endpoint *)((u8 *)epnt + epnt->length);
 	}
 
+	dev_dbg(dev, "%s: dmic number %d max_ch %d\n",
+		__func__, dmic_geo, max_ch);
+
 	return dmic_geo;
 }
 EXPORT_SYMBOL_GPL(intel_nhlt_get_dmic_geo);
-- 
2.30.1



