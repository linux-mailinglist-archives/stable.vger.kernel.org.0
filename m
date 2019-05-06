Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64C1614E9F
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbfEFOjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:39:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727803AbfEFOjW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:39:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA7CF20449;
        Mon,  6 May 2019 14:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153561;
        bh=9UwnwSLSRzGF+aoCsEt4MidaK9aiEQCsI0f/H/t9rQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wdisqjCb99IDZCcWt1IHY549LpEqZU78HySsfUnoDNdycvNM+nLs4SVTxCShJGixc
         qj28qOHrwjvboBDDqQsEc/+xZls+OIIw5mVKQ6c0U8avKqmNdw0J///69+/2q2RYtW
         eNiRIK+I+Ep3UpzJNzo/mIgqfpWfOECcV1GET3HI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        syzbot+2eb9121678bdb36e6d57@syzkaller.appspotmail.com
Subject: [PATCH 4.19 13/99] USB: yurex: Fix protection fault after device removal
Date:   Mon,  6 May 2019 16:31:46 +0200
Message-Id: <20190506143055.068620858@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit ef61eb43ada6c1d6b94668f0f514e4c268093ff3 upstream.

The syzkaller USB fuzzer found a general-protection-fault bug in the
yurex driver.  The fault occurs when a device has been unplugged; the
driver's interrupt-URB handler logs an error message referring to the
device by name, after the device has been unregistered and its name
deallocated.

This problem is caused by the fact that the interrupt URB isn't
cancelled until the driver's private data structure is released, which
can happen long after the device is gone.  The cure is to make sure
that the interrupt URB is killed before yurex_disconnect() returns;
this is exactly the sort of thing that usb_poison_urb() was meant for.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: syzbot+2eb9121678bdb36e6d57@syzkaller.appspotmail.com
CC: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/yurex.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -314,6 +314,7 @@ static void yurex_disconnect(struct usb_
 	usb_deregister_dev(interface, &yurex_class);
 
 	/* prevent more I/O from starting */
+	usb_poison_urb(dev->urb);
 	mutex_lock(&dev->io_mutex);
 	dev->interface = NULL;
 	mutex_unlock(&dev->io_mutex);


