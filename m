Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36BAE3286B4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237796AbhCARNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:13:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:35318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237513AbhCARIV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:08:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85CFF64F89;
        Mon,  1 Mar 2021 16:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616878;
        bh=1K//8isw1juxlFVhKO+odgoTL/ejvfqUNdvt0tZ8fzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WLFQFxgAroesq993U8EkbOW4EtbJR4Lvht5UQEdnRrJ1LyeBTABl4ooPJWVZlugG8
         OKqEib/Ltm8rNvd5Wpjrac1Pm22ZTlIRp76imO2IM5e09b+FG+vg1WNrVsU3A1IHYc
         zTKJflSluSJpbVZyZ5me4FVNUN0soMIxpD9mAeVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Sebastian Reichel <sre@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 096/247] ASoC: cpcap: fix microphone timeslot mask
Date:   Mon,  1 Mar 2021 17:11:56 +0100
Message-Id: <20210301161036.378775226@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Reichel <sre@kernel.org>

[ Upstream commit de5bfae2fd962a9da99f56382305ec7966a604b9 ]

The correct mask is 0x1f8 (Bit 3-8), but due to missing BIT() 0xf (Bit
0-3) was set instead. This means setting of CPCAP_BIT_MIC1_RX_TIMESLOT0
(Bit 3) still worked (part of both masks). On the other hand the code
does not properly clear the other MIC timeslot bits. I think this
is not a problem, since they are probably initialized to 0 and not
touched by the driver anywhere else. But the mask also contains some
wrong bits, that will be cleared. Bit 0 (CPCAP_BIT_SMB_CDC) should be
safe, since the driver enforces it to be 0 anyways.

Bit 1-2 are CPCAP_BIT_FS_INV and CPCAP_BIT_CLK_INV. This means enabling
audio recording forces the codec into SND_SOC_DAIFMT_NB_NF mode, which
is obviously bad.

The bug probably remained undetected, because there are not many use
cases for routing microphone to the CPU on platforms using cpcap and
user base is small. I do remember having some issues with bad sound
quality when testing voice recording back when I wrote the driver.
It probably was this bug.

Fixes: f6cdf2d3445d ("ASoC: cpcap: new codec")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Sebastian Reichel <sre@kernel.org>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20210123172945.3958622-1-sre@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cpcap.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/cpcap.c b/sound/soc/codecs/cpcap.c
index d7f05b384f1fb..1902689c5ea2c 100644
--- a/sound/soc/codecs/cpcap.c
+++ b/sound/soc/codecs/cpcap.c
@@ -1263,12 +1263,12 @@ static int cpcap_voice_hw_params(struct snd_pcm_substream *substream,
 
 	if (direction == SNDRV_PCM_STREAM_CAPTURE) {
 		mask = 0x0000;
-		mask |= CPCAP_BIT_MIC1_RX_TIMESLOT0;
-		mask |= CPCAP_BIT_MIC1_RX_TIMESLOT1;
-		mask |= CPCAP_BIT_MIC1_RX_TIMESLOT2;
-		mask |= CPCAP_BIT_MIC2_TIMESLOT0;
-		mask |= CPCAP_BIT_MIC2_TIMESLOT1;
-		mask |= CPCAP_BIT_MIC2_TIMESLOT2;
+		mask |= BIT(CPCAP_BIT_MIC1_RX_TIMESLOT0);
+		mask |= BIT(CPCAP_BIT_MIC1_RX_TIMESLOT1);
+		mask |= BIT(CPCAP_BIT_MIC1_RX_TIMESLOT2);
+		mask |= BIT(CPCAP_BIT_MIC2_TIMESLOT0);
+		mask |= BIT(CPCAP_BIT_MIC2_TIMESLOT1);
+		mask |= BIT(CPCAP_BIT_MIC2_TIMESLOT2);
 		val = 0x0000;
 		if (channels >= 2)
 			val = BIT(CPCAP_BIT_MIC1_RX_TIMESLOT0);
-- 
2.27.0



