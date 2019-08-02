Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6507F323
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406245AbfHBJxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:53:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406198AbfHBJx3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:53:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDCEE2086A;
        Fri,  2 Aug 2019 09:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739608;
        bh=ZD/d7wEanQe31gJ/K5UdbGiLfybN+idHdUps5k0IfR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bdTov3dQJlhTETZxwZIreIsmzqtDxUlcwZGn1/Tv4phuUbcxOd61TNMxPvjFL64qL
         OGKwsCNrbhGuWFVTQxeqDSkLzkSxhj0JVteINABOP5SpQx5jwVeA4laBQOP9jxM3yE
         5qtRKeNUukQwkHU4jhWlLOLtU5Sn1OZMnhvrAmd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+357d86bcb4cca1a2f572@syzkaller.appspotmail.com,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.9 217/223] media: au0828: fix null dereference in error path
Date:   Fri,  2 Aug 2019 11:37:22 +0200
Message-Id: <20190802092250.761351262@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

commit 6d0d1ff9ff21fbb06b867c13a1d41ce8ddcd8230 upstream.

au0828_usb_disconnect() gets the au0828_dev struct via usb_get_intfdata,
so it needs to set up for the error paths.

Reported-by: syzbot+357d86bcb4cca1a2f572@syzkaller.appspotmail.com
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/au0828/au0828-core.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -630,6 +630,12 @@ static int au0828_usb_probe(struct usb_i
 	/* Setup */
 	au0828_card_setup(dev);
 
+	/*
+	 * Store the pointer to the au0828_dev so it can be accessed in
+	 * au0828_usb_disconnect
+	 */
+	usb_set_intfdata(interface, dev);
+
 	/* Analog TV */
 	retval = au0828_analog_register(dev, interface);
 	if (retval) {
@@ -647,12 +653,6 @@ static int au0828_usb_probe(struct usb_i
 	/* Remote controller */
 	au0828_rc_register(dev);
 
-	/*
-	 * Store the pointer to the au0828_dev so it can be accessed in
-	 * au0828_usb_disconnect
-	 */
-	usb_set_intfdata(interface, dev);
-
 	pr_info("Registered device AU0828 [%s]\n",
 		dev->board.name == NULL ? "Unset" : dev->board.name);
 


