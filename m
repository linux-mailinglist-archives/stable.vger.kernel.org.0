Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37004396184
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbhEaOlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:41:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234179AbhEaOjg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:39:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC49061C62;
        Mon, 31 May 2021 13:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469166;
        bh=a6U4P9qpJ+bpOtv1WRP3SiEYiF7qP2V/P3fQITGQGZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Intgpqb2olZsXW4hqI2sRB0RGt6v+IFmYX9g8MM//MAh3vXikYBt5C3MHd3Z1ipiH
         D5vcEd+LBDXVU/I7rCaXHH7AkpF9nYuOKKhWNAXIFUbLnXJSQv35nF2eNHO/a4CdvI
         zA4JCinENGw8OdgW3sEr3B3PHhO4ctpwAwfD9Vyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Peter Ganzhorn <peter.ganzhorn@googlemail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.12 093/296] xhci: Fix 5.12 regression of missing xHC cache clearing command after a Stall
Date:   Mon, 31 May 2021 15:12:28 +0200
Message-Id: <20210531130707.032553686@linuxfoundation.org>
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

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit a7f2e9272aff1ccfe0fc801dab1d5a7a1c6b7ed2 upstream.

If endpoints halts due to a stall then the dequeue pointer read from
hardware may already be set ahead of the stalled TRB.
After commit 674f8438c121 ("xhci: split handling halted endpoints into two
steps") in 5.12 xhci driver won't issue a Set TR Dequeue if hardware
dequeue pointer is already in the right place.

Turns out the "Set TR Dequeue pointer" command is anyway needed as it in
addition to moving the dequeue pointer also clears endpoint state and
cache.

Fixes: 674f8438c121 ("xhci: split handling halted endpoints into two steps")
Cc: <stable@vger.kernel.org> # 5.12
Reported-by: Peter Ganzhorn <peter.ganzhorn@googlemail.com>
Tested-by: Peter Ganzhorn <peter.ganzhorn@googlemail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210525074100.1154090-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -934,14 +934,18 @@ static int xhci_invalidate_cancelled_tds
 			continue;
 		}
 		/*
-		 * If ring stopped on the TD we need to cancel, then we have to
+		 * If a ring stopped on the TD we need to cancel then we have to
 		 * move the xHC endpoint ring dequeue pointer past this TD.
+		 * Rings halted due to STALL may show hw_deq is past the stalled
+		 * TD, but still require a set TR Deq command to flush xHC cache.
 		 */
 		hw_deq = xhci_get_hw_deq(xhci, ep->vdev, ep->ep_index,
 					 td->urb->stream_id);
 		hw_deq &= ~0xf;
 
-		if (trb_in_td(xhci, td->start_seg, td->first_trb,
+		if (td->cancel_status == TD_HALTED) {
+			cached_td = td;
+		} else if (trb_in_td(xhci, td->start_seg, td->first_trb,
 			      td->last_trb, hw_deq, false)) {
 			switch (td->cancel_status) {
 			case TD_CLEARED: /* TD is already no-op */


