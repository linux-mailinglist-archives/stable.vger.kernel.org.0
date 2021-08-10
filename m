Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48423E8154
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234935AbhHJR6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233315AbhHJR4l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:56:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE9E461372;
        Tue, 10 Aug 2021 17:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617508;
        bh=Zp4VGG1dKfim0sPPTUerjeS0+20VMSVIPMlp0SbM0sI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YPmCbeaoEmDFCrKjAZWMO2QaTjnN8K1ILdHMDHSxxtw+xUa1vOgyKPcD2VcrNjw0e
         BPUyYmSf2xNbFmwJvrPtkRKKALr5kS8ptVU1eF+n4FZKxfuEPF4hQ9vIP5+05m0YOd
         gEC632yBdUeEt/IpdeLRtccdG7e1PD7t4wOJSbpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 5.13 089/175] usb: dwc3: gadget: Use list_replace_init() before traversing lists
Date:   Tue, 10 Aug 2021 19:29:57 +0200
Message-Id: <20210810173003.873190933@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Cheng <wcheng@codeaurora.org>

commit d25d85061bd856d6be221626605319154f9b5043 upstream.

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
 drivers/usb/dwc3/gadget.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1741,9 +1741,13 @@ static void dwc3_gadget_ep_cleanup_cance
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
@@ -1761,6 +1765,9 @@ static void dwc3_gadget_ep_cleanup_cance
 			break;
 		}
 	}
+
+	if (!list_empty(&dep->cancelled_list))
+		goto restart;
 }
 
 static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
@@ -2945,8 +2952,12 @@ static void dwc3_gadget_ep_cleanup_compl
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
@@ -2954,6 +2965,9 @@ static void dwc3_gadget_ep_cleanup_compl
 		if (ret)
 			break;
 	}
+
+	if (!list_empty(&dep->started_list))
+		goto restart;
 }
 
 static bool dwc3_gadget_ep_should_continue(struct dwc3_ep *dep)


