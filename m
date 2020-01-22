Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBFC145043
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387990AbgAVJpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:45:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:39044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387964AbgAVJpJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:45:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 023922468A;
        Wed, 22 Jan 2020 09:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686308;
        bh=3jttVuVIpyLVypebi/XVFW10xAl7ANlVHDLRR78vqVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GMGKooPalKzC/SyVdwF1EwQmIGycgyR3wg7brIj7QWNBZtvm+vq229TLBnYhG8vUW
         ecoPlQ1cIFacsGFyxKELc0UimLMycrJ02vjk1Y26TErfzU50eLH9T9FpuNzCvfLo3X
         7fDIeZq+mWv6we1Q2Or0i4iwP3RgGS1/da9WqQmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Bahling <sbahling@suse.com>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 024/222] ALSA: firewire-tascam: fix corruption due to spin lock without restoration in SoftIRQ context
Date:   Wed, 22 Jan 2020 10:26:50 +0100
Message-Id: <20200122092835.155860714@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 747d1f076de5a60770011f6e512de43298ec64cb upstream.

ALSA firewire-tascam driver can bring corruption due to spin lock without
restoration of IRQ flag in SoftIRQ context. This commit fixes the bug.

Cc: Scott Bahling <sbahling@suse.com>
Cc: <stable@vger.kernel.org> # v4.21
Fixes: d7167422433c ("ALSA: firewire-tascam: queue events for change of control surface")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20200113085719.26788-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/firewire/tascam/amdtp-tascam.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/sound/firewire/tascam/amdtp-tascam.c
+++ b/sound/firewire/tascam/amdtp-tascam.c
@@ -157,14 +157,15 @@ static void read_status_messages(struct
 			if ((before ^ after) & mask) {
 				struct snd_firewire_tascam_change *entry =
 						&tscm->queue[tscm->push_pos];
+				unsigned long flag;
 
-				spin_lock_irq(&tscm->lock);
+				spin_lock_irqsave(&tscm->lock, flag);
 				entry->index = index;
 				entry->before = before;
 				entry->after = after;
 				if (++tscm->push_pos >= SND_TSCM_QUEUE_COUNT)
 					tscm->push_pos = 0;
-				spin_unlock_irq(&tscm->lock);
+				spin_unlock_irqrestore(&tscm->lock, flag);
 
 				wake_up(&tscm->hwdep_wait);
 			}


