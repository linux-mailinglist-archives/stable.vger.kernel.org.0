Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E49DA26F2A
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731573AbfEVTZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:25:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731517AbfEVTZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:25:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2E9E21473;
        Wed, 22 May 2019 19:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553117;
        bh=HUkTkAQobPqngnw6JA3r3tU2cK8JUX2w/ZHEhXh4UJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FUSwFUUWsSE20C9QnifZqkTthvm8xUCZOfHeX+6p3ynSPvHIrfDZ8SxKFTzODTzDc
         tjSy/zSGeVYJgz9mG+VIDw/4BX5ZZXkN631BcxG7dQGfhPx2vE3APii7MkU1tBmwAI
         3RmxXSeVM5HXGV4y6op4+fJlEpXw+ZNPvJTJUXXA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bard liao <yung-chuan.liao@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 057/317] ALSA: hda: fix unregister device twice on ASoC driver
Date:   Wed, 22 May 2019 15:19:18 -0400
Message-Id: <20190522192338.23715-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bard liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 4d95c51776b2edb4d4ebcea00b6e5a1fe538ce66 ]

snd_hda_codec_device_new() is used by both legacy HDA and ASoC
driver. However, we will call snd_hdac_device_unregister() in
snd_hdac_ext_bus_device_remove() for ASoC device. This patch uses
the type flag in hdac_device struct to determine is it a ASoC device
or legacy HDA device and call snd_hdac_device_unregister() in
snd_hda_codec_dev_free() only if it is a legacy HDA device.

Signed-off-by: Bard liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_codec.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index b238e903b9d7a..a00bd79866466 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -841,7 +841,13 @@ static int snd_hda_codec_dev_free(struct snd_device *device)
 	struct hda_codec *codec = device->device_data;
 
 	codec->in_freeing = 1;
-	snd_hdac_device_unregister(&codec->core);
+	/*
+	 * snd_hda_codec_device_new() is used by legacy HDA and ASoC driver.
+	 * We can't unregister ASoC device since it will be unregistered in
+	 * snd_hdac_ext_bus_device_remove().
+	 */
+	if (codec->core.type == HDA_DEV_LEGACY)
+		snd_hdac_device_unregister(&codec->core);
 	codec_display_power(codec, false);
 	put_device(hda_codec_dev(codec));
 	return 0;
-- 
2.20.1

