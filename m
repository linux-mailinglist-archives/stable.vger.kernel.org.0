Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 970B260897A
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234062AbiJVIgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234449AbiJVIfb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:35:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E391DDCD;
        Sat, 22 Oct 2022 01:04:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8978D60B81;
        Sat, 22 Oct 2022 08:03:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C03BC433C1;
        Sat, 22 Oct 2022 08:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425798;
        bh=iRWAp7mT/u5ZsntRpuy7Qz6GdmF0Etd7XBAveRikPHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MlrJHRm5pnas+PVRJjzU5xzxQzREXur+3HD4Ve7kXagmam+fwtRT35nY2whMHLBRK
         0PoFRWfBfBfcZCIl+dJRGNl22GZpjvW0O/aBx4MMV347yE1Piywu6LpoVPRsLTKSKX
         aA102eee8ljdzc4lQnfS5hzAgRPpLC7sJVniDyH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 618/717] ASoC: SOF: add quirk to override topology mclk_id
Date:   Sat, 22 Oct 2022 09:28:17 +0200
Message-Id: <20221022072525.787620162@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit d136949dd8e2e309dc2f186507486b71cbe9acdb ]

Some Intel-based platforms rely on a topology file that hard-codes the
use of MCLK0. This is incorrect in 10% of the cases. Rather than
generating yet another set of topology files, this patch adds a kernel
module parameter to override the topology value.

In hindsight, we should never have allowed mclks to be specified in
topology, this is a hardware-level information that should not have
been visible in the topology.

Future patches will try to set this value automagically, e.g. by
parsing the NHLT content.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20220919115350.43104-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda.c     | 11 +++++++++++
 sound/soc/sof/ipc3-topology.c |  7 +++++++
 sound/soc/sof/sof-priv.h      |  4 ++++
 3 files changed, 22 insertions(+)

diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index 17f2f3a982c3..7d9e62ab9d0e 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -376,6 +376,10 @@ static int dmic_num_override = -1;
 module_param_named(dmic_num, dmic_num_override, int, 0444);
 MODULE_PARM_DESC(dmic_num, "SOF HDA DMIC number");
 
+static int mclk_id_override = -1;
+module_param_named(mclk_id, mclk_id_override, int, 0444);
+MODULE_PARM_DESC(mclk_id, "SOF SSP mclk_id");
+
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA)
 static bool hda_codec_use_common_hdmi = IS_ENABLED(CONFIG_SND_HDA_CODEC_HDMI);
 module_param_named(use_common_hdmi, hda_codec_use_common_hdmi, bool, 0444);
@@ -1433,6 +1437,13 @@ struct snd_soc_acpi_mach *hda_machine_select(struct snd_sof_dev *sdev)
 
 			sof_pdata->tplg_filename = tplg_filename;
 		}
+
+		/* check if mclk_id should be modified from topology defaults */
+		if (mclk_id_override >= 0) {
+			dev_info(sdev->dev, "Overriding topology with MCLK %d from kernel_parameter\n", mclk_id_override);
+			sdev->mclk_id_override = true;
+			sdev->mclk_id_quirk = mclk_id_override;
+		}
 	}
 
 	/*
diff --git a/sound/soc/sof/ipc3-topology.c b/sound/soc/sof/ipc3-topology.c
index e97f50d5bcba..b8ec302bc887 100644
--- a/sound/soc/sof/ipc3-topology.c
+++ b/sound/soc/sof/ipc3-topology.c
@@ -1233,6 +1233,7 @@ static int sof_link_afe_load(struct snd_soc_component *scomp, struct snd_sof_dai
 static int sof_link_ssp_load(struct snd_soc_component *scomp, struct snd_sof_dai_link *slink,
 			     struct sof_ipc_dai_config *config, struct snd_sof_dai *dai)
 {
+	struct snd_sof_dev *sdev = snd_soc_component_get_drvdata(scomp);
 	struct snd_soc_tplg_hw_config *hw_config = slink->hw_configs;
 	struct sof_dai_private_data *private = dai->private;
 	u32 size = sizeof(*config);
@@ -1257,6 +1258,12 @@ static int sof_link_ssp_load(struct snd_soc_component *scomp, struct snd_sof_dai
 
 		config[i].hdr.size = size;
 
+		if (sdev->mclk_id_override) {
+			dev_dbg(scomp->dev, "tplg: overriding topology mclk_id %d by quirk %d\n",
+				config[i].ssp.mclk_id, sdev->mclk_id_quirk);
+			config[i].ssp.mclk_id = sdev->mclk_id_quirk;
+		}
+
 		/* copy differentiating hw configs to ipc structs */
 		config[i].ssp.mclk_rate = le32_to_cpu(hw_config[i].mclk_rate);
 		config[i].ssp.bclk_rate = le32_to_cpu(hw_config[i].bclk_rate);
diff --git a/sound/soc/sof/sof-priv.h b/sound/soc/sof/sof-priv.h
index f11f575fd1da..544e5be9d10e 100644
--- a/sound/soc/sof/sof-priv.h
+++ b/sound/soc/sof/sof-priv.h
@@ -585,6 +585,10 @@ struct snd_sof_dev {
 	/* to protect the ipc_rx_handler_list  and  dsp_state_handler_list list */
 	struct mutex client_event_handler_mutex;
 
+	/* quirks to override topology values */
+	bool mclk_id_override;
+	u16  mclk_id_quirk; /* same size as in IPC3 definitions */
+
 	void *private;			/* core does not touch this */
 };
 
-- 
2.35.1



