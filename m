Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55492541934
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378272AbiFGVTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381173AbiFGVRX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:17:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC6B221694;
        Tue,  7 Jun 2022 11:58:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B96C5617D8;
        Tue,  7 Jun 2022 18:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8EAFC385A5;
        Tue,  7 Jun 2022 18:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628311;
        bh=f3DlwVAoNPlUmtCXGtkTVlrQXzolrxMRqKu/66vdRrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZxm/MlsYIPC3qqgL6/6LSb5NbAZ8YbwH4zdGU29stnAW7cL+2IIko7oGDHj4z/xl
         rMjBMKFWZDywAG6DD3AnZX1WFAftk0oY79ozoE6us2IfJNOJCvhhxOYkwe5AwdPAU1
         p8PQxwBN8gJBnA7SreE1PRlIANd9NJ6a0Zes48YM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 281/879] ASoC: SOF: ipc3-topology: Set scontrol->priv to NULL after freeing it
Date:   Tue,  7 Jun 2022 18:56:39 +0200
Message-Id: <20220607165011.004643546@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit a403993ce98fb401f696da7c4f374739a7609cff ]

Since the scontrol->priv is freed up during load operation it should be set
to NULL to be safe against double freeing attempt.

Fixes: b5cee8feb1d48 ("ASoC: SOF: topology: Make control parsing IPC agnostic")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220331114757.32551-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc3-topology.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sof/ipc3-topology.c b/sound/soc/sof/ipc3-topology.c
index af1bbd34213c..cdff48c4195f 100644
--- a/sound/soc/sof/ipc3-topology.c
+++ b/sound/soc/sof/ipc3-topology.c
@@ -1605,6 +1605,7 @@ static int sof_ipc3_control_load_bytes(struct snd_sof_dev *sdev, struct snd_sof_
 	if (scontrol->priv_size > 0) {
 		memcpy(cdata->data, scontrol->priv, scontrol->priv_size);
 		kfree(scontrol->priv);
+		scontrol->priv = NULL;
 
 		if (cdata->data->magic != SOF_ABI_MAGIC) {
 			dev_err(sdev->dev, "Wrong ABI magic 0x%08x.\n", cdata->data->magic);
-- 
2.35.1



