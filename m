Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 745C217FE51
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgCJMqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:46:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727821AbgCJMqY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:46:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 598A02467D;
        Tue, 10 Mar 2020 12:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844383;
        bh=k+hGJZYSyfR7ivL/m9ThcSWN/LBHQZfZdVkxeHyYmkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JBpNMpWHYySXFMFjv3vCJzRlBS8+nxFiwzlLsj3DpZnpZSeXJlgkWyp+oiP9a2Lzk
         /sEwvJGKGU3CZ8xn7H3Ms252MuvmmJGRHG9bAynQQ5xUKo+8M2WDl55A7tf35CNZJb
         Cah04Tm0rncmQkki7i1OYiZnjjmUziFFb3XADWto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+784ccb935f9900cc7c9e@syzkaller.appspotmail.com,
        Alan Stern <stern@rowland.harvard.edu>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.9 34/88] HID: hiddev: Fix race in in hiddev_disconnect()
Date:   Tue, 10 Mar 2020 13:38:42 +0100
Message-Id: <20200310123614.195198369@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123606.543939933@linuxfoundation.org>
References: <20200310123606.543939933@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: dan.carpenter@oracle.com <dan.carpenter@oracle.com>

commit 5c02c447eaeda29d3da121a2e17b97ccaf579b51 upstream.

Syzbot reports that "hiddev" is used after it's free in hiddev_disconnect().
The hiddev_disconnect() function sets "hiddev->exist = 0;" so
hiddev_release() can free it as soon as we drop the "existancelock"
lock.  This patch moves the mutex_unlock(&hiddev->existancelock) until
after we have finished using it.

Reported-by: syzbot+784ccb935f9900cc7c9e@syzkaller.appspotmail.com
Fixes: 7f77897ef2b6 ("HID: hiddev: fix potential use-after-free")
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/usbhid/hiddev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -962,9 +962,9 @@ void hiddev_disconnect(struct hid_device
 	hiddev->exist = 0;
 
 	if (hiddev->open) {
-		mutex_unlock(&hiddev->existancelock);
 		usbhid_close(hiddev->hid);
 		wake_up_interruptible(&hiddev->wait);
+		mutex_unlock(&hiddev->existancelock);
 	} else {
 		mutex_unlock(&hiddev->existancelock);
 		kfree(hiddev);


