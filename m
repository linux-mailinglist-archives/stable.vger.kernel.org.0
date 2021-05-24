Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA7638EF07
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbhEXPzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:55:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234751AbhEXPyQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:54:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 098366142E;
        Mon, 24 May 2021 15:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870788;
        bh=EpfJJYtQbUGsPIDR3pD1L5UTxEQMBOF4NR3qfbbSnzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yx4JGcVosPql9I7yRkuyJ/hqB2ESyARnq4POH0ViFX+w/wn9Wv3Hsz0KjynwZ5+mf
         yljMq5oEHsv72fgOeMD7dPRhQW81/Jc9eHk44nCxuO42b2++ii6jMAeW9wDiGhLNsm
         DTxw+FJG5jr4bUUEyxOKNTZ6lTUu6KJFDz73brok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 5.10 035/104] ALSA: intel8x0: Dont update period unless prepared
Date:   Mon, 24 May 2021 17:25:30 +0200
Message-Id: <20210524152333.987146891@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit c1f0616124c455c5c762b6f123e40bba5df759e6 upstream.

The interrupt handler of intel8x0 calls snd_intel8x0_update() whenever
the hardware sets the corresponding status bit for each stream.  This
works fine for most cases as long as the hardware behaves properly.
But when the hardware gives a wrong bit set, this leads to a zero-
division Oops, and reportedly, this seems what happened on a VM.

For fixing the crash, this patch adds a internal flag indicating that
the stream is ready to be updated, and check it (as well as the flag
being in suspended) to ignore such spurious update.

Cc: <stable@vger.kernel.org>
Reported-and-tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Link: https://lore.kernel.org/r/s5h5yzi7uh0.wl-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/intel8x0.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -354,6 +354,7 @@ struct ichdev {
 	unsigned int ali_slot;			/* ALI DMA slot */
 	struct ac97_pcm *pcm;
 	int pcm_open_flag;
+	unsigned int prepared:1;
 	unsigned int suspended: 1;
 };
 
@@ -714,6 +715,9 @@ static inline void snd_intel8x0_update(s
 	int status, civ, i, step;
 	int ack = 0;
 
+	if (!ichdev->prepared || ichdev->suspended)
+		return;
+
 	spin_lock_irqsave(&chip->reg_lock, flags);
 	status = igetbyte(chip, port + ichdev->roff_sr);
 	civ = igetbyte(chip, port + ICH_REG_OFF_CIV);
@@ -904,6 +908,7 @@ static int snd_intel8x0_hw_params(struct
 	if (ichdev->pcm_open_flag) {
 		snd_ac97_pcm_close(ichdev->pcm);
 		ichdev->pcm_open_flag = 0;
+		ichdev->prepared = 0;
 	}
 	err = snd_ac97_pcm_open(ichdev->pcm, params_rate(hw_params),
 				params_channels(hw_params),
@@ -925,6 +930,7 @@ static int snd_intel8x0_hw_free(struct s
 	if (ichdev->pcm_open_flag) {
 		snd_ac97_pcm_close(ichdev->pcm);
 		ichdev->pcm_open_flag = 0;
+		ichdev->prepared = 0;
 	}
 	return 0;
 }
@@ -999,6 +1005,7 @@ static int snd_intel8x0_pcm_prepare(stru
 			ichdev->pos_shift = (runtime->sample_bits > 16) ? 2 : 1;
 	}
 	snd_intel8x0_setup_periods(chip, ichdev);
+	ichdev->prepared = 1;
 	return 0;
 }
 


