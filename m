Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A045299BB7
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 00:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409904AbgJZXw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:52:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409879AbgJZXws (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:52:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FDCD2225C;
        Mon, 26 Oct 2020 23:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756368;
        bh=9C528tZoQ9h5NstXknIAS/BD9iT7n94wKg9f1AkabPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GDdj7PIcDfZQjklPQWMHgJSQ+KvuYvf+9qy+r9l1ZID5vjDXeThlo3Ts4Xb7XYd81
         9CynvIeTGMlwJNGudiiDL07g2Lu/z5jCr2fIkvwWqCukiMfmnNheZlC+HKIegAro+v
         vpFfWi+O6Sv6l2yPQcZKMF5Lg0h6ar9yCvjY4Gs8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rander Wang <rander.wang@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.8 035/132] ASoC: SOF: fix a runtime pm issue in SOF when HDMI codec doesn't work
Date:   Mon, 26 Oct 2020 19:50:27 -0400
Message-Id: <20201026235205.1023962-35-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rander Wang <rander.wang@intel.com>

[ Upstream commit 6c63c954e1c52f1262f986f36d95f557c6f8fa94 ]

When hda_codec_probe() doesn't initialize audio component, we disable
the codec and keep going. However,the resources are not released. The
child_count of SOF device is increased in snd_hdac_ext_bus_device_init
but is not decrease in error case, so SOF can't get suspended.

snd_hdac_ext_bus_device_exit will be invoked in HDA framework if it
gets a error. Now copy this behavior to release resources and decrease
SOF device child_count to release SOF device.

Signed-off-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20200825235040.1586478-3-ranjani.sridharan@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-codec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/intel/hda-codec.c b/sound/soc/sof/intel/hda-codec.c
index 2c5c451fa19d7..c475955c6eeba 100644
--- a/sound/soc/sof/intel/hda-codec.c
+++ b/sound/soc/sof/intel/hda-codec.c
@@ -151,7 +151,7 @@ static int hda_codec_probe(struct snd_sof_dev *sdev, int address,
 		if (!hdev->bus->audio_component) {
 			dev_dbg(sdev->dev,
 				"iDisp hw present but no driver\n");
-			return -ENOENT;
+			goto error;
 		}
 		hda_priv->need_display_power = true;
 	}
@@ -174,7 +174,7 @@ static int hda_codec_probe(struct snd_sof_dev *sdev, int address,
 		 * other return codes without modification
 		 */
 		if (ret == 0)
-			ret = -ENOENT;
+			goto error;
 	}
 
 	return ret;
-- 
2.25.1

