Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9347CA8EFB
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387934AbfIDSBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:01:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387794AbfIDSBJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:01:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE04E21883;
        Wed,  4 Sep 2019 18:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620068;
        bh=MUTO3g991shrs0aNYP3y/Q8wgM/a8IkSaMH382n+5G0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gHj02a3FP4t7bR9BeKyAVcJVlGYLjdgWegQJaaGn7cst0e8TqZJ3Ck2s6nqDgnk5R
         VAUgjLHH5dt4P/0d0ZY0eeb0khwMrXD+OCN8DpITPSrCGgCO2+tYBTooN8Uch+8gDv
         Ld/TMeXkiefPMTfxo0V/dz2NQSB7B/4JfH6YpEcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+4a75454b9ca2777f35c7@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 60/83] ALSA: seq: Fix potential concurrent access to the deleted pool
Date:   Wed,  4 Sep 2019 19:53:52 +0200
Message-Id: <20190904175308.879196769@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.488266791@linuxfoundation.org>
References: <20190904175303.488266791@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 75545304eba6a3d282f923b96a466dc25a81e359 upstream.

The input pool of a client might be deleted via the resize ioctl, the
the access to it should be covered by the proper locks.  Currently the
only missing place is the call in snd_seq_ioctl_get_client_pool(), and
this patch papers over it.

Reported-by: syzbot+4a75454b9ca2777f35c7@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/seq/seq_clientmgr.c |    3 +--
 sound/core/seq/seq_fifo.c      |   17 +++++++++++++++++
 sound/core/seq/seq_fifo.h      |    2 ++
 3 files changed, 20 insertions(+), 2 deletions(-)

--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -1822,8 +1822,7 @@ static int snd_seq_ioctl_get_client_pool
 	if (cptr->type == USER_CLIENT) {
 		info->input_pool = cptr->data.user.fifo_pool_size;
 		info->input_free = info->input_pool;
-		if (cptr->data.user.fifo)
-			info->input_free = snd_seq_unused_cells(cptr->data.user.fifo->pool);
+		info->input_free = snd_seq_fifo_unused_cells(cptr->data.user.fifo);
 	} else {
 		info->input_pool = 0;
 		info->input_free = 0;
--- a/sound/core/seq/seq_fifo.c
+++ b/sound/core/seq/seq_fifo.c
@@ -278,3 +278,20 @@ int snd_seq_fifo_resize(struct snd_seq_f
 
 	return 0;
 }
+
+/* get the number of unused cells safely */
+int snd_seq_fifo_unused_cells(struct snd_seq_fifo *f)
+{
+	unsigned long flags;
+	int cells;
+
+	if (!f)
+		return 0;
+
+	snd_use_lock_use(&f->use_lock);
+	spin_lock_irqsave(&f->lock, flags);
+	cells = snd_seq_unused_cells(f->pool);
+	spin_unlock_irqrestore(&f->lock, flags);
+	snd_use_lock_free(&f->use_lock);
+	return cells;
+}
--- a/sound/core/seq/seq_fifo.h
+++ b/sound/core/seq/seq_fifo.h
@@ -68,5 +68,7 @@ int snd_seq_fifo_poll_wait(struct snd_se
 /* resize pool in fifo */
 int snd_seq_fifo_resize(struct snd_seq_fifo *f, int poolsize);
 
+/* get the number of unused cells safely */
+int snd_seq_fifo_unused_cells(struct snd_seq_fifo *f);
 
 #endif


