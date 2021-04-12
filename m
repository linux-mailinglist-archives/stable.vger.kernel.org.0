Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC3535BE69
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238603AbhDLI6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238498AbhDLI4Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:56:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DA0561261;
        Mon, 12 Apr 2021 08:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217767;
        bh=7RH1ok2hvfmGbJIFz1ZUsEXix6olH5SqdhmzepKwlEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ow2WN10cyYNVeF1POKicvdoY+EkxenRTTn0E11E4brQTxp+e2VpUjdKu50oKBe3ji
         aKuxAeOlZsytMX4mSNLayzD/r9Ls9MsEjDVULZQ8evu6QdhqbPIBWr1BBV+dF4Up24
         YafMUGbQGwIoEU/emZmPZf+mc/18CnzZFFWiC07k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/188] ASoC: SOF: Intel: HDA: fix core status verification
Date:   Mon, 12 Apr 2021 10:40:16 +0200
Message-Id: <20210412084017.044364654@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>

[ Upstream commit 927280909fa7d8e61596800d82f18047c6cfbbe4 ]

When checking for enabled cores it isn't enough to check that
some of the requested cores are running, we have to check that
all of them are.

Fixes: 747503b1813a ("ASoC: SOF: Intel: Add Intel specific HDA DSP HW operations")
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210322163728.16616-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-dsp.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/sound/soc/sof/intel/hda-dsp.c b/sound/soc/sof/intel/hda-dsp.c
index c731b9bd60b4..85ec4361c8c4 100644
--- a/sound/soc/sof/intel/hda-dsp.c
+++ b/sound/soc/sof/intel/hda-dsp.c
@@ -226,10 +226,17 @@ bool hda_dsp_core_is_enabled(struct snd_sof_dev *sdev,
 
 	val = snd_sof_dsp_read(sdev, HDA_DSP_BAR, HDA_DSP_REG_ADSPCS);
 
-	is_enable = (val & HDA_DSP_ADSPCS_CPA_MASK(core_mask)) &&
-		    (val & HDA_DSP_ADSPCS_SPA_MASK(core_mask)) &&
-		    !(val & HDA_DSP_ADSPCS_CRST_MASK(core_mask)) &&
-		    !(val & HDA_DSP_ADSPCS_CSTALL_MASK(core_mask));
+#define MASK_IS_EQUAL(v, m, field) ({	\
+	u32 _m = field(m);		\
+	((v) & _m) == _m;		\
+})
+
+	is_enable = MASK_IS_EQUAL(val, core_mask, HDA_DSP_ADSPCS_CPA_MASK) &&
+		MASK_IS_EQUAL(val, core_mask, HDA_DSP_ADSPCS_SPA_MASK) &&
+		!(val & HDA_DSP_ADSPCS_CRST_MASK(core_mask)) &&
+		!(val & HDA_DSP_ADSPCS_CSTALL_MASK(core_mask));
+
+#undef MASK_IS_EQUAL
 
 	dev_dbg(sdev->dev, "DSP core(s) enabled? %d : core_mask %x\n",
 		is_enable, core_mask);
-- 
2.30.2



