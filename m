Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C9A1AC7D5
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387393AbgDPO7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:59:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898850AbgDPNyf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:54:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22E282078B;
        Thu, 16 Apr 2020 13:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045273;
        bh=IqF7OoShQPZfYN4sRhgv9lp+qPIc6v+XYCMiyCJdDi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rnEcW+RXSROEAtgvgIIKWdrbPly5i60QbL4fdrTpTSJcdehV7EDiHwj0kp0naQ1mK
         FLrEB+mAkJk7LOjuKyBCCKRzQpdodRZBMD0d4qNXEEe0L4vp96ncjX86QrMDbTGsBX
         PUftPs14a+GwrVVPL4exnf+E/LxpTKlfqC5Gbvzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gyeongtaek Lee <gt82.lee@samsung.com>,
        Vinod Koul <vkoul@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.6 068/254] ASoC: dpcm: allow start or stop during pause for backend
Date:   Thu, 16 Apr 2020 15:22:37 +0200
Message-Id: <20200416131334.384752718@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: 이경택 <gt82.lee@samsung.com>

commit 21fca8bdbb64df1297e8c65a746c4c9f4a689751 upstream.

soc_compr_trigger_fe() allows start or stop after pause_push.
In dpcm_be_dai_trigger(), however, only pause_release is allowed
command after pause_push.
So, start or stop after pause in compress offload is always
returned as error if the compress offload is used with dpcm.
To fix the problem, SND_SOC_DPCM_STATE_PAUSED should be allowed
for start or stop command.

Signed-off-by: Gyeongtaek Lee <gt82.lee@samsung.com>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/004d01d607c1$7a3d5250$6eb7f6f0$@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-pcm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -2236,7 +2236,8 @@ int dpcm_be_dai_trigger(struct snd_soc_p
 		switch (cmd) {
 		case SNDRV_PCM_TRIGGER_START:
 			if ((be->dpcm[stream].state != SND_SOC_DPCM_STATE_PREPARE) &&
-			    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_STOP))
+			    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_STOP) &&
+			    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_PAUSED))
 				continue;
 
 			ret = dpcm_do_trigger(dpcm, be_substream, cmd);
@@ -2266,7 +2267,8 @@ int dpcm_be_dai_trigger(struct snd_soc_p
 			be->dpcm[stream].state = SND_SOC_DPCM_STATE_START;
 			break;
 		case SNDRV_PCM_TRIGGER_STOP:
-			if (be->dpcm[stream].state != SND_SOC_DPCM_STATE_START)
+			if ((be->dpcm[stream].state != SND_SOC_DPCM_STATE_START) &&
+			    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_PAUSED))
 				continue;
 
 			if (!snd_soc_dpcm_can_be_free_stop(fe, be, stream))


