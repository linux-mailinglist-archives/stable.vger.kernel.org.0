Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD4420E834
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391817AbgF2WEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:04:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbgF2SfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C194246B6;
        Mon, 29 Jun 2020 15:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444006;
        bh=INcq5wxv6l6AovBo3O4mUJtdrDH+kYf9POZ5RalqkMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QYvakmDszmo3RLEw9J1c7KvLdOHdHRz5FBM9U5BWKVJXlqKeLr3Y+6m/P0+shUnud
         LsYlJpQueODlbgzYS0FAjnUrpjbeD6EiTB5HyADSpa0BEinEOcu+ZhBiX8n2nddqun
         w5yLAaYiLWjpJ6EyF2hkuWxUD+QNG47No14YHyOg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 112/265] ASoC: qcom: common: set correct directions for dailinks
Date:   Mon, 29 Jun 2020 11:15:45 -0400
Message-Id: <20200629151818.2493727-113-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit a2120089251f1fe221305e88df99af16f940e236 ]

Currently both FE and BE dai-links are configured bi-directional,
However the DSP BE dais are only single directional,
so set the directions as supported by the BE dais.

Fixes: c25e295cd77b (ASoC: qcom: Add support to parse common audio device nodes)
Reported-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Tested-by: John Stultz <john.stultz@linaro.org>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20200612123711.29130-2-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/common.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/sound/soc/qcom/common.c b/sound/soc/qcom/common.c
index 6c20bdd850f33..8ada4ecba8472 100644
--- a/sound/soc/qcom/common.c
+++ b/sound/soc/qcom/common.c
@@ -4,6 +4,7 @@
 
 #include <linux/module.h>
 #include "common.h"
+#include "qdsp6/q6afe.h"
 
 int qcom_snd_parse_of(struct snd_soc_card *card)
 {
@@ -101,6 +102,15 @@ int qcom_snd_parse_of(struct snd_soc_card *card)
 			}
 			link->no_pcm = 1;
 			link->ignore_pmdown_time = 1;
+
+			if (q6afe_is_rx_port(link->id)) {
+				link->dpcm_playback = 1;
+				link->dpcm_capture = 0;
+			} else {
+				link->dpcm_playback = 0;
+				link->dpcm_capture = 1;
+			}
+
 		} else {
 			dlc = devm_kzalloc(dev, sizeof(*dlc), GFP_KERNEL);
 			if (!dlc)
@@ -113,12 +123,12 @@ int qcom_snd_parse_of(struct snd_soc_card *card)
 			link->codecs->dai_name = "snd-soc-dummy-dai";
 			link->codecs->name = "snd-soc-dummy";
 			link->dynamic = 1;
+			link->dpcm_playback = 1;
+			link->dpcm_capture = 1;
 		}
 
 		link->ignore_suspend = 1;
 		link->nonatomic = 1;
-		link->dpcm_playback = 1;
-		link->dpcm_capture = 1;
 		link->stream_name = link->name;
 		link++;
 
-- 
2.25.1

