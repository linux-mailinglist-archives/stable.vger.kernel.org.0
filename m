Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0F40106B00
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbfKVKka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:40:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:44412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728899AbfKVKka (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:40:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5659320718;
        Fri, 22 Nov 2019 10:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419229;
        bh=93VE6Y/iJda7YDrNkr7BnN8q9ahcrr3mWS4oxRWt8W4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZAza2QgiTvsGyO3xxEjG3Sp1Y+5cwlNE3McWeoqPxwb3SVXgJ3lUtvJ5QXUtvPS2
         8zwWlqoi9az+Jc+1Yw7f32NVzs97NAgx8qBsj/vSLSB5BGjWxjJuot3gQsL16fEFq2
         bbq0tfSTN934qN7xZQDmdjp8ezZXfF8iXeZgzAk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yong Zhi <yong.zhi@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 041/222] ASoC: Intel: hdac_hdmi: Limit sampling rates at dai creation
Date:   Fri, 22 Nov 2019 11:26:21 +0100
Message-Id: <20191122100849.887094775@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yong Zhi <yong.zhi@intel.com>

[ Upstream commit 3b857472f34faa7d11001afa5e158833812c98d7 ]

Playback of 44.1Khz contents with HDMI plugged returns
"Invalid pipe config" because HDMI paths in the FW
topology are configured to operate at 48Khz.

This patch filters out sampling rates not supported
at hdac_hdmi_create_dais() to let user space SRC
to do the converting.

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdac_hdmi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/soc/codecs/hdac_hdmi.c b/sound/soc/codecs/hdac_hdmi.c
index c602c4960924c..88355d1719a30 100644
--- a/sound/soc/codecs/hdac_hdmi.c
+++ b/sound/soc/codecs/hdac_hdmi.c
@@ -1267,6 +1267,12 @@ static int hdac_hdmi_create_dais(struct hdac_device *hdac,
 		if (ret)
 			return ret;
 
+		/* Filter out 44.1, 88.2 and 176.4Khz */
+		rates &= ~(SNDRV_PCM_RATE_44100 | SNDRV_PCM_RATE_88200 |
+			   SNDRV_PCM_RATE_176400);
+		if (!rates)
+			return -EINVAL;
+
 		sprintf(dai_name, "intel-hdmi-hifi%d", i+1);
 		hdmi_dais[i].name = devm_kstrdup(&hdac->dev,
 					dai_name, GFP_KERNEL);
-- 
2.20.1



