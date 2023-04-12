Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B409A6DEF26
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbjDLIsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbjDLIsU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:48:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A679775
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:47:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E49163079
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A6EC4339B;
        Wed, 12 Apr 2023 08:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289250;
        bh=B8OBYY5u9synIXP/5TRDcOQmDm2WKrod85l+KCZGXCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=znnXxBCpMeEOQm/GBgziWcjwYWR+Kk9D25mDQkLABTvzhZ2ZgrwErSjEUaIe9jm8u
         oT8tJBdHJMW6QCIv2ul5bPD1QXhigi0VA4tbuJ5MIbFVG2//Xm91kZ8PXU0u7Cefeb
         rLE3bTPnMST4G+8xKV2BOLnlWKiXdHvDXWPO/xag=
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
Subject: [PATCH 6.2 009/173] ASoC: SOF: ipc4: Ensure DSP is in D0I0 during sof_ipc4_set_get_data()
Date:   Wed, 12 Apr 2023 10:32:15 +0200
Message-Id: <20230412082838.488490652@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 74cd7e9560193..280fc89043b16 100644
--- a/sound/soc/sof/ipc4.c
+++ b/sound/soc/sof/ipc4.c
@@ -393,6 +393,9 @@ static int sof_ipc4_tx_msg(struct snd_sof_dev *sdev, void *msg_data, size_t msg_
 static int sof_ipc4_set_get_data(struct snd_sof_dev *sdev, void *data,
 				 size_t payload_bytes, bool set)
 {
+	const struct sof_dsp_power_state target_state = {
+			.state = SOF_DSP_PM_D0,
+	};
 	size_t payload_limit = sdev->ipc->max_payload_size;
 	struct sof_ipc4_msg *ipc4_msg = data;
 	struct sof_ipc4_msg tx = {{ 0 }};
@@ -423,6 +426,11 @@ static int sof_ipc4_set_get_data(struct snd_sof_dev *sdev, void *data,
 
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



