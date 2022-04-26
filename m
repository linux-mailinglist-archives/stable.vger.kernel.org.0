Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B3E50F7B1
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347242AbiDZJOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346597AbiDZJLd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:11:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D4A18073D;
        Tue, 26 Apr 2022 01:49:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EEB5B81CF2;
        Tue, 26 Apr 2022 08:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69A4C385A4;
        Tue, 26 Apr 2022 08:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962977;
        bh=UWC72dGlqRXg6M7M3WA8IxxrcfepfpHwL+5g3PuDktc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E5d8wj8CJINQvRxmnGUXDGDAkbud3+Nt9iyxhBZDZyH/yfW5id9F60CyPM8S87gQo
         mShdhonId5OMB+eph8OJDHaQ+SaoaJ8EzYt8ITA8dXQiHRwPYQnB04wIQluTDOAklh
         mzJZBrjt3miAG2Jmmrwf3aL6kxnnjl4eln1zCUx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.17 144/146] ASoC: SOF: topology: cleanup dailinks on widget unload
Date:   Tue, 26 Apr 2022 10:22:19 +0200
Message-Id: <20220426081754.107256382@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

commit 20744617bdbafe2e7fb7bf5401f616e24bde4471 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/topology.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -1569,6 +1569,46 @@ static int sof_widget_load_buffer(struct
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
@@ -2449,6 +2489,9 @@ static int sof_widget_unload(struct snd_
 			kfree(dai->dai_config);
 			list_del(&dai->list);
 		}
+
+		sof_disconnect_dai_widget(scomp, widget);
+
 		break;
 	default:
 		break;


