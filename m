Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7B426B3D8
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgIOXK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:10:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727282AbgIOOlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:41:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC90422A85;
        Tue, 15 Sep 2020 14:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180247;
        bh=iiYcjFB9bkcrHQAjuCng4dMMZ3HBKyFm2yW8A9rnkRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YB9R9KaI5QxagEMbw1DGRgPzLO532XZNrvH8zTht6I1X4g4RlGyxhtr857oK3m9Bj
         kYVu29ZJLsr+Ke7vkjneXt4xThVUW0E6zQOpDGeF8aJ79f7yEguqua/X++ZM/lHcjd
         GKIsK84yzaqcnOUEjvc67AGOPKEO5VOrGMMe+KLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        syzbot+256e56ddde8b8957eabd@syzkaller.appspotmail.com,
        Zeng Tao <prime.zeng@hisilicon.com>
Subject: [PATCH 5.8 167/177] usb: core: fix slab-out-of-bounds Read in read_descriptors
Date:   Tue, 15 Sep 2020 16:13:58 +0200
Message-Id: <20200915140701.702637246@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
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
@@ -889,7 +889,11 @@ read_descriptors(struct file *filp, stru
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
@@ -914,6 +918,7 @@ read_descriptors(struct file *filp, stru
 			off -= srclen;
 		}
 	}
+	usb_unlock_device(udev);
 	return count - nleft;
 }
 


