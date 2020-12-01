Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9F12C9CF8
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389023AbgLAJHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:07:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389017AbgLAJHt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:07:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 142F022240;
        Tue,  1 Dec 2020 09:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813628;
        bh=72KAK+P2D/Jk5jDmi+rUWHPjZbHczSGCgI2x/CRmrLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=crenmsCAY22RliouyQcPN9DjKMR3yCh3XoJZ3qBU51xjaIe6aa8hdRCQr41rQEMKk
         ZI+Ow14N6F6SXuL7SMMebMJmtJg2m/vI8d1T7ztTel6n+J6DBHiKbyqszz3LKm64/R
         DbDtscq14WBsOhsqpawdN4E9l+TcJw/JMuYaF8F8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "alsa-devel@alsa-project.org, broonie@kernel.org, tiwai@suse.com,
        pierre-louis.bossart@linux.intel.com, mateusz.gorski@linux.intel.com,
        Pavan K S" <pavan.k.s@intel.com>,
        Mateusz Gorski <mateusz.gorski@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Pavan K S <pavan.k.s@intel.com>
Subject: [PATCH 5.4 97/98] ASoC: Intel: Multiple I/O PCM format support for pipe
Date:   Tue,  1 Dec 2020 09:54:14 +0100
Message-Id: <20201201084659.822145380@linuxfoundation.org>
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

commit 1b450791d517d4d6666ab9ab6d9a20c8819e3572 upstream.

For pipes supporting multiple input/output formats, kcontrol is
created and selection of pipe input and output configuration
is done based on control set.

If more than one configuration is supported, then this patch
allows user to select configuration of choice
using amixer settings.

Signed-off-by: Mateusz Gorski <mateusz.gorski@linux.intel.com>
Signed-off-by: Pavan K S <pavan.k.s@intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200427132727.24942-3-mateusz.gorski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/sound/skl-tplg-interface.h |    1 
 sound/soc/intel/skylake/skl-topology.c  |   95 ++++++++++++++++++++++++++++++++
 sound/soc/intel/skylake/skl-topology.h  |    1 
 3 files changed, 97 insertions(+)

--- a/include/uapi/sound/skl-tplg-interface.h
+++ b/include/uapi/sound/skl-tplg-interface.h
@@ -18,6 +18,7 @@
  */
 #define SKL_CONTROL_TYPE_BYTE_TLV	0x100
 #define SKL_CONTROL_TYPE_MIC_SELECT	0x102
+#define SKL_CONTROL_TYPE_MULTI_IO_SELECT	0x103
 
 #define HDA_SST_CFG_MAX	900 /* size of copier cfg*/
 #define MAX_IN_QUEUE 8
--- a/sound/soc/intel/skylake/skl-topology.c
+++ b/sound/soc/intel/skylake/skl-topology.c
@@ -579,6 +579,38 @@ static int skl_tplg_unload_pipe_modules(
 	return ret;
 }
 
+static bool skl_tplg_is_multi_fmt(struct skl_dev *skl, struct skl_pipe *pipe)
+{
+	struct skl_pipe_fmt *cur_fmt;
+	struct skl_pipe_fmt *next_fmt;
+	int i;
+
+	if (pipe->nr_cfgs <= 1)
+		return false;
+
+	if (pipe->conn_type != SKL_PIPE_CONN_TYPE_FE)
+		return true;
+
+	for (i = 0; i < pipe->nr_cfgs - 1; i++) {
+		if (pipe->direction == SNDRV_PCM_STREAM_PLAYBACK) {
+			cur_fmt = &pipe->configs[i].out_fmt;
+			next_fmt = &pipe->configs[i + 1].out_fmt;
+		} else {
+			cur_fmt = &pipe->configs[i].in_fmt;
+			next_fmt = &pipe->configs[i + 1].in_fmt;
+		}
+
+		if (!CHECK_HW_PARAMS(cur_fmt->channels, cur_fmt->freq,
+				     cur_fmt->bps,
+				     next_fmt->channels,
+				     next_fmt->freq,
+				     next_fmt->bps))
+			return true;
+	}
+
+	return false;
+}
+
 /*
  * Here, we select pipe format based on the pipe type and pipe
  * direction to determine the current config index for the pipeline.
@@ -601,6 +633,14 @@ skl_tplg_get_pipe_config(struct skl_dev
 		return 0;
 	}
 
+	if (skl_tplg_is_multi_fmt(skl, pipe)) {
+		pipe->cur_config_idx = pipe->pipe_config_idx;
+		pipe->memory_pages = pconfig->mem_pages;
+		dev_dbg(skl->dev, "found pipe config idx:%d\n",
+			pipe->cur_config_idx);
+		return 0;
+	}
+
 	if (pipe->conn_type == SKL_PIPE_CONN_TYPE_NONE) {
 		dev_dbg(skl->dev, "No conn_type detected, take 0th config\n");
 		pipe->cur_config_idx = 0;
@@ -1315,6 +1355,56 @@ static int skl_tplg_pga_event(struct snd
 	return 0;
 }
 
+static int skl_tplg_multi_config_set_get(struct snd_kcontrol *kcontrol,
+					 struct snd_ctl_elem_value *ucontrol,
+					 bool is_set)
+{
+	struct snd_soc_component *component =
+		snd_soc_kcontrol_component(kcontrol);
+	struct hdac_bus *bus = snd_soc_component_get_drvdata(component);
+	struct skl_dev *skl = bus_to_skl(bus);
+	struct skl_pipeline *ppl;
+	struct skl_pipe *pipe = NULL;
+	struct soc_enum *ec = (struct soc_enum *)kcontrol->private_value;
+	u32 *pipe_id;
+
+	if (!ec)
+		return -EINVAL;
+
+	if (is_set && ucontrol->value.enumerated.item[0] > ec->items)
+		return -EINVAL;
+
+	pipe_id = ec->dobj.private;
+
+	list_for_each_entry(ppl, &skl->ppl_list, node) {
+		if (ppl->pipe->ppl_id == *pipe_id) {
+			pipe = ppl->pipe;
+			break;
+		}
+	}
+	if (!pipe)
+		return -EIO;
+
+	if (is_set)
+		pipe->pipe_config_idx = ucontrol->value.enumerated.item[0];
+	else
+		ucontrol->value.enumerated.item[0]  =  pipe->pipe_config_idx;
+
+	return 0;
+}
+
+static int skl_tplg_multi_config_get(struct snd_kcontrol *kcontrol,
+				     struct snd_ctl_elem_value *ucontrol)
+{
+	return skl_tplg_multi_config_set_get(kcontrol, ucontrol, false);
+}
+
+static int skl_tplg_multi_config_set(struct snd_kcontrol *kcontrol,
+				     struct snd_ctl_elem_value *ucontrol)
+{
+	return skl_tplg_multi_config_set_get(kcontrol, ucontrol, true);
+}
+
 static int skl_tplg_tlv_control_get(struct snd_kcontrol *kcontrol,
 			unsigned int __user *data, unsigned int size)
 {
@@ -1854,6 +1944,11 @@ static const struct snd_soc_tplg_kcontro
 		.get = skl_tplg_mic_control_get,
 		.put = skl_tplg_mic_control_set,
 	},
+	{
+		.id = SKL_CONTROL_TYPE_MULTI_IO_SELECT,
+		.get = skl_tplg_multi_config_get,
+		.put = skl_tplg_multi_config_set,
+	},
 };
 
 static int skl_tplg_fill_pipe_cfg(struct device *dev,
--- a/sound/soc/intel/skylake/skl-topology.h
+++ b/sound/soc/intel/skylake/skl-topology.h
@@ -306,6 +306,7 @@ struct skl_pipe {
 	struct skl_path_config configs[SKL_MAX_PATH_CONFIGS];
 	struct list_head w_list;
 	bool passthru;
+	u32 pipe_config_idx;
 };
 
 enum skl_module_state {


