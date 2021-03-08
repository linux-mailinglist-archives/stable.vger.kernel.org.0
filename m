Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E30330E6D
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhCHMhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:37:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:46542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232456AbhCHMgm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:36:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B097651FE;
        Mon,  8 Mar 2021 12:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615207001;
        bh=meF28bpp1bMOK/4wOzB8rinyF+2HdPI33StvLDGiRIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rwesRatIw2fajZ8PS8Rcq00moLwCtD1B3PFI6IVsqu8vacYVoIYt/tCVj/Fa+3rGK
         6Vo8e7Krp+rYWPpXL/XZSM81zJnzUZMvCCmpBEWPb756MvC6ioIGYb25SWfVR+E/C6
         AbNRgt277LfA35A8ocs+W5+irIAJTKRtVesF5ImY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 35/44] ALSA: hda: intel-nhlt: verify config type
Date:   Mon,  8 Mar 2021 13:35:13 +0100
Message-Id: <20210308122720.269854290@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
index 743c2f442280..d0574805865f 100644
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
index 059aaf04f536..d053beccfaec 100644
--- a/sound/hda/intel-nhlt.c
+++ b/sound/hda/intel-nhlt.c
@@ -31,18 +31,44 @@ int intel_nhlt_get_dmic_geo(struct device *dev, struct nhlt_acpi_table *nhlt)
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
@@ -59,13 +85,23 @@ int intel_nhlt_get_dmic_geo(struct device *dev, struct nhlt_acpi_table *nhlt)
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



