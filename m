Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714C960411D
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbiJSKiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231919AbiJSKhq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:37:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B752152C51;
        Wed, 19 Oct 2022 03:16:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70799B82423;
        Wed, 19 Oct 2022 08:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2FBC4314C;
        Wed, 19 Oct 2022 08:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169761;
        bh=F1JXg42jhGfBnXQLzlro4hM3EZNVZO8juWCR9Pai+GE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1vPAX6LPzq7ksEAq05MpmOKaCU426zAiYwfC+EhuY9crPnQlyZfCWzBqymG5KCcTw
         WlO3snSaD2C1TEFo2Siy9UiEouokQxqMpBtBPfuzmE91mzyKNlVJpBdG3UEb1krLvJ
         rZbCqFASfsS46fW4ef/qFtWEYu+vk667YNtjKJGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 398/862] ASoC: SOF: ipc4-topology: Free the ida when IPC fails in sof_ipc4_widget_setup()
Date:   Wed, 19 Oct 2022 10:28:05 +0200
Message-Id: <20221019083307.525506018@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 61eb0add28023119773d6aab8f402e149473920c ]

The allocated ida needs to be freed up if the IPC message fails since
next time when we try again to set up the widget we are going to try to
allocate another ID and given enough tries, we are going to run out of
unique IDs.

Fixes: 711d0427c713 ("ASoC: SOF: ipc4-topology: move ida allocate/free to widget_setup/free")

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220921112751.9253-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-topology.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index 64929dc9af39..340d92452d7c 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -1544,9 +1544,16 @@ static int sof_ipc4_widget_setup(struct snd_sof_dev *sdev, struct snd_sof_widget
 	msg->data_ptr = ipc_data;
 
 	ret = sof_ipc_tx_message(sdev->ipc, msg, ipc_size, NULL, 0);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(sdev->dev, "failed to create module %s\n", swidget->widget->name);
 
+		if (swidget->id != snd_soc_dapm_scheduler) {
+			struct sof_ipc4_fw_module *fw_module = swidget->module_info;
+
+			ida_free(&fw_module->m_ida, swidget->instance_id);
+		}
+	}
+
 	return ret;
 }
 
-- 
2.35.1



