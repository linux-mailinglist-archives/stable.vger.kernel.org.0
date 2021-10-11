Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85AAD429008
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237531AbhJKOEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:04:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238666AbhJKOBl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:01:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB7E8610E8;
        Mon, 11 Oct 2021 13:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960660;
        bh=2KTZU7TzMuJ0WGwHs7UbiBL/9066kgzZMrisOoGWRE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eQjfhheDu8hP5C1ksZFA2Mi4T6/NqBwHfZ4a5uhmPPd3zkgtpFun1Z/B1idHg6U75
         d9pkf4X15tBmPD9YONUcnjIdxCggPRIK3oDRaz5RT/CGKcWSLzND3Glu60uJDAqhEs
         KtXOP0wHkrnJQywdtlM0jfUJ5g+inuF6BrKyLVjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.14 005/151] USB: cdc-acm: fix racy tty buffer accesses
Date:   Mon, 11 Oct 2021 15:44:37 +0200
Message-Id: <20211011134518.005526126@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 65a205e6113506e69a503b61d97efec43fc10fd7 upstream.

A recent change that started reporting break events to the line
discipline caused the tty-buffer insertions to no longer be serialised
by inserting events also from the completion handler for the interrupt
endpoint.

Completion calls for distinct endpoints are not guaranteed to be
serialised. For example, in case a host-controller driver uses
bottom-half completion, the interrupt and bulk-in completion handlers
can end up running in parallel on two CPUs (high-and low-prio tasklets,
respectively) thereby breaking the tty layer's single producer
assumption.

Fix this by holding the read lock also when inserting characters from
the bulk endpoint.

Fixes: 08dff274edda ("cdc-acm: fix BREAK rx code path adding necessary calls")
Cc: stable@vger.kernel.org
Acked-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210929090937.7410-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -475,11 +475,16 @@ static int acm_submit_read_urbs(struct a
 
 static void acm_process_read_urb(struct acm *acm, struct urb *urb)
 {
+	unsigned long flags;
+
 	if (!urb->actual_length)
 		return;
 
+	spin_lock_irqsave(&acm->read_lock, flags);
 	tty_insert_flip_string(&acm->port, urb->transfer_buffer,
 			urb->actual_length);
+	spin_unlock_irqrestore(&acm->read_lock, flags);
+
 	tty_flip_buffer_push(&acm->port);
 }
 


