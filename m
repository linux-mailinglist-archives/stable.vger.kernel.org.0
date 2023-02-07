Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7B768D7F2
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbjBGNEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbjBGNEp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:04:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F683A598
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:04:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32E4661407
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:04:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453C3C433D2;
        Tue,  7 Feb 2023 13:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775067;
        bh=6pjUSuhAj9MlD6LYSGoLgPVu1Q8/WKJinH8jLawIQSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MGrVnL+CEndWRnz0tiyhajk3X5lp+z3dKHxUP2+jHB/046kDNL5Vs6L9v00QrUtvC
         F0akicXM5rJjR/Fs6xP65H+TKm0iByEvRycDqYpRFpN7jcRKaIyrbdqlK8iiWmzLmw
         JqE8AghIAnqK2CXnaZcEA7ys5rORwbGlaUQAycd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 127/208] ASoC: SOF: sof-audio: unprepare when swidget->use_count > 0
Date:   Tue,  7 Feb 2023 13:56:21 +0100
Message-Id: <20230207125640.163465376@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

commit 7d2a67e02549c4b1feaac4d8b4151bf46424a047 upstream.

We should unprepare the widget if its use_count = 1.

Fixes: 9862dcf70245 ("ASoC: SOF: don't unprepare widget used other pipelines")
Cc: <stable@vger.kernel.org> # 6.1
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230118101255.29139-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/sof-audio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/sof-audio.c b/sound/soc/sof/sof-audio.c
index 7306a2649857..e52ef62ce7a3 100644
--- a/sound/soc/sof/sof-audio.c
+++ b/sound/soc/sof/sof-audio.c
@@ -272,7 +272,7 @@ sof_unprepare_widgets_in_path(struct snd_sof_dev *sdev, struct snd_soc_dapm_widg
 	struct snd_soc_dapm_path *p;
 
 	/* return if the widget is in use or if it is already unprepared */
-	if (!swidget->prepared || swidget->use_count > 1)
+	if (!swidget->prepared || swidget->use_count > 0)
 		return;
 
 	if (widget_ops[widget->id].ipc_unprepare)
-- 
2.39.1



