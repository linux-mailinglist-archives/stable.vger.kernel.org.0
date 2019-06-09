Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59BB73A948
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388620AbfFIREb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:04:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388631AbfFIREb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:04:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D440320840;
        Sun,  9 Jun 2019 17:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099870;
        bh=z20JovjBjAaVI1irKytMq5ZxVjvUa1V4PARnyvM+2nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TBSJzLiYz+uRmgjikxLidXBYrwjCCvDOYJHslUidzfMvS3pKaPgn4x7N9+lJzkvHQ
         S9GrenfRbham+8U0c2oNVbj02YKBcvZ9xGsKUwmaqVewOn/TjxVqQHhXgBgvNOFMb3
         hdm/NzqPnEaCT0MIrkDZPnSizjZFBxShh8rwwxBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, oliver Neukum <oneukum@suse.com>,
        syzbot+a0cbdbd6d169020c8959@syzkaller.appspotmail.com
Subject: [PATCH 4.4 197/241] USB: sisusbvga: fix oops in error path of sisusb_probe
Date:   Sun,  9 Jun 2019 18:42:19 +0200
Message-Id: <20190609164153.668930689@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 9a5729f68d3a82786aea110b1bfe610be318f80a upstream.

The pointer used to log a failure of usb_register_dev() must
be set before the error is logged.

v2: fix that minor is not available before registration

Signed-off-by: oliver Neukum <oneukum@suse.com>
Reported-by: syzbot+a0cbdbd6d169020c8959@syzkaller.appspotmail.com
Fixes: 7b5cd5fefbe02 ("USB: SisUSB2VGA: Convert printk to dev_* macros")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/sisusbvga/sisusb.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3103,6 +3103,13 @@ static int sisusb_probe(struct usb_inter
 
 	mutex_init(&(sisusb->lock));
 
+	sisusb->sisusb_dev = dev;
+	sisusb->vrambase   = SISUSB_PCI_MEMBASE;
+	sisusb->mmiobase   = SISUSB_PCI_MMIOBASE;
+	sisusb->mmiosize   = SISUSB_PCI_MMIOSIZE;
+	sisusb->ioportbase = SISUSB_PCI_IOPORTBASE;
+	/* Everything else is zero */
+
 	/* Register device */
 	retval = usb_register_dev(intf, &usb_sisusb_class);
 	if (retval) {
@@ -3112,13 +3119,7 @@ static int sisusb_probe(struct usb_inter
 		goto error_1;
 	}
 
-	sisusb->sisusb_dev = dev;
-	sisusb->minor      = intf->minor;
-	sisusb->vrambase   = SISUSB_PCI_MEMBASE;
-	sisusb->mmiobase   = SISUSB_PCI_MMIOBASE;
-	sisusb->mmiosize   = SISUSB_PCI_MMIOSIZE;
-	sisusb->ioportbase = SISUSB_PCI_IOPORTBASE;
-	/* Everything else is zero */
+	sisusb->minor = intf->minor;
 
 	/* Allocate buffers */
 	sisusb->ibufsize = SISUSB_IBUF_SIZE;


