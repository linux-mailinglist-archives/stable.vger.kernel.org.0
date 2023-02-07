Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B246C68D100
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 08:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbjBGHw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 02:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbjBGHwY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 02:52:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6DB3525D
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 23:52:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D741561166
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 07:52:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0E0C433EF;
        Tue,  7 Feb 2023 07:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675756337;
        bh=9YvQUZQV1zpJBiE0XLi+XTYex1wOpfmLbT4VILIf8Is=;
        h=Subject:To:Cc:From:Date:From;
        b=C9vIHJlxDfpvHYMxFtBwIWDHtwaG+gQnJBQyh1GLPERNrGYSxYK9rdfABfMI4S6ij
         aST1FRXocqHC/E/QFpffoXatqW5nqxoLv4A/ird4Ep5lc9k8yjrjuheLcrc5qkWxb2
         d0d2hNEGavMINBsDZRDidPbO17MfGaYfWJigye48=
Subject: FAILED: patch "[PATCH] ASoC: SOF: keep prepare/unprepare widgets in sink path" failed to apply to 6.1-stable tree
To:     yung-chuan.liao@linux.intel.com, broonie@kernel.org,
        peter.ujfalusi@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, rander.wang@intel.com,
        ranjani.sridharan@linux.intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Feb 2023 08:52:14 +0100
Message-ID: <1675756334196160@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

cc755b4377b0 ("ASoC: SOF: keep prepare/unprepare widgets in sink path")
0ad84b11f2f8 ("ASoC: SOF: sof-audio: skip prepare/unprepare if swidget is NULL")
7d2a67e02549 ("ASoC: SOF: sof-audio: unprepare when swidget->use_count > 0")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cc755b4377b0520d594ae573497cf0824baea648 Mon Sep 17 00:00:00 2001
From: Bard Liao <yung-chuan.liao@linux.intel.com>
Date: Wed, 18 Jan 2023 12:12:55 +0200
Subject: [PATCH] ASoC: SOF: keep prepare/unprepare widgets in sink path

The existing code return when a widget doesn't need to
prepare/unprepare. This will prevent widgets in the sink path from being
prepared/unprepared.

Cc: <stable@vger.kernel.org> # 6.1
Link: https://github.com/thesofproject/linux/issues/4021
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230118101255.29139-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/sound/soc/sof/sof-audio.c b/sound/soc/sof/sof-audio.c
index 8c114e6a23c6..ff716bfbcb67 100644
--- a/sound/soc/sof/sof-audio.c
+++ b/sound/soc/sof/sof-audio.c
@@ -271,9 +271,9 @@ sof_unprepare_widgets_in_path(struct snd_sof_dev *sdev, struct snd_soc_dapm_widg
 	struct snd_sof_widget *swidget = widget->dobj.private;
 	struct snd_soc_dapm_path *p;
 
-	/* return if the widget is in use or if it is already unprepared */
+	/* skip if the widget is in use or if it is already unprepared */
 	if (!swidget || !swidget->prepared || swidget->use_count > 0)
-		return;
+		goto sink_unprepare;
 
 	if (widget_ops[widget->id].ipc_unprepare)
 		/* unprepare the source widget */
@@ -281,6 +281,7 @@ sof_unprepare_widgets_in_path(struct snd_sof_dev *sdev, struct snd_soc_dapm_widg
 
 	swidget->prepared = false;
 
+sink_unprepare:
 	/* unprepare all widgets in the sink paths */
 	snd_soc_dapm_widget_for_each_sink_path(widget, p) {
 		if (!p->walking && p->sink->dobj.private) {

