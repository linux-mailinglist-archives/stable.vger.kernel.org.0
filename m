Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799D739618B
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbhEaOl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:41:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234156AbhEaOjf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:39:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1624B61C60;
        Mon, 31 May 2021 13:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469161;
        bh=jkmb25lIZCsxNDvHR/Aa6xXTz6m8W8yJHam7hbHsmkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eA0sO/RhOTk8zBmuuD/6ffdoHMpcrB86D7j8ymagY5FaQ/QgKgot3nF6a4txGko2l
         yYEF4aKgQqDgnjF8phvvRU0tA3/Gr/1edoFdEAJBkMj0aiJnsvk6p0obLIv5I8Me1U
         Bqnbg0hLvcLZegBc7RaavemRycyqm1U6Adh6wrlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        syzbot+882a85c0c8ec4a3e2281@syzkaller.appspotmail.com
Subject: [PATCH 5.12 091/296] USB: usbfs: Dont WARN about excessively large memory allocations
Date:   Mon, 31 May 2021 15:12:26 +0200
Message-Id: <20210531130706.955569422@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 4f2629ea67e7225c3fd292c7fe4f5b3c9d6392de upstream.

Syzbot found that the kernel generates a WARNing if the user tries to
submit a bulk transfer through usbfs with a buffer that is way too
large.  This isn't a bug in the kernel; it's merely an invalid request
from the user and the usbfs code does handle it correctly.

In theory the same thing can happen with async transfers, or with the
packet descriptor table for isochronous transfers.

To prevent the MM subsystem from complaining about these bad
allocation requests, add the __GFP_NOWARN flag to the kmalloc calls
for these buffers.

CC: Andrew Morton <akpm@linux-foundation.org>
CC: <stable@vger.kernel.org>
Reported-and-tested-by: syzbot+882a85c0c8ec4a3e2281@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20210518201835.GA1140918@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/devio.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1218,7 +1218,12 @@ static int do_proc_bulk(struct usb_dev_s
 	ret = usbfs_increase_memory_usage(len1 + sizeof(struct urb));
 	if (ret)
 		return ret;
-	tbuf = kmalloc(len1, GFP_KERNEL);
+
+	/*
+	 * len1 can be almost arbitrarily large.  Don't WARN if it's
+	 * too big, just fail the request.
+	 */
+	tbuf = kmalloc(len1, GFP_KERNEL | __GFP_NOWARN);
 	if (!tbuf) {
 		ret = -ENOMEM;
 		goto done;
@@ -1696,7 +1701,7 @@ static int proc_do_submiturb(struct usb_
 	if (num_sgs) {
 		as->urb->sg = kmalloc_array(num_sgs,
 					    sizeof(struct scatterlist),
-					    GFP_KERNEL);
+					    GFP_KERNEL | __GFP_NOWARN);
 		if (!as->urb->sg) {
 			ret = -ENOMEM;
 			goto error;
@@ -1731,7 +1736,7 @@ static int proc_do_submiturb(struct usb_
 					(uurb_start - as->usbm->vm_start);
 		} else {
 			as->urb->transfer_buffer = kmalloc(uurb->buffer_length,
-					GFP_KERNEL);
+					GFP_KERNEL | __GFP_NOWARN);
 			if (!as->urb->transfer_buffer) {
 				ret = -ENOMEM;
 				goto error;


