Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9285D68D7F1
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjBGNEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbjBGNEq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:04:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830D83A587
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:04:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B5E26138B
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30466C433EF;
        Tue,  7 Feb 2023 13:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775070;
        bh=okTJjktsAdJcKD+G94UdziYTuM1lolPbXJebJVXsWdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jFbIbVaWmeEBb2AwpoZZUwkKzhfcPscXlMFGGJjLTvnvZ0EMwiLWZBDwrO3qh85NO
         c2oBQHbpqjH4qEkbwN//RhL3EmnESu6Jtw+2Hq4WiDuak9JwTgbW8l96DTpkF3IE8b
         TopKUEhgtCUcDqAEgs5wXmBjmcIWYYf/ookv/I2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 128/208] ASoC: SOF: sof-audio: skip prepare/unprepare if swidget is NULL
Date:   Tue,  7 Feb 2023 13:56:22 +0100
Message-Id: <20230207125640.215798028@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

commit 0ad84b11f2f8dd19d62d0b2ffd95ece897e6c3dc upstream.

Skip preparing/unpreparing widgets if the swidget pointer is NULL. This
will be true in the case of virtual widgets in topology that were added
for reusing the legacy HDA machine driver with SOF.

Fixes: 9862dcf70245 ("ASoC: SOF: don't unprepare widget used other pipelines")
Cc: <stable@vger.kernel.org> # 6.1
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230118101255.29139-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/sof-audio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/sof/sof-audio.c
+++ b/sound/soc/sof/sof-audio.c
@@ -272,7 +272,7 @@ sof_unprepare_widgets_in_path(struct snd
 	struct snd_soc_dapm_path *p;
 
 	/* return if the widget is in use or if it is already unprepared */
-	if (!swidget->prepared || swidget->use_count > 0)
+	if (!swidget || !swidget->prepared || swidget->use_count > 0)
 		return;
 
 	if (widget_ops[widget->id].ipc_unprepare)
@@ -303,7 +303,7 @@ sof_prepare_widgets_in_path(struct snd_s
 	struct snd_soc_dapm_path *p;
 	int ret;
 
-	if (!widget_ops[widget->id].ipc_prepare || swidget->prepared)
+	if (!swidget || !widget_ops[widget->id].ipc_prepare || swidget->prepared)
 		goto sink_prepare;
 
 	/* prepare the source widget */


