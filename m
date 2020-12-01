Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C065B2C9AA6
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388164AbgLAI7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:59:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:35418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388149AbgLAI7e (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:59:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C6C12222C;
        Tue,  1 Dec 2020 08:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813133;
        bh=rW0ulsd0x2mf4yx9x+CuPh113Gw6V2chp8HuAY/tGUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GSBPFTrUbVKwghk4314KqPrQ4LKBZg3EFDXc/F2pRoPTwc4d9/AHvNrXQIg+b+GsP
         0HoWv3ZsFDJFiKgZ7X2uauef2qBuDq1iITjDUaA2//m0wSYB2O16qS0aEuDBYrkWoO
         eGDePIojXPI+FLLbd9LA27s1tA936fB7QgzHVmQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>
Subject: [PATCH 4.14 44/50] usb: gadget: f_midi: Fix memleak in f_midi_alloc
Date:   Tue,  1 Dec 2020 09:53:43 +0100
Message-Id: <20201201084650.332320199@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084644.803812112@linuxfoundation.org>
References: <20201201084644.803812112@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

commit e7694cb6998379341fd9bf3bd62b48c4e6a79385 upstream.

In the error path, if midi is not null, we should
free the midi->id if necessary to prevent memleak.

Fixes: b85e9de9e818d ("usb: gadget: f_midi: convert to new function interface with backward compatibility")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201117021629.1470544-2-zhangqilong3@huawei.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/function/f_midi.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -1303,7 +1303,7 @@ static struct usb_function *f_midi_alloc
 	midi->id = kstrdup(opts->id, GFP_KERNEL);
 	if (opts->id && !midi->id) {
 		status = -ENOMEM;
-		goto setup_fail;
+		goto midi_free;
 	}
 	midi->in_ports = opts->in_ports;
 	midi->out_ports = opts->out_ports;
@@ -1315,7 +1315,7 @@ static struct usb_function *f_midi_alloc
 
 	status = kfifo_alloc(&midi->in_req_fifo, midi->qlen, GFP_KERNEL);
 	if (status)
-		goto setup_fail;
+		goto midi_free;
 
 	spin_lock_init(&midi->transmit_lock);
 
@@ -1331,9 +1331,13 @@ static struct usb_function *f_midi_alloc
 
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
 


