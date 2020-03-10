Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6A5B17F9FE
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730306AbgCJNBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:01:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730301AbgCJNBq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:01:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 304F0208E4;
        Tue, 10 Mar 2020 13:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845304;
        bh=+0bE9AnUUnBHfZymFLJ6v1yRQIvnXg2wN7XdV/kmGbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b0iMold1YFumqyma99OboESNyiShIpMo1x0hwcrPzXIatPh/cMvHC24r0My5pqTwn
         27GbR1vIRCwAUCT+LavsUwxDRw6COXLLHYhCWiNOsTihHWj2xKxcPU1jbrtdO7XF0f
         eu/9mE+iyPs02Ny5T683vMALRuxLGfrYSBwLx3OA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.5 135/189] ASoC: pcm: Fix possible buffer overflow in dpcm state sysfs output
Date:   Tue, 10 Mar 2020 13:39:32 +0100
Message-Id: <20200310123653.473786798@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 6c89ffea60aa3b2a33ae7987de1e84bfb89e4c9e upstream.

dpcm_show_state() invokes multiple snprintf() calls to concatenate
formatted strings on the fixed size buffer.  The usage of snprintf()
is supposed for avoiding the buffer overflow, but it doesn't work as
expected because snprintf() doesn't return the actual output size but
the size to be written.

Fix this bug by replacing all snprintf() calls with scnprintf()
calls.

Fixes: f86dcef87b77 ("ASoC: dpcm: Add debugFS support for DPCM")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Acked-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20200218111737.14193-4-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-pcm.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -3192,16 +3192,16 @@ static ssize_t dpcm_show_state(struct sn
 	unsigned long flags;
 
 	/* FE state */
-	offset += snprintf(buf + offset, size - offset,
+	offset += scnprintf(buf + offset, size - offset,
 			"[%s - %s]\n", fe->dai_link->name,
 			stream ? "Capture" : "Playback");
 
-	offset += snprintf(buf + offset, size - offset, "State: %s\n",
+	offset += scnprintf(buf + offset, size - offset, "State: %s\n",
 	                dpcm_state_string(fe->dpcm[stream].state));
 
 	if ((fe->dpcm[stream].state >= SND_SOC_DPCM_STATE_HW_PARAMS) &&
 	    (fe->dpcm[stream].state <= SND_SOC_DPCM_STATE_STOP))
-		offset += snprintf(buf + offset, size - offset,
+		offset += scnprintf(buf + offset, size - offset,
 				"Hardware Params: "
 				"Format = %s, Channels = %d, Rate = %d\n",
 				snd_pcm_format_name(params_format(params)),
@@ -3209,10 +3209,10 @@ static ssize_t dpcm_show_state(struct sn
 				params_rate(params));
 
 	/* BEs state */
-	offset += snprintf(buf + offset, size - offset, "Backends:\n");
+	offset += scnprintf(buf + offset, size - offset, "Backends:\n");
 
 	if (list_empty(&fe->dpcm[stream].be_clients)) {
-		offset += snprintf(buf + offset, size - offset,
+		offset += scnprintf(buf + offset, size - offset,
 				" No active DSP links\n");
 		goto out;
 	}
@@ -3222,16 +3222,16 @@ static ssize_t dpcm_show_state(struct sn
 		struct snd_soc_pcm_runtime *be = dpcm->be;
 		params = &dpcm->hw_params;
 
-		offset += snprintf(buf + offset, size - offset,
+		offset += scnprintf(buf + offset, size - offset,
 				"- %s\n", be->dai_link->name);
 
-		offset += snprintf(buf + offset, size - offset,
+		offset += scnprintf(buf + offset, size - offset,
 				"   State: %s\n",
 				dpcm_state_string(be->dpcm[stream].state));
 
 		if ((be->dpcm[stream].state >= SND_SOC_DPCM_STATE_HW_PARAMS) &&
 		    (be->dpcm[stream].state <= SND_SOC_DPCM_STATE_STOP))
-			offset += snprintf(buf + offset, size - offset,
+			offset += scnprintf(buf + offset, size - offset,
 				"   Hardware Params: "
 				"Format = %s, Channels = %d, Rate = %d\n",
 				snd_pcm_format_name(params_format(params)),


