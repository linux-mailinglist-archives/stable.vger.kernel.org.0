Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3103690642
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjBILPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjBILPH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:15:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9FA12F32;
        Thu,  9 Feb 2023 03:15:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5460619E8;
        Thu,  9 Feb 2023 11:15:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB667C433EF;
        Thu,  9 Feb 2023 11:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941305;
        bh=hdPfRMb20l+xwrfZASQljOQ8K9xia2XjTXdmlaqGXKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AXFgF7taFILymsaOPA1b0K/ezDdfPtjCm3+DOmeJHllC6FWqY5714Api6taT+SbQY
         NA1W41fmX4vlAR/QqIEei0A8oqH/dsBHmhcGB/ldr8sokVbxuhVUyllJ/i1FUU1C2c
         jkCtpuBAFkM6nJWMn+V8ulxSKirBOYX6QInqdyrJAyKBXr39AFMOgHFChvcfi46lX8
         eCpqwyD7MnyMbeqtg5VxwWyOkgjFdInwjhgDgF2i0i/Rm6F4/LlNuL89iWnN+tGk5n
         d/3/GR/unKfyoAYJw6Vt1k5TuByDnNAYEqVzJz552P5qANkBjnKzzE9T3TVS40FdJo
         Ff5enGcwp/z9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bard Liao <yung-chuan.liao@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        daniel.baluta@nxp.com, perex@perex.cz, tiwai@suse.com,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.1 02/38] ASoC: SOF: sof-audio: start with the right widget type
Date:   Thu,  9 Feb 2023 06:14:21 -0500
Message-Id: <20230209111459.1891941-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111459.1891941-1-sashal@kernel.org>
References: <20230209111459.1891941-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit fcc4348adafe53928fda46d104c1798e5a4de4ff ]

If there is a connection between a playback stream and a capture stream,
all widgets that are connected to the playback stream and the capture
stream will be in the list.
So, we have to start with the exactly right widget type.
snd_soc_dapm_aif_out is for capture stream and a playback stream should
start with a snd_soc_dapm_aif_in widget.
Contrarily, snd_soc_dapm_dai_in is for playback stream, and a capture
stream should start with a snd_soc_dapm_dai_out widget.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230117123534.2075-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/sof-audio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/sof-audio.c b/sound/soc/sof/sof-audio.c
index 62092e2d609c7..bb92d8c8fbce6 100644
--- a/sound/soc/sof/sof-audio.c
+++ b/sound/soc/sof/sof-audio.c
@@ -429,11 +429,11 @@ sof_walk_widgets_in_order(struct snd_sof_dev *sdev, struct snd_soc_dapm_widget_l
 
 	for_each_dapm_widgets(list, i, widget) {
 		/* starting widget for playback is AIF type */
-		if (dir == SNDRV_PCM_STREAM_PLAYBACK && !WIDGET_IS_AIF(widget->id))
+		if (dir == SNDRV_PCM_STREAM_PLAYBACK && widget->id != snd_soc_dapm_aif_in)
 			continue;
 
 		/* starting widget for capture is DAI type */
-		if (dir == SNDRV_PCM_STREAM_CAPTURE && !WIDGET_IS_DAI(widget->id))
+		if (dir == SNDRV_PCM_STREAM_CAPTURE && widget->id != snd_soc_dapm_dai_out)
 			continue;
 
 		switch (op) {
-- 
2.39.0

