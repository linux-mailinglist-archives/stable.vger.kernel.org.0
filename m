Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3CC850E18D
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 15:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240408AbiDYN2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 09:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242024AbiDYN2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 09:28:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E650193D4
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 06:25:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1BF4B817A2
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 13:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558F0C385A7;
        Mon, 25 Apr 2022 13:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650893097;
        bh=g08VYlYm/LxkXaXh9jKTlHCxyR/0sNdKhezQ2W4PNfg=;
        h=Subject:To:Cc:From:Date:From;
        b=IkaG5f3CPQZvXTk746PVV19ETHPK9P1oeCpb2DjIdGCcHvoiGwjyVFqI8yFrZgc+V
         fYYQhXF1ZK0bQof6k1cUHrDi7lRoASZoH6h276Z/8sGvh6mbmxtkZgTFf5BSt098XC
         L72bhmuxcuRKinpvVGGHXMsrQAkvEwfK8YD+/DpE=
Subject: FAILED: patch "[PATCH] ASoC: SOF: topology: cleanup dailinks on widget unload" failed to apply to 5.4-stable tree
To:     pierre-louis.bossart@linux.intel.com, broonie@kernel.org,
        peter.ujfalusi@linux.intel.com, ranjani.sridharan@linux.intel.com,
        yung-chuan.liao@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Apr 2022 15:24:47 +0200
Message-ID: <165089308716236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 20744617bdbafe2e7fb7bf5401f616e24bde4471 Mon Sep 17 00:00:00 2001
From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Date: Wed, 6 Apr 2022 14:16:06 -0500
Subject: [PATCH] ASoC: SOF: topology: cleanup dailinks on widget unload
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We set the cpu_dai capture_ or playback_widget on widget_ready but
never clear them, which leads to failures when unloading/reloading a
topology in modprobe/rmmod tests

BugLink: https://github.com/thesofproject/linux/issues/3535
Fixes: 311ce4fe7637 ("ASoC: SOF: Add support for loading topologies")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20220406191606.254576-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index 75d78f9178a3..5953d1050cc9 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -1070,6 +1070,46 @@ static int sof_connect_dai_widget(struct snd_soc_component *scomp,
 	return 0;
 }
 
+static void sof_disconnect_dai_widget(struct snd_soc_component *scomp,
+				      struct snd_soc_dapm_widget *w)
+{
+	struct snd_soc_card *card = scomp->card;
+	struct snd_soc_pcm_runtime *rtd;
+	struct snd_soc_dai *cpu_dai;
+	int i;
+
+	if (!w->sname)
+		return;
+
+	list_for_each_entry(rtd, &card->rtd_list, list) {
+		/* does stream match DAI link ? */
+		if (!rtd->dai_link->stream_name ||
+		    strcmp(w->sname, rtd->dai_link->stream_name))
+			continue;
+
+		switch (w->id) {
+		case snd_soc_dapm_dai_out:
+			for_each_rtd_cpu_dais(rtd, i, cpu_dai) {
+				if (cpu_dai->capture_widget == w) {
+					cpu_dai->capture_widget = NULL;
+					break;
+				}
+			}
+			break;
+		case snd_soc_dapm_dai_in:
+			for_each_rtd_cpu_dais(rtd, i, cpu_dai) {
+				if (cpu_dai->playback_widget == w) {
+					cpu_dai->playback_widget = NULL;
+					break;
+				}
+			}
+			break;
+		default:
+			break;
+		}
+	}
+}
+
 /* bind PCM ID to host component ID */
 static int spcm_bind(struct snd_soc_component *scomp, struct snd_sof_pcm *spcm,
 		     int dir)
@@ -1355,6 +1395,9 @@ static int sof_widget_unload(struct snd_soc_component *scomp,
 
 		if (dai)
 			list_del(&dai->list);
+
+		sof_disconnect_dai_widget(scomp, widget);
+
 		break;
 	default:
 		break;

