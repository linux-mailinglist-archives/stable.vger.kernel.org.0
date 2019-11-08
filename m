Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF6AF480D
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390262AbfKHLqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:46:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:34092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390243AbfKHLqY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:46:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9B4620656;
        Fri,  8 Nov 2019 11:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213583;
        bh=93VE6Y/iJda7YDrNkr7BnN8q9ahcrr3mWS4oxRWt8W4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wlGUfL1XALEc5IZpPT9nK1+6UDu3IttEHLMdeQMXP6OOOscDPcQAP2WUFhwM06WgK
         4QqSXPYrchgulH8M4bz5uNpWRhvTzsIJhl7bVnY6gMN3q60WqmULT7sFHhOhmE4VeQ
         gEy/nneM372FN3no6OVl0gzsXpEC8+Ddw/LOhivI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yong Zhi <yong.zhi@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 26/64] ASoC: Intel: hdac_hdmi: Limit sampling rates at dai creation
Date:   Fri,  8 Nov 2019 06:45:07 -0500
Message-Id: <20191108114545.15351-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114545.15351-1-sashal@kernel.org>
References: <20191108114545.15351-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

