Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458FC41C158
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 11:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244998AbhI2JLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 05:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244987AbhI2JLp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Sep 2021 05:11:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6F5A6140A;
        Wed, 29 Sep 2021 09:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632906604;
        bh=HDZp98w3++Y5UWKDXkO1SJkLWJPyJ4G4ENH8NxQrItI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e/QOKfBPDMm1GTIUZOq6lIEhDEYxsIxTv41vm6VTc0aWrrW8UVrpY8L+jH3PztLqP
         6AUIxsTQRTP5l0MkGuSUvrNgUd++2C6SjcjO0xcHZ0PsQCABqOyEKecLwGsu775B1j
         mI9EZr5jJPIR9+LkYAp7G8D5wdJfW2XVDec/vqgWhxBNFdsXqn0jpw/FWV74dak34E
         nwrPynNZxM1+oIF27cYQD8rTzt+DDPKpt1LnX09HiaFFzlpAbVNL+7U2E2VLiiqGlt
         o3/6WnxTxENhV33u2cGiA9uUKXfyfBy/C9ZbSaODX0+3QNwcRABrfiHjgMCF59crVL
         XPGfv7vPFrZIw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mVVbJ-0001wT-OP; Wed, 29 Sep 2021 11:10:05 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 1/2] USB: cdc-acm: fix racy tty buffer accesses
Date:   Wed, 29 Sep 2021 11:09:36 +0200
Message-Id: <20210929090937.7410-2-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210929090937.7410-1-johan@kernel.org>
References: <20210929090937.7410-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/class/cdc-acm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 4e2f1552f4b7..c7a1736720e7 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -475,11 +475,16 @@ static int acm_submit_read_urbs(struct acm *acm, gfp_t mem_flags)
 
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
 
-- 
2.32.0

