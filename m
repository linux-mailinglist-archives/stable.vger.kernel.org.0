Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4A521B34A
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 12:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgGJKlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 06:41:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgGJKkp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 06:40:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23D8920767;
        Fri, 10 Jul 2020 10:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594377644;
        bh=mYmhqC2+fRZ5NSFr0QrBX4ayvtcDm9hSNrpu+vut8r4=;
        h=Subject:To:From:Date:From;
        b=zq3GrSNiMH/MC+rnTXaCGj/ia4vXwuLuwTd0drY2Se0hNALPfvSgeAnLNSgHk2Phj
         H0W2aZl1y6R5f1wMd9CwyeHV7cmO3fOQSeH+d0Qsx9fKN3fC52fr0XV3QjHZtBmXIC
         oFVlHaYpHqtYWXnHrIlpdXcosRI9gyHjOa/chXV4=
Subject: patch "usb: gadget: function: fix missing spinlock in f_uac1_legacy" added to usb-linus
To:     qiang.zhang@windriver.com, balbi@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Jul 2020 12:40:30 +0200
Message-ID: <15943776303364@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: function: fix missing spinlock in f_uac1_legacy

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 8778eb0927ddcd3f431805c37b78fa56481aeed9 Mon Sep 17 00:00:00 2001
From: Zhang Qiang <qiang.zhang@windriver.com>
Date: Mon, 6 Jul 2020 13:14:55 +0800
Subject: usb: gadget: function: fix missing spinlock in f_uac1_legacy

Add a missing spinlock protection for play_queue, because
the play_queue may be destroyed when the "playback_work"
work func and "f_audio_out_ep_complete" callback func
operate this paly_queue at the same time.

Fixes: c6994e6f067cf ("USB: gadget: add USB Audio Gadget driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Zhang Qiang <qiang.zhang@windriver.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
---
 drivers/usb/gadget/function/f_uac1_legacy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/function/f_uac1_legacy.c b/drivers/usb/gadget/function/f_uac1_legacy.c
index 349deae7cabd..e2d7f69128a0 100644
--- a/drivers/usb/gadget/function/f_uac1_legacy.c
+++ b/drivers/usb/gadget/function/f_uac1_legacy.c
@@ -336,7 +336,9 @@ static int f_audio_out_ep_complete(struct usb_ep *ep, struct usb_request *req)
 
 	/* Copy buffer is full, add it to the play_queue */
 	if (audio_buf_size - copy_buf->actual < req->actual) {
+		spin_lock_irq(&audio->lock);
 		list_add_tail(&copy_buf->list, &audio->play_queue);
+		spin_unlock_irq(&audio->lock);
 		schedule_work(&audio->playback_work);
 		copy_buf = f_audio_buffer_alloc(audio_buf_size);
 		if (IS_ERR(copy_buf))
-- 
2.27.0


