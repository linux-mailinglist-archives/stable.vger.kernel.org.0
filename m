Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CCD42DD31
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbhJNPFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:05:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233618AbhJNPDd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:03:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B234F61245;
        Thu, 14 Oct 2021 15:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223614;
        bh=AahxwJYG4j4R4CS2jEkZRtOfxGhMYw++Mi15qTpH2NM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUi/IrrbTJqod2/wXSvrTC+BfqrP1y99wL4UByvfWHNQ8DbDmT5daAeV/zIdwdoLI
         RVgo4HdzOxdmzI0E3RRVQNC04xXptVNwuqOWE97cFHzuDXjzcdeWPDEURVRW5HmvT1
         4G7OyorOSYH9i2+RMj1Oapbl/s37Y/vudNAUc14M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Bard Liao <bard.liao@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 03/22] ASoC: Intel: sof_sdw: tag SoundWire BEs as non-atomic
Date:   Thu, 14 Oct 2021 16:54:09 +0200
Message-Id: <20211014145208.095354427@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145207.979449962@linuxfoundation.org>
References: <20211014145207.979449962@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 58eafe1ff52ee1ce255759fc15729519af180cbb ]

The SoundWire BEs make use of 'stream' functions for .prepare and
.trigger. These functions will in turn force a Bank Switch, which
implies a wait operation.

Mark SoundWire BEs as nonatomic for consistency, but keep all other
types of BEs as is. The initialization of .nonatomic is done outside
of the create_sdw_dailink helper to avoid adding more parameters to
deal with a single exception to the rule that BEs are atomic.

Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <bard.liao@intel.com>
Link: https://lore.kernel.org/r/20210907184436.33152-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 2770e8179983..25548555d8d7 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -847,6 +847,11 @@ static int create_sdw_dailink(struct device *dev, int *be_index,
 			      cpus + *cpu_id, cpu_dai_num,
 			      codecs, codec_num,
 			      NULL, &sdw_ops);
+		/*
+		 * SoundWire DAILINKs use 'stream' functions and Bank Switch operations
+		 * based on wait_for_completion(), tag them as 'nonatomic'.
+		 */
+		dai_links[*be_index].nonatomic = true;
 
 		ret = set_codec_init_func(link, dai_links + (*be_index)++,
 					  playback, group_id);
-- 
2.33.0



