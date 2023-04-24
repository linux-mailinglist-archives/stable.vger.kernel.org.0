Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2589C6D4A29
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbjDCOoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233932AbjDCOo2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:44:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB53280CA
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:44:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC191B81D3A
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A2FC433D2;
        Mon,  3 Apr 2023 14:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533043;
        bh=NF73+SF7j9YISQK/gASqjbLfMarWGzD510ZGm33ElHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fnpjFGnwi2zaiKkEDUTEkMIP0mQ0YgaSQKOeDljbqGxZSILnkzh1UwXoRPfhz+kHb
         dxkANAO+29b3utDfG64IAYNASa1kf0uTcvM1qSgszUxSlJb2b1svty29dTJ1XnUSvu
         HGJbj6GHZX1+R/u8EWTzCNptS9RgPRLKRF9B99A0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rander Wang <rander.wang@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 033/187] ASoC: SOF: IPC4: update gain ipc msg definition to align with fw
Date:   Mon,  3 Apr 2023 16:07:58 +0200
Message-Id: <20230403140417.089022068@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rander Wang <rander.wang@intel.com>

[ Upstream commit e45cd86c3a78bfb9875a5eb8ab5dab459b59bbe2 ]

Recent firmware changes modified the curve duration from 32 to 64 bits,
which breaks volume ramps. A simple solution would be to change the
definition, but unfortunately the ASoC topology framework only supports
up to 32 bit tokens.

This patch suggests breaking the 64 bit value in low and high parts, with
only the low-part extracted from topology and high-part only zeroes. Since
the curve duration is represented in hundred of nanoseconds, we can still
represent a 400s ramp, which is just fine. The defacto ABI change has no
effect on existing users since the IPC4 firmware has not been released just
yet.

Link: https://github.com/thesofproject/linux/issues/4026

Signed-off-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230307110656.1816-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-control.c  | 3 ++-
 sound/soc/sof/ipc4-topology.c | 4 ++--
 sound/soc/sof/ipc4-topology.h | 6 ++++--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/sound/soc/sof/ipc4-control.c b/sound/soc/sof/ipc4-control.c
index 0d5a578c34962..7442ec1c5a4d4 100644
--- a/sound/soc/sof/ipc4-control.c
+++ b/sound/soc/sof/ipc4-control.c
@@ -84,7 +84,8 @@ sof_ipc4_set_volume_data(struct snd_sof_dev *sdev, struct snd_sof_widget *swidge
 		}
 
 		/* set curve type and duration from topology */
-		data.curve_duration = gain->data.curve_duration;
+		data.curve_duration_l = gain->data.curve_duration_l;
+		data.curve_duration_h = gain->data.curve_duration_h;
 		data.curve_type = gain->data.curve_type;
 
 		msg->data_ptr = &data;
diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index 65da1cf790d9c..6da6137fa2cbc 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -107,7 +107,7 @@ static const struct sof_topology_token gain_tokens[] = {
 		get_token_u32, offsetof(struct sof_ipc4_gain_data, curve_type)},
 	{SOF_TKN_GAIN_RAMP_DURATION,
 		SND_SOC_TPLG_TUPLE_TYPE_WORD, get_token_u32,
-		offsetof(struct sof_ipc4_gain_data, curve_duration)},
+		offsetof(struct sof_ipc4_gain_data, curve_duration_l)},
 	{SOF_TKN_GAIN_VAL, SND_SOC_TPLG_TUPLE_TYPE_WORD,
 		get_token_u32, offsetof(struct sof_ipc4_gain_data, init_val)},
 };
@@ -670,7 +670,7 @@ static int sof_ipc4_widget_setup_comp_pga(struct snd_sof_widget *swidget)
 
 	dev_dbg(scomp->dev,
 		"pga widget %s: ramp type: %d, ramp duration %d, initial gain value: %#x, cpc %d\n",
-		swidget->widget->name, gain->data.curve_type, gain->data.curve_duration,
+		swidget->widget->name, gain->data.curve_type, gain->data.curve_duration_l,
 		gain->data.init_val, gain->base_config.cpc);
 
 	ret = sof_ipc4_widget_setup_msg(swidget, &gain->msg);
diff --git a/sound/soc/sof/ipc4-topology.h b/sound/soc/sof/ipc4-topology.h
index 2363a7cc0b57d..cf9d278524572 100644
--- a/sound/soc/sof/ipc4-topology.h
+++ b/sound/soc/sof/ipc4-topology.h
@@ -217,14 +217,16 @@ struct sof_ipc4_control_data {
  * @init_val: Initial value
  * @curve_type: Curve type
  * @reserved: reserved for future use
- * @curve_duration: Curve duration
+ * @curve_duration_l: Curve duration low part
+ * @curve_duration_h: Curve duration high part
  */
 struct sof_ipc4_gain_data {
 	uint32_t channels;
 	uint32_t init_val;
 	uint32_t curve_type;
 	uint32_t reserved;
-	uint32_t curve_duration;
+	uint32_t curve_duration_l;
+	uint32_t curve_duration_h;
 } __aligned(8);
 
 /**
-- 
2.39.2



