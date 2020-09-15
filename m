Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415C826A6FC
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 16:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgIOOXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 10:23:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726890AbgIOOWr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:22:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFBBE22287;
        Tue, 15 Sep 2020 14:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179471;
        bh=hoZ3Q5l+Gz5pM+ZFxxloinnRU3ZezZjJw16Hv2vkoGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CKGJ/gDb6sD42Nd8F0SGVX37WvSdNA3E9XtgZ18ounYRUmeGQ49QnsL/xugJKPDcn
         ZSj737VsBN8zqzyUsXDQ3if4T1V9i20RJUsA9B5w/WilPXg3Q3rTcyYPpniHUkIHKh
         ODNseyoMpwlYIMSzkcN3QH1bkLRGn56bV6rgWp4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        syzbot+256e56ddde8b8957eabd@syzkaller.appspotmail.com,
        Zeng Tao <prime.zeng@hisilicon.com>
Subject: [PATCH 4.19 73/78] usb: core: fix slab-out-of-bounds Read in read_descriptors
Date:   Tue, 15 Sep 2020 16:13:38 +0200
Message-Id: <20200915140637.267837103@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140633.552502750@linuxfoundation.org>
References: <20200915140633.552502750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zeng Tao <prime.zeng@hisilicon.com>

commit a18cd6c9b6bc73dc17e8b7e9bd07decaa8833c97 upstream.

The USB device descriptor may get changed between two consecutive
enumerations on the same device for some reason, such as DFU or
malicius device.
In that case, we may access the changing descriptor if we don't take
the device lock here.

The issue is reported:
https://syzkaller.appspot.com/bug?id=901a0d9e6519ef8dc7acab25344bd287dd3c7be9

Cc: stable <stable@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Reported-by: syzbot+256e56ddde8b8957eabd@syzkaller.appspotmail.com
Fixes: 217a9081d8e6 ("USB: add all configs to the "descriptors" attribute")
Signed-off-by: Zeng Tao <prime.zeng@hisilicon.com>
Link: https://lore.kernel.org/r/1599201467-11000-1-git-send-email-prime.zeng@hisilicon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/sysfs.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -888,7 +888,11 @@ read_descriptors(struct file *filp, stru
 	size_t srclen, n;
 	int cfgno;
 	void *src;
+	int retval;
 
+	retval = usb_lock_device_interruptible(udev);
+	if (retval < 0)
+		return -EINTR;
 	/* The binary attribute begins with the device descriptor.
 	 * Following that are the raw descriptor entries for all the
 	 * configurations (config plus subsidiary descriptors).
@@ -913,6 +917,7 @@ read_descriptors(struct file *filp, stru
 			off -= srclen;
 		}
 	}
+	usb_unlock_device(udev);
 	return count - nleft;
 }
 


