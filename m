Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 066ED328C9A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240408AbhCASyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:54:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:55112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240678AbhCAStB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:49:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58E5464E56;
        Mon,  1 Mar 2021 17:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618821;
        bh=CPfksJhjogUuM3+sUK3FENYpUBxQvgI9JgFo5pPiU2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QnnzIK2ZiiecJrye8KsVO55fm5M0q5N4YcZEZwL66OOCBs/hkpDgozqHBFbSYth/o
         S9lqCcosTWcKjI/AVDvSKwc9LdJjPZUxNGIor/BjrBqCqb6etyusHK7siZcRwjyDiC
         z17jDBMDPvBpXT5kkNY2XlmH1uE1OtnkAIN1ATcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 199/663] ASoC: SOF: Intel: hda: cancel D0i3 work during runtime suspend
Date:   Mon,  1 Mar 2021 17:07:27 +0100
Message-Id: <20210301161151.628477562@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit 0084364d9678e9d722ee620ed916f2f9954abdbf ]

Cancel the D0i3 work during runtime suspend as no streams are
active at this point anyway.

Fixes: 63e51fd33fef ("ASoC: SOF: Intel: cnl: Implement feature to support DSP D0i3 in S0")
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20210128092345.1033085-1-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-dsp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/sof/intel/hda-dsp.c b/sound/soc/sof/intel/hda-dsp.c
index 2dbc1273e56bd..cd324f3d11d17 100644
--- a/sound/soc/sof/intel/hda-dsp.c
+++ b/sound/soc/sof/intel/hda-dsp.c
@@ -801,11 +801,15 @@ int hda_dsp_runtime_idle(struct snd_sof_dev *sdev)
 
 int hda_dsp_runtime_suspend(struct snd_sof_dev *sdev)
 {
+	struct sof_intel_hda_dev *hda = sdev->pdata->hw_pdata;
 	const struct sof_dsp_power_state target_state = {
 		.state = SOF_DSP_PM_D3,
 	};
 	int ret;
 
+	/* cancel any attempt for DSP D0I3 */
+	cancel_delayed_work_sync(&hda->d0i3_work);
+
 	/* stop hda controller and power dsp off */
 	ret = hda_suspend(sdev, true);
 	if (ret < 0)
-- 
2.27.0



