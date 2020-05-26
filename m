Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAFF11E2ACE
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 20:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389537AbgEZS7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:59:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390475AbgEZS7N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:59:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70B3820849;
        Tue, 26 May 2020 18:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519552;
        bh=N6ehpuoCQv6kH0tgSy7p5WhQqA0oIC2CBTQ03EHOEN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q0Jh/aFpL9NytphUkIzIbt9WpiQW7o/APri2Yo7twzwdcuNw7SGhNnth9x/NKxRDB
         tA4QCde02GrelcAjsIF+PaOJHk23lTZ0Rc/jxmJz0O9W4BRRvj23DqazDc94IT4u8m
         pLr6nvFE39JKbKxs9212I1PZiWRG9yhkQq6ceyQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brent Lu <brent.lu@intel.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 49/64] ALSA: pcm: fix incorrect hw_base increase
Date:   Tue, 26 May 2020 20:53:18 +0200
Message-Id: <20200526183930.012768084@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183913.064413230@linuxfoundation.org>
References: <20200526183913.064413230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brent Lu <brent.lu@intel.com>

commit e7513c5786f8b33f0c107b3759e433bc6cbb2efa upstream.

There is a corner case that ALSA keeps increasing the hw_ptr but DMA
already stop working/updating the position for a long time.

In following log we can see the position returned from DMA driver does
not move at all but the hw_ptr got increased at some point of time so
snd_pcm_avail() will return a large number which seems to be a buffer
underrun event from user space program point of view. The program
thinks there is space in the buffer and fill more data.

[  418.510086] sound pcmC0D5p: pos 96 hw_ptr 96 appl_ptr 4096 avail 12368
[  418.510149] sound pcmC0D5p: pos 96 hw_ptr 96 appl_ptr 6910 avail 9554
...
[  418.681052] sound pcmC0D5p: pos 96 hw_ptr 96 appl_ptr 15102 avail 1362
[  418.681130] sound pcmC0D5p: pos 96 hw_ptr 96 appl_ptr 16464 avail 0
[  418.726515] sound pcmC0D5p: pos 96 hw_ptr 16464 appl_ptr 16464 avail 16368

This is because the hw_base will be increased by runtime->buffer_size
frames unconditionally if the hw_ptr is not updated for over half of
buffer time. As the hw_base increases, so does the hw_ptr increased
by the same number.

The avail value returned from snd_pcm_avail() could exceed the limit
(buffer_size) easily becase the hw_ptr itself got increased by same
buffer_size samples when the corner case happens. In following log,
the buffer_size is 16368 samples but the avail is 21810 samples so
CRAS server complains about it.

[  418.851755] sound pcmC0D5p: pos 96 hw_ptr 16464 appl_ptr 27390 avail 5442
[  418.926491] sound pcmC0D5p: pos 96 hw_ptr 32832 appl_ptr 27390 avail 21810

cras_server[1907]: pcm_avail returned frames larger than buf_size:
sof-glkda7219max: :0,5: 21810 > 16368

By updating runtime->hw_ptr_jiffies each time the HWSYNC is called,
the hw_base will keep the same when buffer stall happens at long as
the interval between each HWSYNC call is shorter than half of buffer
time.

Following is a log captured by a patched kernel. The hw_base/hw_ptr
value is fixed in this corner case and user space program should be
aware of the buffer stall and handle it.

[  293.525543] sound pcmC0D5p: pos 96 hw_ptr 96 appl_ptr 4096 avail 12368
[  293.525606] sound pcmC0D5p: pos 96 hw_ptr 96 appl_ptr 6880 avail 9584
[  293.525975] sound pcmC0D5p: pos 96 hw_ptr 96 appl_ptr 10976 avail 5488
[  293.611178] sound pcmC0D5p: pos 96 hw_ptr 96 appl_ptr 15072 avail 1392
[  293.696429] sound pcmC0D5p: pos 96 hw_ptr 96 appl_ptr 16464 avail 0
...
[  381.139517] sound pcmC0D5p: pos 96 hw_ptr 96 appl_ptr 16464 avail 0

Signed-off-by: Brent Lu <brent.lu@intel.com>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1589776238-23877-1-git-send-email-brent.lu@intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/pcm_lib.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -456,6 +456,7 @@ static int snd_pcm_update_hw_ptr0(struct
 
  no_delta_check:
 	if (runtime->status->hw_ptr == new_hw_ptr) {
+		runtime->hw_ptr_jiffies = curr_jiffies;
 		update_audio_tstamp(substream, &curr_tstamp, &audio_tstamp);
 		return 0;
 	}


