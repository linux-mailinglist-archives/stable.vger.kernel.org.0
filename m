Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B38428EA4
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237243AbhJKNvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:51:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237246AbhJKNuO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:50:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70AF960F21;
        Mon, 11 Oct 2021 13:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960094;
        bh=90j3KqDcIJeIiJ/g/3FQopNbkD1LE4QJBm6HsNbOlU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FBMgW5JFwMmYYXXYlvNYtMcy5sSpFNXRf/s6ya90zzhGQ4tgPG9f1pc7kyuvPat3C
         uSQ1IyUm3WQgqiXVOgBc9HgTQAcqi4LxFwmkVvaPNsYLEGU+wPgXn6KPqyGqNpyoys
         9u9M+vgVko4krGe2zQAxy/f1bh4rRVcrz07fjLqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 02/52] USB: cdc-acm: fix racy tty buffer accesses
Date:   Mon, 11 Oct 2021 15:45:31 +0200
Message-Id: <20211011134503.803461169@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134503.715740503@linuxfoundation.org>
References: <20211011134503.715740503@linuxfoundation.org>
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
@@ -474,11 +474,16 @@ static int acm_submit_read_urbs(struct a
 
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
 


