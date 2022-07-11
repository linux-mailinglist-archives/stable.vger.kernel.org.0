Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F8656FB57
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbiGKJ3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiGKJ26 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:28:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7028C3D5AA;
        Mon, 11 Jul 2022 02:16:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAC0761243;
        Mon, 11 Jul 2022 09:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C53C34115;
        Mon, 11 Jul 2022 09:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530972;
        bh=FBu7KY5YYbZo+WK5Ypy6wwAPJNUeHar+h74qFtStpgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k09N59zIOh/VOnEj+MXk9uD2iFhLIJa6KduHngKSo8RTwpAXcuWuoOGxE4H5VJ/81
         b00pd1CN52IVOtNdnyJra7NPs54R05/yAgdNiKhYHESdXGgp1U5n7xRiu8nYwoeUVe
         jjvpOcmHcK1ykqR/MDOeOmjYUZvZ+d/9wt7bKCeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 051/112] ASoC: SOF: ipc3-topology: Move and correct size checks in sof_ipc3_control_load_bytes()
Date:   Mon, 11 Jul 2022 11:06:51 +0200
Message-Id: <20220711090551.020035523@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit c2d1aec3f5da2475aa13a487d329823b7d27d499 ]

Move the size checks prior to allocating memory as these checks do not need
the data to be allocated and in case of an error we would not need to free
the allocation.

The max size must not be less than the size of
struct sof_ipc_ctrl_data + struct sof_abi_hdr as the ABI header needs to
be present under all circumstances.
The check was incorrectly used or between the two size checks.

Fixes: b5cee8feb1d4 ("ASoC: SOF: topology: Make control parsing IPC agnostic")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20220610084735.19397-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc3-topology.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/sound/soc/sof/ipc3-topology.c b/sound/soc/sof/ipc3-topology.c
index cdff48c4195f..80fb82ece38d 100644
--- a/sound/soc/sof/ipc3-topology.c
+++ b/sound/soc/sof/ipc3-topology.c
@@ -1578,24 +1578,23 @@ static int sof_ipc3_control_load_bytes(struct snd_sof_dev *sdev, struct snd_sof_
 	struct sof_ipc_ctrl_data *cdata;
 	int ret;
 
-	scontrol->ipc_control_data = kzalloc(scontrol->max_size, GFP_KERNEL);
-	if (!scontrol->ipc_control_data)
-		return -ENOMEM;
-
-	if (scontrol->max_size < sizeof(*cdata) ||
-	    scontrol->max_size < sizeof(struct sof_abi_hdr)) {
-		ret = -EINVAL;
-		goto err;
+	if (scontrol->max_size < (sizeof(*cdata) + sizeof(struct sof_abi_hdr))) {
+		dev_err(sdev->dev, "%s: insufficient size for a bytes control: %zu.\n",
+			__func__, scontrol->max_size);
+		return -EINVAL;
 	}
 
-	/* init the get/put bytes data */
 	if (scontrol->priv_size > scontrol->max_size - sizeof(*cdata)) {
-		dev_err(sdev->dev, "err: bytes data size %zu exceeds max %zu.\n",
+		dev_err(sdev->dev,
+			"%s: bytes data size %zu exceeds max %zu.\n", __func__,
 			scontrol->priv_size, scontrol->max_size - sizeof(*cdata));
-		ret = -EINVAL;
-		goto err;
+		return -EINVAL;
 	}
 
+	scontrol->ipc_control_data = kzalloc(scontrol->max_size, GFP_KERNEL);
+	if (!scontrol->ipc_control_data)
+		return -ENOMEM;
+
 	scontrol->size = sizeof(struct sof_ipc_ctrl_data) + scontrol->priv_size;
 
 	cdata = scontrol->ipc_control_data;
-- 
2.35.1



