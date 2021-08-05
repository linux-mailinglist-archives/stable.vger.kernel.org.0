Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DD13E10BA
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 11:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbhHEJCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 05:02:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:60166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238785AbhHEJCj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Aug 2021 05:02:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C4C36104F;
        Thu,  5 Aug 2021 09:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628154146;
        bh=qBvrvK35zG/Twz/GCjhJsBGy3uVroSRQpOSjb3JMmb8=;
        h=Subject:To:From:Date:From;
        b=yLHYO0g55ruEZhCybhhurifCUlY+5HTjKmqoEDD0yW9gAqWzR/8cB7QX7POWH1mww
         VNytO58h4gTmYqTPO7HPODU7d/QnAfn9XA9BYBdIC6hj9dlBG/mIINIcZ/4G5bot+1
         HK6YzVPud7ikS4J3qBAN9VBf7SylBWptxLdrdyrw=
Subject: patch "usb: dwc3: gadget: Use list_replace_init() before traversing lists" added to usb-linus
To:     wcheng@codeaurora.org, balbi@kernel.org,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 05 Aug 2021 11:02:23 +0200
Message-ID: <162815414349184@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: gadget: Use list_replace_init() before traversing lists

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d25d85061bd856d6be221626605319154f9b5043 Mon Sep 17 00:00:00 2001
From: Wesley Cheng <wcheng@codeaurora.org>
Date: Thu, 29 Jul 2021 00:33:14 -0700
Subject: usb: dwc3: gadget: Use list_replace_init() before traversing lists

The list_for_each_entry_safe() macro saves the current item (n) and
the item after (n+1), so that n can be safely removed without
corrupting the list.  However, when traversing the list and removing
items using gadget giveback, the DWC3 lock is briefly released,
allowing other routines to execute.  There is a situation where, while
items are being removed from the cancelled_list using
dwc3_gadget_ep_cleanup_cancelled_requests(), the pullup disable
routine is running in parallel (due to UDC unbind).  As the cleanup
routine removes n, and the pullup disable removes n+1, once the
cleanup retakes the DWC3 lock, it references a request who was already
removed/handled.  With list debug enabled, this leads to a panic.
Ensure all instances of the macro are replaced where gadget giveback
is used.

Example call stack:

Thread#1:
__dwc3_gadget_ep_set_halt() - CLEAR HALT
  -> dwc3_gadget_ep_cleanup_cancelled_requests()
    ->list_for_each_entry_safe()
    ->dwc3_gadget_giveback(n)
      ->dwc3_gadget_del_and_unmap_request()- n deleted[cancelled_list]
      ->spin_unlock
      ->Thread#2 executes
      ...
    ->dwc3_gadget_giveback(n+1)
      ->Already removed!

Thread#2:
dwc3_gadget_pullup()
  ->waiting for dwc3 spin_lock
  ...
  ->Thread#1 released lock
  ->dwc3_stop_active_transfers()
    ->dwc3_remove_requests()
      ->fetches n+1 item from cancelled_list (n removed by Thread#1)
      ->dwc3_gadget_giveback()
        ->dwc3_gadget_del_and_unmap_request()- n+1
deleted[cancelled_list]
        ->spin_unlock

Fix this condition by utilizing list_replace_init(), and traversing
through a local copy of the current elements in the endpoint lists.
This will also set the parent list as empty, so if another thread is
also looping through the list, it will be empty on the next iteration.

Fixes: d4f1afe5e896 ("usb: dwc3: gadget: move requests to cancelled_list")
Cc: stable <stable@vger.kernel.org>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Link: https://lore.kernel.org/r/1627543994-20327-1-git-send-email-wcheng@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 45f2bc0807e8..a1b262669574 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1741,9 +1741,13 @@ static void dwc3_gadget_ep_cleanup_cancelled_requests(struct dwc3_ep *dep)
 {
 	struct dwc3_request		*req;
 	struct dwc3_request		*tmp;
+	struct list_head		local;
 	struct dwc3			*dwc = dep->dwc;
 
-	list_for_each_entry_safe(req, tmp, &dep->cancelled_list, list) {
+restart:
+	list_replace_init(&dep->cancelled_list, &local);
+
+	list_for_each_entry_safe(req, tmp, &local, list) {
 		dwc3_gadget_ep_skip_trbs(dep, req);
 		switch (req->status) {
 		case DWC3_REQUEST_STATUS_DISCONNECTED:
@@ -1761,6 +1765,9 @@ static void dwc3_gadget_ep_cleanup_cancelled_requests(struct dwc3_ep *dep)
 			break;
 		}
 	}
+
+	if (!list_empty(&dep->cancelled_list))
+		goto restart;
 }
 
 static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
@@ -2958,8 +2965,12 @@ static void dwc3_gadget_ep_cleanup_completed_requests(struct dwc3_ep *dep,
 {
 	struct dwc3_request	*req;
 	struct dwc3_request	*tmp;
+	struct list_head	local;
 
-	list_for_each_entry_safe(req, tmp, &dep->started_list, list) {
+restart:
+	list_replace_init(&dep->started_list, &local);
+
+	list_for_each_entry_safe(req, tmp, &local, list) {
 		int ret;
 
 		ret = dwc3_gadget_ep_cleanup_completed_request(dep, event,
@@ -2967,6 +2978,9 @@ static void dwc3_gadget_ep_cleanup_completed_requests(struct dwc3_ep *dep,
 		if (ret)
 			break;
 	}
+
+	if (!list_empty(&dep->started_list))
+		goto restart;
 }
 
 static bool dwc3_gadget_ep_should_continue(struct dwc3_ep *dep)
-- 
2.32.0


