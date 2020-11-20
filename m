Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9832BAEFD
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 16:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbgKTPcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 10:32:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:35948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728350AbgKTPcb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 10:32:31 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED466238E6;
        Fri, 20 Nov 2020 15:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605886349;
        bh=fMnKhUKpKgJPvSBKalcNnc7FOizrCoA91gw6SWF8sig=;
        h=Subject:To:From:Date:From;
        b=onMtQfpRPXRXVd1Ra0HpvZdNJLwlYdn52mqbrbsfW0t7c1jjQzksYPtSxKPpfaGgS
         meRAKXW9/GTPtxjRqm6Pu4o2/u9IUpob1qlaTc6f6xO8FMneep0cm7V8PouXnR6DlR
         2MgUx/TO4cT9j60JIR36wmBk/FAgeg7f/4rYlOhw=
Subject: patch "usb: gadget: f_midi: Fix memleak in f_midi_alloc" added to usb-linus
To:     zhangqilong3@huawei.com, gregkh@linuxfoundation.org,
        hulkci@huawei.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 20 Nov 2020 16:33:03 +0100
Message-ID: <160588638396222@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: f_midi: Fix memleak in f_midi_alloc

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e7694cb6998379341fd9bf3bd62b48c4e6a79385 Mon Sep 17 00:00:00 2001
From: Zhang Qilong <zhangqilong3@huawei.com>
Date: Tue, 17 Nov 2020 10:16:28 +0800
Subject: usb: gadget: f_midi: Fix memleak in f_midi_alloc

In the error path, if midi is not null, we should
free the midi->id if necessary to prevent memleak.

Fixes: b85e9de9e818d ("usb: gadget: f_midi: convert to new function interface with backward compatibility")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201117021629.1470544-2-zhangqilong3@huawei.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_midi.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/function/f_midi.c b/drivers/usb/gadget/function/f_midi.c
index 85cb15734aa8..19d97940eeb9 100644
--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -1315,7 +1315,7 @@ static struct usb_function *f_midi_alloc(struct usb_function_instance *fi)
 	midi->id = kstrdup(opts->id, GFP_KERNEL);
 	if (opts->id && !midi->id) {
 		status = -ENOMEM;
-		goto setup_fail;
+		goto midi_free;
 	}
 	midi->in_ports = opts->in_ports;
 	midi->out_ports = opts->out_ports;
@@ -1327,7 +1327,7 @@ static struct usb_function *f_midi_alloc(struct usb_function_instance *fi)
 
 	status = kfifo_alloc(&midi->in_req_fifo, midi->qlen, GFP_KERNEL);
 	if (status)
-		goto setup_fail;
+		goto midi_free;
 
 	spin_lock_init(&midi->transmit_lock);
 
@@ -1343,9 +1343,13 @@ static struct usb_function *f_midi_alloc(struct usb_function_instance *fi)
 
 	return &midi->func;
 
+midi_free:
+	if (midi)
+		kfree(midi->id);
+	kfree(midi);
 setup_fail:
 	mutex_unlock(&opts->lock);
-	kfree(midi);
+
 	return ERR_PTR(status);
 }
 
-- 
2.29.2


