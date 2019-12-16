Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E59F0121280
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 18:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfLPRxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:53:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:46482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727105AbfLPRxK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:53:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3416221582;
        Mon, 16 Dec 2019 17:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518789;
        bh=C+M+dkqlPuWxaT4c3/MwIJpUvrvzuALHtnCxEPl+/7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dbaIbYDko0CvmvFHEfvSj4tqZ0v+1HCRWS8WC/i03pd23hQTxfg5W23H+Iv/3Gjh8
         RgwCNAI6ecMKw9BUm03gKNBiGPW7B7/LGUx5+FLdALrCLUVNuCCQW9DEYvXj5dwPHs
         i4CrIv9lhR4JmPsiWIgsi8gfct6kGDE2O4+KQ1D0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, paulhsia <paulhsia@chromium.org>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 018/267] ALSA: pcm: Fix stream lock usage in snd_pcm_period_elapsed()
Date:   Mon, 16 Dec 2019 18:45:44 +0100
Message-Id: <20191216174851.027832266@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: paulhsia <paulhsia@chromium.org>

[ Upstream commit f5cdc9d4003a2f66ea57b3edd3e04acc2b1a4439 ]

If the nullity check for `substream->runtime` is outside of the lock
region, it is possible to have a null runtime in the critical section
if snd_pcm_detach_substream is called right before the lock.

Signed-off-by: paulhsia <paulhsia@chromium.org>
Link: https://lore.kernel.org/r/20191112171715.128727-2-paulhsia@chromium.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_lib.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 729a85a6211d6..80453266a2def 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1803,11 +1803,14 @@ void snd_pcm_period_elapsed(struct snd_pcm_substream *substream)
 	struct snd_pcm_runtime *runtime;
 	unsigned long flags;
 
-	if (PCM_RUNTIME_CHECK(substream))
+	if (snd_BUG_ON(!substream))
 		return;
-	runtime = substream->runtime;
 
 	snd_pcm_stream_lock_irqsave(substream, flags);
+	if (PCM_RUNTIME_CHECK(substream))
+		goto _unlock;
+	runtime = substream->runtime;
+
 	if (!snd_pcm_running(substream) ||
 	    snd_pcm_update_hw_ptr0(substream, 1) < 0)
 		goto _end;
@@ -1818,6 +1821,7 @@ void snd_pcm_period_elapsed(struct snd_pcm_substream *substream)
 #endif
  _end:
 	kill_fasync(&runtime->fasync, SIGIO, POLL_IN);
+ _unlock:
 	snd_pcm_stream_unlock_irqrestore(substream, flags);
 }
 EXPORT_SYMBOL(snd_pcm_period_elapsed);
-- 
2.20.1



