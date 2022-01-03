Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070994832DF
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbiACObX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:31:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59760 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234888AbiACOaH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:30:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C767F60FA2;
        Mon,  3 Jan 2022 14:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A864BC36AED;
        Mon,  3 Jan 2022 14:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220206;
        bh=vyj/Vkr9EC4mEIQsxIDbkkOi9a3R9gjtU12B8TPCGuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMhsmYSB8RuZc3mBFsh6R7iXSkt34yiqSeEVLppniKnqFKP+FqOYey48C+f4Z8i3F
         c5ImhhCSCdPfvcNcTiInHibOdTIWJPocrCTAz9aJmqSGzel0HysWBFIxtJ21flSB9i
         wHmwPKdxPIqd1trGDlnvGLbx9WUveeKDx+PYAypk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        syzbot+b88c5eae27386b252bbd@syzkaller.appspotmail.com
Subject: [PATCH 5.10 44/48] Input: appletouch - initialize work before device registration
Date:   Mon,  3 Jan 2022 15:24:21 +0100
Message-Id: <20220103142054.963419345@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142053.466768714@linuxfoundation.org>
References: <20220103142053.466768714@linuxfoundation.org>
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
@@ -916,6 +916,8 @@ static int atp_probe(struct usb_interfac
 	set_bit(BTN_TOOL_TRIPLETAP, input_dev->keybit);
 	set_bit(BTN_LEFT, input_dev->keybit);
 
+	INIT_WORK(&dev->work, atp_reinit);
+
 	error = input_register_device(dev->input);
 	if (error)
 		goto err_free_buffer;
@@ -923,8 +925,6 @@ static int atp_probe(struct usb_interfac
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(iface, dev);
 
-	INIT_WORK(&dev->work, atp_reinit);
-
 	return 0;
 
  err_free_buffer:


