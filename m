Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61215259317
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729651AbgIAPU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:20:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729643AbgIAPU6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:20:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EF75206EB;
        Tue,  1 Sep 2020 15:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973656;
        bh=jUeaoj6CmMMfIJIdDUq79xCU5LfhWVPRv06PMoRIdm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yv26eUoF4kjZ7vKFq8d6bNFbgipnwwxFlMGDywfPg+EH1zgF8nFH0pFd58fgmWxSi
         2LyTEQ4IrfB4Xlhx4sFwIXRXEIlYeJ2v5y+OI9pMEDcBBt76FsFLXfHOxBIiRzPUlv
         X9EX9RJOJWUUnPJEVIyjJW27J8zL92buB3whvou4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.14 86/91] USB: cdc-acm: rework notification_buffer resizing
Date:   Tue,  1 Sep 2020 17:11:00 +0200
Message-Id: <20200901150932.437063724@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150928.096174795@linuxfoundation.org>
References: <20200901150928.096174795@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

commit f4b9d8a582f738c24ebeabce5cc15f4b8159d74e upstream.

Clang static analysis reports this error

cdc-acm.c:409:3: warning: Use of memory after it is freed
        acm_process_notification(acm, (unsigned char *)dr);

There are three problems, the first one is that dr is not reset

The variable dr is set with

if (acm->nb_index)
	dr = (struct usb_cdc_notification *)acm->notification_buffer;

But if the notification_buffer is too small it is resized with

		if (acm->nb_size) {
			kfree(acm->notification_buffer);
			acm->nb_size = 0;
		}
		alloc_size = roundup_pow_of_two(expected_size);
		/*
		 * kmalloc ensures a valid notification_buffer after a
		 * use of kfree in case the previous allocation was too
		 * small. Final freeing is done on disconnect.
		 */
		acm->notification_buffer =
			kmalloc(alloc_size, GFP_ATOMIC);

dr should point to the new acm->notification_buffer.

The second problem is any data in the notification_buffer is lost
when the pointer is freed.  In the normal case, the current data
is accumulated in the notification_buffer here.

	memcpy(&acm->notification_buffer[acm->nb_index],
	       urb->transfer_buffer, copy_size);

When a resize happens, anything before
notification_buffer[acm->nb_index] is garbage.

The third problem is the acm->nb_index is not reset on a
resizing buffer error.

So switch resizing to using krealloc and reassign dr and
reset nb_index.

Fixes: ea2583529cd1 ("cdc-acm: reassemble fragmented notifications")
Signed-off-by: Tom Rix <trix@redhat.com>
Cc: stable <stable@vger.kernel.org>
Acked-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20200801152154.20683-1-trix@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -390,21 +390,19 @@ static void acm_ctrl_irq(struct urb *urb
 	if (current_size < expected_size) {
 		/* notification is transmitted fragmented, reassemble */
 		if (acm->nb_size < expected_size) {
-			if (acm->nb_size) {
-				kfree(acm->notification_buffer);
-				acm->nb_size = 0;
-			}
+			u8 *new_buffer;
 			alloc_size = roundup_pow_of_two(expected_size);
-			/*
-			 * kmalloc ensures a valid notification_buffer after a
-			 * use of kfree in case the previous allocation was too
-			 * small. Final freeing is done on disconnect.
-			 */
-			acm->notification_buffer =
-				kmalloc(alloc_size, GFP_ATOMIC);
-			if (!acm->notification_buffer)
+			/* Final freeing is done on disconnect. */
+			new_buffer = krealloc(acm->notification_buffer,
+					      alloc_size, GFP_ATOMIC);
+			if (!new_buffer) {
+				acm->nb_index = 0;
 				goto exit;
+			}
+
+			acm->notification_buffer = new_buffer;
 			acm->nb_size = alloc_size;
+			dr = (struct usb_cdc_notification *)acm->notification_buffer;
 		}
 
 		copy_size = min(current_size,


