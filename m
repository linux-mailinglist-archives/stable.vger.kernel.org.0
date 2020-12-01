Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67FBC2C9B67
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389174AbgLAJIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:08:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:45100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389156AbgLAJH6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:07:58 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2C7A221EB;
        Tue,  1 Dec 2020 09:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813631;
        bh=VcHTaTZTIy5sMb2uWoGJMjc6LH/YiwMBSLMH/Mwwfak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/kDJbk/c3DjGF+LoP62pWkYnhzvAz2vSXiVGy2hwG5iZlxICA13oKJI/B5KsV1bB
         aEVPe42nb0Yw6bKG497+Z9EpyRPZ7V6RLwS134eyVwOl2oDPIVuz69yvyC9KEaMgGN
         FaR0DEcC99JuGy9D7d8A86/Tmi7EukxUHDbVuYug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mateusz Gorski <mateusz.gorski@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 98/98] ASoC: Intel: Skylake: Automatic DMIC format configuration according to information from NHLT
Date:   Tue,  1 Dec 2020 09:54:15 +0100
Message-Id: <20201201084659.875083307@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mateusz Gorski <mateusz.gorski@linux.intel.com>

commit 2d744ecf2b98405723a2138a547e5c75009bc4e5 upstream.

Automatically choose DMIC pipeline format configuration depending on
information included in NHLT.
Change the access rights of appropriate kcontrols to read-only in order
to prevent user interference.

Signed-off-by: Mateusz Gorski <mateusz.gorski@linux.intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200427132727.24942-4-mateusz.gorski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/sound/skl-tplg-interface.h |    1 
 sound/soc/intel/skylake/skl-topology.c  |   64 ++++++++++++++++++++++++++++++--
 2 files changed, 62 insertions(+), 3 deletions(-)

--- a/include/uapi/sound/skl-tplg-interface.h
+++ b/include/uapi/sound/skl-tplg-interface.h
@@ -19,6 +19,7 @@
 #define SKL_CONTROL_TYPE_BYTE_TLV	0x100
 #define SKL_CONTROL_TYPE_MIC_SELECT	0x102
 #define SKL_CONTROL_TYPE_MULTI_IO_SELECT	0x103
+#define SKL_CONTROL_TYPE_MULTI_IO_SELECT_DMIC	0x104
 
 #define HDA_SST_CFG_MAX	900 /* size of copier cfg*/
 #define MAX_IN_QUEUE 8
--- a/sound/soc/intel/skylake/skl-topology.c
+++ b/sound/soc/intel/skylake/skl-topology.c
@@ -1405,6 +1405,18 @@ static int skl_tplg_multi_config_set(str
 	return skl_tplg_multi_config_set_get(kcontrol, ucontrol, true);
 }
 
+static int skl_tplg_multi_config_get_dmic(struct snd_kcontrol *kcontrol,
+					  struct snd_ctl_elem_value *ucontrol)
+{
+	return skl_tplg_multi_config_set_get(kcontrol, ucontrol, false);
+}
+
+static int skl_tplg_multi_config_set_dmic(struct snd_kcontrol *kcontrol,
+					  struct snd_ctl_elem_value *ucontrol)
+{
+	return skl_tplg_multi_config_set_get(kcontrol, ucontrol, true);
+}
+
 static int skl_tplg_tlv_control_get(struct snd_kcontrol *kcontrol,
 			unsigned int __user *data, unsigned int size)
 {
@@ -1949,6 +1961,11 @@ static const struct snd_soc_tplg_kcontro
 		.get = skl_tplg_multi_config_get,
 		.put = skl_tplg_multi_config_set,
 	},
+	{
+		.id = SKL_CONTROL_TYPE_MULTI_IO_SELECT_DMIC,
+		.get = skl_tplg_multi_config_get_dmic,
+		.put = skl_tplg_multi_config_set_dmic,
+	}
 };
 
 static int skl_tplg_fill_pipe_cfg(struct device *dev,
@@ -3109,12 +3126,21 @@ static int skl_tplg_control_load(struct
 	case SND_SOC_TPLG_CTL_ENUM:
 		tplg_ec = container_of(hdr,
 				struct snd_soc_tplg_enum_control, hdr);
-		if (kctl->access & SNDRV_CTL_ELEM_ACCESS_READWRITE) {
+		if (kctl->access & SNDRV_CTL_ELEM_ACCESS_READ) {
 			se = (struct soc_enum *)kctl->private_value;
 			if (tplg_ec->priv.size)
-				return skl_init_enum_data(bus->dev, se,
-						tplg_ec);
+				skl_init_enum_data(bus->dev, se, tplg_ec);
 		}
+
+		/*
+		 * now that the control initializations are done, remove
+		 * write permission for the DMIC configuration enums to
+		 * avoid conflicts between NHLT settings and user interaction
+		 */
+
+		if (hdr->ops.get == SKL_CONTROL_TYPE_MULTI_IO_SELECT_DMIC)
+			kctl->access = SNDRV_CTL_ELEM_ACCESS_READ;
+
 		break;
 
 	default:
@@ -3584,6 +3610,37 @@ static int skl_manifest_load(struct snd_
 	return 0;
 }
 
+static void skl_tplg_complete(struct snd_soc_component *component)
+{
+	struct snd_soc_dobj *dobj;
+	struct snd_soc_acpi_mach *mach =
+		dev_get_platdata(component->card->dev);
+	int i;
+
+	list_for_each_entry(dobj, &component->dobj_list, list) {
+		struct snd_kcontrol *kcontrol = dobj->control.kcontrol;
+		struct soc_enum *se =
+			(struct soc_enum *)kcontrol->private_value;
+		char **texts = dobj->control.dtexts;
+		char chan_text[4];
+
+		if (dobj->type != SND_SOC_DOBJ_ENUM ||
+		    dobj->control.kcontrol->put !=
+		    skl_tplg_multi_config_set_dmic)
+			continue;
+		sprintf(chan_text, "c%d", mach->mach_params.dmic_num);
+
+		for (i = 0; i < se->items; i++) {
+			struct snd_ctl_elem_value val;
+
+			if (strstr(texts[i], chan_text)) {
+				val.value.enumerated.item[0] = i;
+				kcontrol->put(kcontrol, &val);
+			}
+		}
+	}
+}
+
 static struct snd_soc_tplg_ops skl_tplg_ops  = {
 	.widget_load = skl_tplg_widget_load,
 	.control_load = skl_tplg_control_load,
@@ -3593,6 +3650,7 @@ static struct snd_soc_tplg_ops skl_tplg_
 	.io_ops_count = ARRAY_SIZE(skl_tplg_kcontrol_ops),
 	.manifest = skl_manifest_load,
 	.dai_load = skl_dai_load,
+	.complete = skl_tplg_complete,
 };
 
 /*


