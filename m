Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7976DEE57
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbjDLIla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbjDLIkk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:40:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384F27285
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CC0661FB0
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463A1C433D2;
        Wed, 12 Apr 2023 08:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288770;
        bh=HpDiPge5WbKmg9/mLvM0fTSRVjMevrgZx91HWYIwaBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qYWqka5PrKh+htiTNhJ8ZbSDiykFyKSVOEJskYZY36tD1eKu41/7FQ0zucP3OZMWl
         9LJm6WRHOY1IgpUF9uIhzQXFRYyd+lYOHIrXlHtyPT7B2OlX/GNwzLs8ympG8NgELw
         mCizopdB3itcrxIy08wbaeF3iM1Xi1c8ijvrxGbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/164] ASoC: SOF: ipc4: Ensure DSP is in D0I0 during sof_ipc4_set_get_data()
Date:   Wed, 12 Apr 2023 10:32:13 +0200
Message-Id: <20230412082837.311064305@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit e51f49512d98783b90799c9cc2002895ec3aa0eb ]

The set_get_data() IPC op bypasses the check for the no_pm flag as done
with the regular IPC tx_msg op. Since set_get_data should be performed
when the DSP is in D0I0, set the DSP power state to D0I0 before sending
the IPC's in sof_ipc4_set_get_data().

Fixes: ceb89acc4dc8 ("ASoC: SOF: ipc4: Add support for mandatory message handling functionality")
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230322085538.10214-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/sof/ipc4.c b/sound/soc/sof/ipc4.c
index 6eaa18e27e5af..c08f3960ddd96 100644
--- a/sound/soc/sof/ipc4.c
+++ b/sound/soc/sof/ipc4.c
@@ -392,6 +392,9 @@ static int sof_ipc4_tx_msg(struct snd_sof_dev *sdev, void *msg_data, size_t msg_
 static int sof_ipc4_set_get_data(struct snd_sof_dev *sdev, void *data,
 				 size_t payload_bytes, bool set)
 {
+	const struct sof_dsp_power_state target_state = {
+			.state = SOF_DSP_PM_D0,
+	};
 	size_t payload_limit = sdev->ipc->max_payload_size;
 	struct sof_ipc4_msg *ipc4_msg = data;
 	struct sof_ipc4_msg tx = {{ 0 }};
@@ -422,6 +425,11 @@ static int sof_ipc4_set_get_data(struct snd_sof_dev *sdev, void *data,
 
 	tx.extension |= SOF_IPC4_MOD_EXT_MSG_FIRST_BLOCK(1);
 
+	/* ensure the DSP is in D0i0 before sending IPC */
+	ret = snd_sof_dsp_set_power_state(sdev, &target_state);
+	if (ret < 0)
+		return ret;
+
 	/* Serialise IPC TX */
 	mutex_lock(&sdev->ipc->tx_mutex);
 
-- 
2.39.2



