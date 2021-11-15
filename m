Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2568452394
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348870AbhKPB1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:27:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:38776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243863AbhKOTIK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:08:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC812633F8;
        Mon, 15 Nov 2021 18:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000245;
        bh=Zw90p/ZsdLRxko2E62WUIDtJM/Fhg1ws1f5Ep9Yi2X4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rKlv7E/RRimslc9gdEgOEAr/8Q9Fki0d5794HvmCjxNsW5NvSltI3h+ZcPdDKE4MI
         oPG10fo4J/tb6ONca59vLuyVdiumAARS0RAfEI58M+/kkF5VECIil7UMZc9IyN7jXB
         LyRPBgl/ueCTpKU3MwZZpN4FgexgfT1v2s8c8a14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 590/849] ASoC: SOF: topology: do not power down primary core during topology removal
Date:   Mon, 15 Nov 2021 18:01:13 +0100
Message-Id: <20211115165440.210662341@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit ec626334eaffe101df9ed79e161eba95124e64ad ]

When removing the topology components, do not power down
the primary core. Doing so will result in an IPC timeout
when the SOF PCI device runtime suspends.

Fixes: 0dcdf84289fb ("ASoC: SOF: add a "core" parameter to widget loading functions")

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20211006104041.27183-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/topology.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index cc9585bfa4e9f..1bb2dcf37ffe9 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -2598,6 +2598,15 @@ static int sof_widget_unload(struct snd_soc_component *scomp,
 
 		/* power down the pipeline schedule core */
 		pipeline = swidget->private;
+
+		/*
+		 * Runtime PM should still function normally if topology loading fails and
+		 * it's components are unloaded. Do not power down the primary core so that the
+		 * CTX_SAVE IPC can succeed during runtime suspend.
+		 */
+		if (pipeline->core == SOF_DSP_PRIMARY_CORE)
+			break;
+
 		ret = snd_sof_dsp_core_power_down(sdev, 1 << pipeline->core);
 		if (ret < 0)
 			dev_err(scomp->dev, "error: powering down pipeline schedule core %d\n",
-- 
2.33.0



