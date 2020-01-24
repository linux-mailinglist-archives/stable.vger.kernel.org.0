Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2C101486E4
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391564AbgAXOTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:19:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:39566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391538AbgAXOTU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:19:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E64C22522;
        Fri, 24 Jan 2020 14:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875560;
        bh=2dCeTe+htp6bYLj6TEvc7v6Uv3nrYBGHsJ2ytgCOJwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qf+KVs/j+NZdccPeR7K11nfWMilqR/NcCfFKzpcsNUq+kjQ7GbfTakvHykyOen7be
         qiqSj2eU1nbVSU20SVS+XAmOZdMUssfiKvH9ovQt8hJ2O3ibdMX7KucTZ3x1lqwL0C
         dVgxSAcUmTs7wLRdFBvoQbYnVfJx4iT5LhIpLONw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 054/107] ASoC: hdac_hda: Fix error in driver removal after failed probe
Date:   Fri, 24 Jan 2020 09:17:24 -0500
Message-Id: <20200124141817.28793-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit 552b1a85da9f63856e7e341b81c16e0e078204f1 ]

In case system has multiple HDA codecs, and codec probe fails for
at least one but not all codecs, driver will end up cancelling
a non-initialized timer context upon driver removal.

Call trace of typical case:

[   60.593646] WARNING: CPU: 1 PID: 1147 at kernel/workqueue.c:3032
__flush_work+0x18b/0x1a0
[...]
[   60.593670]  __cancel_work_timer+0x11f/0x1a0
[   60.593673]  hdac_hda_dev_remove+0x25/0x30 [snd_soc_hdac_hda]
[   60.593674]  device_release_driver_internal+0xe0/0x1c0
[   60.593675]  bus_remove_device+0xd6/0x140
[   60.593677]  device_del+0x175/0x3e0
[   60.593679]  ? widget_tree_free.isra.7+0x90/0xb0 [snd_hda_core]
[   60.593680]  snd_hdac_device_unregister+0x34/0x50 [snd_hda_core]
[   60.593682]  snd_hdac_ext_bus_device_remove+0x2a/0x60 [snd_hda_ext_core]
[   60.593684]  hda_dsp_remove+0x26/0x100 [snd_sof_intel_hda_common]
[   60.593686]  snd_sof_device_remove+0x84/0xa0 [snd_sof]
[   60.593687]  sof_pci_remove+0x10/0x30 [snd_sof_pci]
[   60.593689]  pci_device_remove+0x36/0xb0

Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200110235751.3404-9-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdac_hda.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/hdac_hda.c b/sound/soc/codecs/hdac_hda.c
index 4570f662fb48b..d78f4d856aaff 100644
--- a/sound/soc/codecs/hdac_hda.c
+++ b/sound/soc/codecs/hdac_hda.c
@@ -498,7 +498,9 @@ static int hdac_hda_dev_remove(struct hdac_device *hdev)
 	struct hdac_hda_priv *hda_pvt;
 
 	hda_pvt = dev_get_drvdata(&hdev->dev);
-	cancel_delayed_work_sync(&hda_pvt->codec.jackpoll_work);
+	if (hda_pvt && hda_pvt->codec.registered)
+		cancel_delayed_work_sync(&hda_pvt->codec.jackpoll_work);
+
 	return 0;
 }
 
-- 
2.20.1

