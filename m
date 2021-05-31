Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF1A395C57
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbhEaNbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:31:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232495AbhEaN3Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:29:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE2F561428;
        Mon, 31 May 2021 13:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467364;
        bh=RuZndJVQ92C/+DrkI/Yutl4IKpxCviT106YkaDWphJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CXnSdgv1CD4o1CoLtbL2ehqN37AKBoyOSM5RmzkE96pWRQiBy/0ETDMrBvLp42S1u
         ie8gsgNdWtAVWqLe50sXzFM2xn4Y/I3s8bJRCj7EUOmkjIcO/x83xsqvvTpN6kfZ9I
         hOUyihRUsHeN/yPXm1KyQgY4QLY51Qi0QwcUtBY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        syzbot+882a85c0c8ec4a3e2281@syzkaller.appspotmail.com
Subject: [PATCH 4.19 030/116] USB: usbfs: Dont WARN about excessively large memory allocations
Date:   Mon, 31 May 2021 15:13:26 +0200
Message-Id: <20210531130641.186520192@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
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
@@ -1189,7 +1189,12 @@ static int proc_bulk(struct usb_dev_stat
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
@@ -1631,7 +1636,7 @@ static int proc_do_submiturb(struct usb_
 	if (num_sgs) {
 		as->urb->sg = kmalloc_array(num_sgs,
 					    sizeof(struct scatterlist),
-					    GFP_KERNEL);
+					    GFP_KERNEL | __GFP_NOWARN);
 		if (!as->urb->sg) {
 			ret = -ENOMEM;
 			goto error;
@@ -1666,7 +1671,7 @@ static int proc_do_submiturb(struct usb_
 					(uurb_start - as->usbm->vm_start);
 		} else {
 			as->urb->transfer_buffer = kmalloc(uurb->buffer_length,
-					GFP_KERNEL);
+					GFP_KERNEL | __GFP_NOWARN);
 			if (!as->urb->transfer_buffer) {
 				ret = -ENOMEM;
 				goto error;


