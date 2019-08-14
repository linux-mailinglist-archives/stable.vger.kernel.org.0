Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F18348DBBF
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbfHNRCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:02:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728692AbfHNRCl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:02:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 575C7214DA;
        Wed, 14 Aug 2019 17:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802160;
        bh=UA/Qg49npwevYF1Z6UcRLmqGtITlBDjcFMc7R9mYah0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Te1suyDRFMfESLN9I7iG77033oPjfw75eY3NikL9Z+EXhFrKDo9xk9jlc/JjQR/6P
         2Cu+pRDukuxUXx4AdkI0qrPUQ/gGs0GOcUnFVGK3Efa7LNUtUqShfmdptPQWiwlzyV
         y5zK1QNmEaMma5w2WStAVRVgMR5iDUSTBpt2gR9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+a64a382964bf6c71a9c0@syzkaller.appspotmail.com,
        Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.2 018/144] usb: iowarrior: fix deadlock on disconnect
Date:   Wed, 14 Aug 2019 18:59:34 +0200
Message-Id: <20190814165800.645010340@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit c468a8aa790e0dfe0a7f8a39db282d39c2c00b46 upstream.

We have to drop the mutex before we close() upon disconnect()
as close() needs the lock. This is safe to do by dropping the
mutex as intfdata is already set to NULL, so open() will fail.

Fixes: 03f36e885fc26 ("USB: open disconnect race in iowarrior")
Reported-by: syzbot+a64a382964bf6c71a9c0@syzkaller.appspotmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20190808092728.23417-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/iowarrior.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -866,19 +866,20 @@ static void iowarrior_disconnect(struct
 	dev = usb_get_intfdata(interface);
 	mutex_lock(&iowarrior_open_disc_lock);
 	usb_set_intfdata(interface, NULL);
+	/* prevent device read, write and ioctl */
+	dev->present = 0;
 
 	minor = dev->minor;
+	mutex_unlock(&iowarrior_open_disc_lock);
+	/* give back our minor - this will call close() locks need to be dropped at this point*/
 
-	/* give back our minor */
 	usb_deregister_dev(interface, &iowarrior_class);
 
 	mutex_lock(&dev->mutex);
 
 	/* prevent device read, write and ioctl */
-	dev->present = 0;
 
 	mutex_unlock(&dev->mutex);
-	mutex_unlock(&iowarrior_open_disc_lock);
 
 	if (dev->opened) {
 		/* There is a process that holds a filedescriptor to the device ,


