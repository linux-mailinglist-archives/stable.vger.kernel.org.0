Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29BB3D5EE0
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236634AbhGZPLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:11:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236385AbhGZPIQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:08:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C775A60F6B;
        Mon, 26 Jul 2021 15:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314523;
        bh=Pz5znl3oCRXX/Ot8HGsKGVlif7ze/TLXcSlFz9LJoDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tmK7OXeAhWRA70gpMl7U976uiA5+4Fy8lqvyNHHaFOgK4zoiz30Ul6BllG+Vx01dL
         U69NsJO7msiDNx1eiMJWiD3QYwFgloJE8iiWIJ8rOBBP++JNf41gjzykNRlSD6GP4G
         W09xk9VulgeQ6C9cuCQ6KmBEkQvhR4j+8R3lcyGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 61/82] ALSA: sb: Fix potential ABBA deadlock in CSP driver
Date:   Mon, 26 Jul 2021 17:39:01 +0200
Message-Id: <20210726153830.156174967@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153828.144714469@linuxfoundation.org>
References: <20210726153828.144714469@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 1c2b9519159b470ef24b2638f4794e86e2952ab7 upstream.

SB16 CSP driver may hit potentially a typical ABBA deadlock in two
code paths:

 In snd_sb_csp_stop():
     spin_lock_irqsave(&p->chip->mixer_lock, flags);
     spin_lock(&p->chip->reg_lock);

 In snd_sb_csp_load():
     spin_lock_irqsave(&p->chip->reg_lock, flags);
     spin_lock(&p->chip->mixer_lock);

Also the similar pattern is seen in snd_sb_csp_start().

Although the practical impact is very small (those states aren't
triggered in the same running state and this happens only on a real
hardware, decades old ISA sound boards -- which must be very difficult
to find nowadays), it's a real scenario and has to be fixed.

This patch addresses those deadlocks by splitting the locks in
snd_sb_csp_start() and snd_sb_csp_stop() for avoiding the nested
locks.

Reported-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/7b0fcdaf-cd4f-4728-2eae-48c151a92e10@gmail.com
Link: https://lore.kernel.org/r/20210716132723.13216-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/isa/sb/sb16_csp.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/isa/sb/sb16_csp.c
+++ b/sound/isa/sb/sb16_csp.c
@@ -828,6 +828,7 @@ static int snd_sb_csp_start(struct snd_s
 	mixR = snd_sbmixer_read(p->chip, SB_DSP4_PCM_DEV + 1);
 	snd_sbmixer_write(p->chip, SB_DSP4_PCM_DEV, mixL & 0x7);
 	snd_sbmixer_write(p->chip, SB_DSP4_PCM_DEV + 1, mixR & 0x7);
+	spin_unlock_irqrestore(&p->chip->mixer_lock, flags);
 
 	spin_lock(&p->chip->reg_lock);
 	set_mode_register(p->chip, 0xc0);	/* c0 = STOP */
@@ -867,6 +868,7 @@ static int snd_sb_csp_start(struct snd_s
 	spin_unlock(&p->chip->reg_lock);
 
 	/* restore PCM volume */
+	spin_lock_irqsave(&p->chip->mixer_lock, flags);
 	snd_sbmixer_write(p->chip, SB_DSP4_PCM_DEV, mixL);
 	snd_sbmixer_write(p->chip, SB_DSP4_PCM_DEV + 1, mixR);
 	spin_unlock_irqrestore(&p->chip->mixer_lock, flags);
@@ -892,6 +894,7 @@ static int snd_sb_csp_stop(struct snd_sb
 	mixR = snd_sbmixer_read(p->chip, SB_DSP4_PCM_DEV + 1);
 	snd_sbmixer_write(p->chip, SB_DSP4_PCM_DEV, mixL & 0x7);
 	snd_sbmixer_write(p->chip, SB_DSP4_PCM_DEV + 1, mixR & 0x7);
+	spin_unlock_irqrestore(&p->chip->mixer_lock, flags);
 
 	spin_lock(&p->chip->reg_lock);
 	if (p->running & SNDRV_SB_CSP_ST_QSOUND) {
@@ -906,6 +909,7 @@ static int snd_sb_csp_stop(struct snd_sb
 	spin_unlock(&p->chip->reg_lock);
 
 	/* restore PCM volume */
+	spin_lock_irqsave(&p->chip->mixer_lock, flags);
 	snd_sbmixer_write(p->chip, SB_DSP4_PCM_DEV, mixL);
 	snd_sbmixer_write(p->chip, SB_DSP4_PCM_DEV + 1, mixR);
 	spin_unlock_irqrestore(&p->chip->mixer_lock, flags);


