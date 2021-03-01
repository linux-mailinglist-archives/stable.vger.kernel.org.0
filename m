Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA7F328AA8
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239585AbhCASU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:20:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:34282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239296AbhCASOK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:14:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18E2D65139;
        Mon,  1 Mar 2021 17:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618249;
        bh=+FK8FpHa6WcqRv6+hnYYgMTAEGgG/qmFLCsq7tswExE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=if973edNSMilTMK9ldNaLY4R/BtMONlIamyys/5fibzUpzy+ppe7SL93VT5CKntvD
         xWCrPJDflq8JlMbKNYe2qz4zpgr1uIsFiXi15St4HTgezORpDnqf1PCFA0RMs5Aaal
         tRge0b4wxD7ETxKCa8Mh3jnlg12PXoIma15HwBEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 019/663] ALSA: pcm: Dont call sync_stop if it hasnt been stopped
Date:   Mon,  1 Mar 2021 17:04:27 +0100
Message-Id: <20210301161142.739137166@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 700cb70730777c159a988e01daa93f20a1ae9b58 upstream.

The PCM stop operation sets the stop_operating flag for indicating the
sync_stop post-process.  This flag is, however, set unconditionally
even if the PCM trigger weren't issued.  This may lead to
inconsistency in the driver side.

Correct the code to set stop_operating flag only after the trigger
STOP is actually called.

Fixes: 1e850beea278 ("ALSA: pcm: Add the support for sync-stop operation")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210206203656.15959-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/pcm_native.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1421,8 +1421,10 @@ static int snd_pcm_do_stop(struct snd_pc
 			   snd_pcm_state_t state)
 {
 	if (substream->runtime->trigger_master == substream &&
-	    snd_pcm_running(substream))
+	    snd_pcm_running(substream)) {
 		substream->ops->trigger(substream, SNDRV_PCM_TRIGGER_STOP);
+		substream->runtime->stop_operating = true;
+	}
 	return 0; /* unconditonally stop all substreams */
 }
 
@@ -1435,7 +1437,6 @@ static void snd_pcm_post_stop(struct snd
 		runtime->status->state = state;
 		snd_pcm_timer_notify(substream, SNDRV_TIMER_EVENT_MSTOP);
 	}
-	runtime->stop_operating = true;
 	wake_up(&runtime->sleep);
 	wake_up(&runtime->tsleep);
 }


