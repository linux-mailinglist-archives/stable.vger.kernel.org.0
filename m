Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB64291DB1
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731150AbgJRTrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:47:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729813AbgJRTWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:22:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0EFA207DE;
        Sun, 18 Oct 2020 19:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048943;
        bh=wgqkcKgNfn4mCoNz0n7493iaFkxtzSi97pPwnY+ZTiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ROZOcjIJvqn9WUC2WE3L7CxY59cfSNrsmzwnYr/w3rJb3h1kqvy0fJuXLh6YOVuKz
         UVnJ1WCIHfYjLmBcBKlrP3OazfmroW9oeLxCX/OIhhi5X8lsmDs7wqZD67pDVbjUBN
         hAsEPE6sQLYFtw9C/wSlI6wcLKrriAu5StOeiK2U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eli Billauer <eli.billauer@gmail.com>,
        Oliver Neukum <oneukum@suse.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 096/101] usb: core: Solve race condition in anchor cleanup functions
Date:   Sun, 18 Oct 2020 15:20:21 -0400
Message-Id: <20201018192026.4053674-96-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Billauer <eli.billauer@gmail.com>

[ Upstream commit fbc299437c06648afcc7891e6e2e6638dd48d4df ]

usb_kill_anchored_urbs() is commonly used to cancel all URBs on an
anchor just before releasing resources which the URBs rely on. By doing
so, users of this function rely on that no completer callbacks will take
place from any URB on the anchor after it returns.

However if this function is called in parallel with __usb_hcd_giveback_urb
processing a URB on the anchor, the latter may call the completer
callback after usb_kill_anchored_urbs() returns. This can lead to a
kernel panic due to use after release of memory in interrupt context.

The race condition is that __usb_hcd_giveback_urb() first unanchors the URB
and then makes the completer callback. Such URB is hence invisible to
usb_kill_anchored_urbs(), allowing it to return before the completer has
been called, since the anchor's urb_list is empty.

Even worse, if the racing completer callback resubmits the URB, it may
remain in the system long after usb_kill_anchored_urbs() returns.

Hence list_empty(&anchor->urb_list), which is used in the existing
while-loop, doesn't reliably ensure that all URBs of the anchor are gone.

A similar problem exists with usb_poison_anchored_urbs() and
usb_scuttle_anchored_urbs().

This patch adds an external do-while loop, which ensures that all URBs
are indeed handled before these three functions return. This change has
no effect at all unless the race condition occurs, in which case the
loop will busy-wait until the racing completer callback has finished.
This is a rare condition, so the CPU waste of this spinning is
negligible.

The additional do-while loop relies on usb_anchor_check_wakeup(), which
returns true iff the anchor list is empty, and there is no
__usb_hcd_giveback_urb() in the system that is in the middle of the
unanchor-before-complete phase. The @suspend_wakeups member of
struct usb_anchor is used for this purpose, which was introduced to solve
another problem which the same race condition causes, in commit
6ec4147e7bdb ("usb-anchor: Delay usb_wait_anchor_empty_timeout wake up
till completion is done").

The surely_empty variable is necessary, because usb_anchor_check_wakeup()
must be called with the lock held to prevent races. However the spinlock
must be released and reacquired if the outer loop spins with an empty
URB list while waiting for the unanchor-before-complete passage to finish:
The completer callback may very well attempt to take the very same lock.

To summarize, using usb_anchor_check_wakeup() means that the patched
functions can return only when the anchor's list is empty, and there is
no invisible URB being processed. Since the inner while loop finishes on
the empty list condition, the new do-while loop will terminate as well,
except for when the said race condition occurs.

Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20200731054650.30644-1-eli.billauer@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/urb.c | 89 +++++++++++++++++++++++++-----------------
 1 file changed, 54 insertions(+), 35 deletions(-)

diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
index da923ec176122..31ca5abb4c12a 100644
--- a/drivers/usb/core/urb.c
+++ b/drivers/usb/core/urb.c
@@ -772,11 +772,12 @@ void usb_block_urb(struct urb *urb)
 EXPORT_SYMBOL_GPL(usb_block_urb);
 
 /**
- * usb_kill_anchored_urbs - cancel transfer requests en masse
+ * usb_kill_anchored_urbs - kill all URBs associated with an anchor
  * @anchor: anchor the requests are bound to
  *
- * this allows all outstanding URBs to be killed starting
- * from the back of the queue
+ * This kills all outstanding URBs starting from the back of the queue,
+ * with guarantee that no completer callbacks will take place from the
+ * anchor after this function returns.
  *
  * This routine should not be called by a driver after its disconnect
  * method has returned.
@@ -784,20 +785,26 @@ EXPORT_SYMBOL_GPL(usb_block_urb);
 void usb_kill_anchored_urbs(struct usb_anchor *anchor)
 {
 	struct urb *victim;
+	int surely_empty;
 
-	spin_lock_irq(&anchor->lock);
-	while (!list_empty(&anchor->urb_list)) {
-		victim = list_entry(anchor->urb_list.prev, struct urb,
-				    anchor_list);
-		/* we must make sure the URB isn't freed before we kill it*/
-		usb_get_urb(victim);
-		spin_unlock_irq(&anchor->lock);
-		/* this will unanchor the URB */
-		usb_kill_urb(victim);
-		usb_put_urb(victim);
+	do {
 		spin_lock_irq(&anchor->lock);
-	}
-	spin_unlock_irq(&anchor->lock);
+		while (!list_empty(&anchor->urb_list)) {
+			victim = list_entry(anchor->urb_list.prev,
+					    struct urb, anchor_list);
+			/* make sure the URB isn't freed before we kill it */
+			usb_get_urb(victim);
+			spin_unlock_irq(&anchor->lock);
+			/* this will unanchor the URB */
+			usb_kill_urb(victim);
+			usb_put_urb(victim);
+			spin_lock_irq(&anchor->lock);
+		}
+		surely_empty = usb_anchor_check_wakeup(anchor);
+
+		spin_unlock_irq(&anchor->lock);
+		cpu_relax();
+	} while (!surely_empty);
 }
 EXPORT_SYMBOL_GPL(usb_kill_anchored_urbs);
 
@@ -816,21 +823,27 @@ EXPORT_SYMBOL_GPL(usb_kill_anchored_urbs);
 void usb_poison_anchored_urbs(struct usb_anchor *anchor)
 {
 	struct urb *victim;
+	int surely_empty;
 
-	spin_lock_irq(&anchor->lock);
-	anchor->poisoned = 1;
-	while (!list_empty(&anchor->urb_list)) {
-		victim = list_entry(anchor->urb_list.prev, struct urb,
-				    anchor_list);
-		/* we must make sure the URB isn't freed before we kill it*/
-		usb_get_urb(victim);
-		spin_unlock_irq(&anchor->lock);
-		/* this will unanchor the URB */
-		usb_poison_urb(victim);
-		usb_put_urb(victim);
+	do {
 		spin_lock_irq(&anchor->lock);
-	}
-	spin_unlock_irq(&anchor->lock);
+		anchor->poisoned = 1;
+		while (!list_empty(&anchor->urb_list)) {
+			victim = list_entry(anchor->urb_list.prev,
+					    struct urb, anchor_list);
+			/* make sure the URB isn't freed before we kill it */
+			usb_get_urb(victim);
+			spin_unlock_irq(&anchor->lock);
+			/* this will unanchor the URB */
+			usb_poison_urb(victim);
+			usb_put_urb(victim);
+			spin_lock_irq(&anchor->lock);
+		}
+		surely_empty = usb_anchor_check_wakeup(anchor);
+
+		spin_unlock_irq(&anchor->lock);
+		cpu_relax();
+	} while (!surely_empty);
 }
 EXPORT_SYMBOL_GPL(usb_poison_anchored_urbs);
 
@@ -970,14 +983,20 @@ void usb_scuttle_anchored_urbs(struct usb_anchor *anchor)
 {
 	struct urb *victim;
 	unsigned long flags;
+	int surely_empty;
+
+	do {
+		spin_lock_irqsave(&anchor->lock, flags);
+		while (!list_empty(&anchor->urb_list)) {
+			victim = list_entry(anchor->urb_list.prev,
+					    struct urb, anchor_list);
+			__usb_unanchor_urb(victim, anchor);
+		}
+		surely_empty = usb_anchor_check_wakeup(anchor);
 
-	spin_lock_irqsave(&anchor->lock, flags);
-	while (!list_empty(&anchor->urb_list)) {
-		victim = list_entry(anchor->urb_list.prev, struct urb,
-				    anchor_list);
-		__usb_unanchor_urb(victim, anchor);
-	}
-	spin_unlock_irqrestore(&anchor->lock, flags);
+		spin_unlock_irqrestore(&anchor->lock, flags);
+		cpu_relax();
+	} while (!surely_empty);
 }
 
 EXPORT_SYMBOL_GPL(usb_scuttle_anchored_urbs);
-- 
2.25.1

