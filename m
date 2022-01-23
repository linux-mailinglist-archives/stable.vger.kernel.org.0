Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0D5497203
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 15:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbiAWOVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 09:21:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35758 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233494AbiAWOVG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 09:21:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FF4760C9B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E91C340E2;
        Sun, 23 Jan 2022 14:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642947665;
        bh=denOeRbS0yzsz9i/S7NCR5NbAIwUys0lTD24IBVKyRI=;
        h=Subject:To:Cc:From:Date:From;
        b=nAgFpdqQck/UPo1Cd1BWawcZSsoswyZMkX+FR/d2UQ1yKeMz9OaVwYbSUHIM2yGnx
         WPP9HZibEzZhz8o7LaZn5J0ICjywhgmxhoYVLLsNjtIJl5poo6iMp9O+sL9zzULOGR
         J4MiBoNJbaOKGHf7Nvc9H0Le5W8tOqRtJ4wC1B0Q=
Subject: FAILED: patch "[PATCH] media: cpia2: fix control-message timeouts" failed to apply to 4.4-stable tree
To:     johan@kernel.org, hverkuil-cisco@xs4all.nl,
        mchehab+huawei@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 15:21:02 +0100
Message-ID: <16429476624628@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 10729be03327f53258cb196362015ad5c6eabe02 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Mon, 25 Oct 2021 13:16:37 +0100
Subject: [PATCH] media: cpia2: fix control-message timeouts

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: ab33d5071de7 ("V4L/DVB (3376): Add cpia2 camera support")
Cc: stable@vger.kernel.org      # 2.6.17
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

diff --git a/drivers/media/usb/cpia2/cpia2_usb.c b/drivers/media/usb/cpia2/cpia2_usb.c
index 76aac06f9fb8..cba03b286473 100644
--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -550,7 +550,7 @@ static int write_packet(struct usb_device *udev,
 			       0,	/* index */
 			       buf,	/* buffer */
 			       size,
-			       HZ);
+			       1000);
 
 	kfree(buf);
 	return ret;
@@ -582,7 +582,7 @@ static int read_packet(struct usb_device *udev,
 			       0,	/* index */
 			       buf,	/* buffer */
 			       size,
-			       HZ);
+			       1000);
 
 	if (ret >= 0)
 		memcpy(registers, buf, size);

