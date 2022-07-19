Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F98B579EE8
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238242AbiGSNHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243037AbiGSNHM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:07:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6A9B9A15;
        Tue, 19 Jul 2022 05:27:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B376E6020F;
        Tue, 19 Jul 2022 12:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94551C341CB;
        Tue, 19 Jul 2022 12:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233642;
        bh=Nu25KeaHG2mnQyV9qxyD+sSs3aEncDCtP3ul7XyJKUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U2MK59tKZPlru2QYjxAmc6XuA6V1aCf8JZpjUAAwLk+OwZibIoyfloTQOsG05R7xW
         p6WVIcVBraaBKLgBQsh+rdgVh+1FKfepEVejOt09zzRVGqTyMIza9vjfcm/rxHQeXB
         j7/7bRWbesoEPv2mqbJs6SY5RNdN/sQBvwY4wfM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 192/231] ASoC: SOF: Intel: hda-loader: Make sure that the fw load sequence is followed
Date:   Tue, 19 Jul 2022 13:54:37 +0200
Message-Id: <20220719114730.293222807@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit c31691e0d126ec5d60d2b6b03f699c11b613b219 ]

The hda_dsp_enable_core() is powering up _and_ unstall the core in one
call while the first step of the firmware loading  must not unstall the
core.
The core can be unstalled only after the set cpb_cfp and the configuration
of the IPC register for the ROM_CONTROL message.

Complements: 2a68ff846164 ("ASoC: SOF: Intel: hda: Revisit IMR boot sequence")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20220609085949.29062-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-loader.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/intel/hda-loader.c b/sound/soc/sof/intel/hda-loader.c
index 2ac5d9d0719b..9f624a84182b 100644
--- a/sound/soc/sof/intel/hda-loader.c
+++ b/sound/soc/sof/intel/hda-loader.c
@@ -112,7 +112,7 @@ static int cl_dsp_init(struct snd_sof_dev *sdev, int stream_tag)
 	int ret;
 
 	/* step 1: power up corex */
-	ret = hda_dsp_enable_core(sdev, chip->host_managed_cores_mask);
+	ret = hda_dsp_core_power_up(sdev, chip->host_managed_cores_mask);
 	if (ret < 0) {
 		if (hda->boot_iteration == HDA_FW_BOOT_ATTEMPTS)
 			dev_err(sdev->dev, "error: dsp core 0/1 power up failed\n");
-- 
2.35.1



