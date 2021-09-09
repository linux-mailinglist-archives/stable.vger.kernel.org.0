Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B22404973
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236308AbhIILm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:42:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235980AbhIILmW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:42:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD98C61131;
        Thu,  9 Sep 2021 11:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187672;
        bh=Cf5iJfPCfnqcbMi2dOm33gudUTASml1cZBfmccBtGLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rs78NzAh8Soc6wX6N2CHSzvZ4ihNrqAvEr4U+VVdZ2TRFYkUfsydEbMGFYcWx4nz6
         Kl4FHtzG0O1mQVDAO2GghgGOXe7eyOrCC+DCqIuXYahpwGt+zjgVkug5VonEJNYNM2
         YW5TBqtAQ0WAQwI1CFe17j1fBod5pPnpmqxpvALg5bKeg4+dfGH/BNy19GmtkftI0O
         lISFhs7sBO11QQdvUpAZgWgDPYvbPfrKCeehAP6DIiWfdLHImp0kmFcyaX+3m0+beW
         J1ScQ1MAa8P2FHAlsiNAFUbJPzZlAvAde02WQQdce/toJAl3FZvWRfjwShFrigIkJt
         a5R1bDf4uxUSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dom Cobley <popcornmix@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.14 004/252] drm/vc4: hdmi: Set HD_CTL_WHOLSMP and HD_CTL_CHALIGN_SET
Date:   Thu,  9 Sep 2021 07:36:58 -0400
Message-Id: <20210909114106.141462-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dom Cobley <popcornmix@gmail.com>

[ Upstream commit 1698ecb218eb82587dbfc71a2e26ded66e5ecf59 ]

Symptom is random switching of speakers when using multichannel.

Repeatedly running speakertest -c8 occasionally starts with
channels jumbled. This is fixed with HD_CTL_WHOLSMP.

The other bit looks beneficial and apears harmless in testing so
I'd suggest adding it too.

Documentation says: HD_CTL_WHILSMP_SET
Wait for whole sample. When this bit is set MAI transmit will start
only when there is at least one whole sample available in the fifo.

Documentation says: HD_CTL_CHALIGN_SET
Channel Align When Overflow. This bit is used to realign the audio
channels in case of an overflow.
If this bit is set, after the detection of an overflow, equal
amount of dummy words to the missing words will be written to fifo,
filling up the broken sample and maintaining alignment.

Signed-off-by: Dom Cobley <popcornmix@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Nicolas Saenz Julienne <nsaenz@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210525132354.297468-7-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index c2876731ee2d..ad92dbb128b3 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1372,7 +1372,9 @@ static int vc4_hdmi_audio_trigger(struct snd_pcm_substream *substream, int cmd,
 		HDMI_WRITE(HDMI_MAI_CTL,
 			   VC4_SET_FIELD(vc4_hdmi->audio.channels,
 					 VC4_HD_MAI_CTL_CHNUM) |
-			   VC4_HD_MAI_CTL_ENABLE);
+					 VC4_HD_MAI_CTL_WHOLSMP |
+					 VC4_HD_MAI_CTL_CHALIGN |
+					 VC4_HD_MAI_CTL_ENABLE);
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
 		HDMI_WRITE(HDMI_MAI_CTL,
-- 
2.30.2

