Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 985F02C0B1B
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732169AbgKWMjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:39:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:51648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732158AbgKWMjA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:39:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93BF22076E;
        Mon, 23 Nov 2020 12:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135140;
        bh=eM/A2Gt6qPDjT4lcbUVvMzb+xRiqchOcjtPCv+PF9YE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JoDYoNa/i1P9HfoOk6nPo/QRec+rasKM5TxU/wAnAy4ZTqGtAoZ0onN2sQFOUS3jP
         xZLB7HEhx1ecXy75yf3s4nM9EMEcPIHLM0D+ghLc0lgxHeC0b2qwm0QqCsu/0iFU4Y
         fwLN5DR8SzhEXD05kH/6lQGCTGyLGdAaZrP56kK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 117/158] ALSA: firewire: Clean up a locking issue in copy_resp_to_buf()
Date:   Mon, 23 Nov 2020 13:22:25 +0100
Message-Id: <20201123121825.583279079@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 02a9c6ee4183af2e438454c55098b828a96085fb upstream.

The spin_lock/unlock_irq() functions cannot be nested.  The problem is
that presumably we would want the IRQs to be re-enabled on the second
call the spin_unlock_irq() but instead it will be enabled at the first
call so IRQs will be enabled earlier than expected.

In this situation the copy_resp_to_buf() function is only called from
one function and it is called with IRQs disabled.  We can just use
the regular spin_lock/unlock() functions.

Fixes: 555e8a8f7f14 ("ALSA: fireworks: Add command/response functionality into hwdep interface")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201113101241.GB168908@mwanda
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/firewire/fireworks/fireworks_transaction.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/firewire/fireworks/fireworks_transaction.c
+++ b/sound/firewire/fireworks/fireworks_transaction.c
@@ -123,7 +123,7 @@ copy_resp_to_buf(struct snd_efw *efw, vo
 	t = (struct snd_efw_transaction *)data;
 	length = min_t(size_t, be32_to_cpu(t->length) * sizeof(u32), length);
 
-	spin_lock_irq(&efw->lock);
+	spin_lock(&efw->lock);
 
 	if (efw->push_ptr < efw->pull_ptr)
 		capacity = (unsigned int)(efw->pull_ptr - efw->push_ptr);
@@ -190,7 +190,7 @@ handle_resp_for_user(struct fw_card *car
 
 	copy_resp_to_buf(efw, data, length, rcode);
 end:
-	spin_unlock_irq(&instances_lock);
+	spin_unlock(&instances_lock);
 }
 
 static void


