Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150F5483244
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbiACO0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233585AbiACOZr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:25:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66559C06179E;
        Mon,  3 Jan 2022 06:25:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B3BF0CE10AB;
        Mon,  3 Jan 2022 14:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BEFBC36AED;
        Mon,  3 Jan 2022 14:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219944;
        bh=+2sqXt9wy7ZRWhuykIJzX3BPDlPPVvL5n15pXwXX0ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LyI7v1MaO9UCDI/0SGjlSD4fReAy9K7M3K+A21KOtZqbE/4zHXKAmM9bTdH9j7Aqg
         ZdgwZI1Co7RKkIpWopUstlimV8NU4u9IGNCFhCoCNpI0m+BJzPyENJ2TB4qE8sYr/T
         oZz35Sk0/n2W2ZMr9b6qSYBdnEscAV5tkXTUewJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        syzbot+b88c5eae27386b252bbd@syzkaller.appspotmail.com
Subject: [PATCH 4.19 25/27] Input: appletouch - initialize work before device registration
Date:   Mon,  3 Jan 2022 15:24:05 +0100
Message-Id: <20220103142052.975148806@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142052.162223000@linuxfoundation.org>
References: <20220103142052.162223000@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit 9f3ccdc3f6ef10084ceb3a47df0961bec6196fd0 upstream.

Syzbot has reported warning in __flush_work(). This warning is caused by
work->func == NULL, which means missing work initialization.

This may happen, since input_dev->close() calls
cancel_work_sync(&dev->work), but dev->work initalization happens _after_
input_register_device() call.

So this patch moves dev->work initialization before registering input
device

Fixes: 5a6eb676d3bc ("Input: appletouch - improve powersaving for Geyser3 devices")
Reported-and-tested-by: syzbot+b88c5eae27386b252bbd@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Link: https://lore.kernel.org/r/20211230141151.17300-1-paskripkin@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/appletouch.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/input/mouse/appletouch.c
+++ b/drivers/input/mouse/appletouch.c
@@ -930,6 +930,8 @@ static int atp_probe(struct usb_interfac
 	set_bit(BTN_TOOL_TRIPLETAP, input_dev->keybit);
 	set_bit(BTN_LEFT, input_dev->keybit);
 
+	INIT_WORK(&dev->work, atp_reinit);
+
 	error = input_register_device(dev->input);
 	if (error)
 		goto err_free_buffer;
@@ -937,8 +939,6 @@ static int atp_probe(struct usb_interfac
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(iface, dev);
 
-	INIT_WORK(&dev->work, atp_reinit);
-
 	return 0;
 
  err_free_buffer:


