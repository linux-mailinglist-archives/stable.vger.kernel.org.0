Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA4714831EE
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbiACOXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbiACOWl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:22:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1EDC061799;
        Mon,  3 Jan 2022 06:22:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5B45CCE1109;
        Mon,  3 Jan 2022 14:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ADAAC36AEB;
        Mon,  3 Jan 2022 14:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219757;
        bh=yLmwlPHdrpgmr0YEKzev50jgMT2p9jeYzVcPI2wHECc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mj82lD5q83PbIb4YNH9MfYIeAwAIO/aPjqJChaxkVXV3kRTcRmeHdPEPtTAz6wgyi
         +jcp4PqZw/pvoKU8Pz3ZbxtbYtIzL/Lhw+Kzw+bbViNNcwk3XaboAOvQYxuu6TqHZN
         KiKBUQlMl3i4HoJ3TcDsqmoWBCkf77M5d9QiR6QM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        syzbot+b88c5eae27386b252bbd@syzkaller.appspotmail.com
Subject: [PATCH 4.9 11/13] Input: appletouch - initialize work before device registration
Date:   Mon,  3 Jan 2022 15:21:27 +0100
Message-Id: <20220103142052.322735673@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142051.979780231@linuxfoundation.org>
References: <20220103142051.979780231@linuxfoundation.org>
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
@@ -929,6 +929,8 @@ static int atp_probe(struct usb_interfac
 	set_bit(BTN_TOOL_TRIPLETAP, input_dev->keybit);
 	set_bit(BTN_LEFT, input_dev->keybit);
 
+	INIT_WORK(&dev->work, atp_reinit);
+
 	error = input_register_device(dev->input);
 	if (error)
 		goto err_free_buffer;
@@ -936,8 +938,6 @@ static int atp_probe(struct usb_interfac
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(iface, dev);
 
-	INIT_WORK(&dev->work, atp_reinit);
-
 	return 0;
 
  err_free_buffer:


