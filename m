Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 928336C55B6
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbjCVUAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbjCVT7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 15:59:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865D35943A;
        Wed, 22 Mar 2023 12:58:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 985E46229C;
        Wed, 22 Mar 2023 19:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B8BC4339C;
        Wed, 22 Mar 2023 19:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515097;
        bh=FKBZKY8qQ6HXoFsT/mRrgOqXCpdTA4uhACvftMNXzMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mCLfT8B199cKvacvZZeL+w0fSqovOPKSEl8wkFOXy7ebs6SK3D0ZA05Q+VpmPRewF
         FziQabpTpGnqSuLq3mFP0uDIZmCquSfgxAV7uQrGqUXL9vyYLnGWwjCxB1hcGVVgX2
         041/6/Dc9B+SK7oE5YF+NWdD5z1RtVIU/VQzN/hECgL3+oKtAZkWrEaDhqmzWI2PZ4
         4oOXHh+KpTOcTdb0RdvYA5Hn6PXHqR16ItH3ttbJCgGTNhWzCWbUxahH5FE44XgkHn
         Ga5LY1xKG8sJVVWncFz5Usn9QeGCPosKzcRCUAMEsDj+LhDuZuFtGOoGS9kpZ38GXl
         1H72Qe+aLWA9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        yung-chuan.liao@linux.intel.com, daniel.baluta@nxp.com,
        perex@perex.cz, tiwai@suse.com,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.2 18/45] ASoC: SOF: Intel: hda-ctrl: re-add sleep after entering and exiting reset
Date:   Wed, 22 Mar 2023 15:56:12 -0400
Message-Id: <20230322195639.1995821-18-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195639.1995821-1-sashal@kernel.org>
References: <20230322195639.1995821-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 8bac40b8ed17ab1be9133e9620f65fae80262b7e ]

This reverts commit a09d82ce0a867 ("ASoC: SOF: Intel: hda-ctrl: remove
useless sleep")

It was a mistake to remove those delays, in light of comments in the
HDaudio spec captured in snd_hdac_bus_reset_link() that the codec
needs time for its initialization and PLL lock.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230307095412.3416-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-ctrl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/sof/intel/hda-ctrl.c b/sound/soc/sof/intel/hda-ctrl.c
index 3aea36c077c9d..f3bdeba284122 100644
--- a/sound/soc/sof/intel/hda-ctrl.c
+++ b/sound/soc/sof/intel/hda-ctrl.c
@@ -196,12 +196,15 @@ int hda_dsp_ctrl_init_chip(struct snd_sof_dev *sdev)
 		goto err;
 	}
 
+	usleep_range(500, 1000);
+
 	/* exit HDA controller reset */
 	ret = hda_dsp_ctrl_link_reset(sdev, false);
 	if (ret < 0) {
 		dev_err(sdev->dev, "error: failed to exit HDA controller reset\n");
 		goto err;
 	}
+	usleep_range(1000, 1200);
 
 	hda_codec_detect_mask(sdev);
 
-- 
2.39.2

