Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC782396183
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbhEaOlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:41:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234157AbhEaOjf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:39:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B34261C64;
        Mon, 31 May 2021 13:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469163;
        bh=IIXP4rILIB9WbdcFuN8WG8aqTxMgdHBoZdvAbZ7rP6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G9BfRCPIAOQhI+RRsz+ofl86nJNXQIyHJ0r+A8O3ZhXrkjEHczgaQI0G8n5O+WFDi
         U83jvN+jIpaPbDEkBMjk22WI9e7f+E+ZsQUspwIM26dQKy0jPJJQCGKp9NZ4ZVgnR9
         kmckptkX+eYlPSZPrBn/S8SDhVb2mq5jCvxH4ZIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Peter Ganzhorn <peter.ganzhorn@googlemail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.12 092/296] xhci: fix giving back URB with incorrect status regression in 5.12
Date:   Mon, 31 May 2021 15:12:27 +0200
Message-Id: <20210531130706.991685783@linuxfoundation.org>
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

commit a80c203c3f1c06d2201c19ae071d0ae770a2b1ca upstream.

5.12 kernel changes how xhci handles cancelled URBs and halted
endpoints. Among these changes cancelled and stalled URBs are no longer
given back before they are cleared from xHC hardware cache.

These changes unfortunately cleared the -EPIPE status of a stalled
transfer in one case before giving bak the URB, causing a USB card reader
to fail from working.

Fixes: 674f8438c121 ("xhci: split handling halted endpoints into two steps")
Cc: <stable@vger.kernel.org> # 5.12
Reported-by: Peter Ganzhorn <peter.ganzhorn@googlemail.com>
Tested-by: Peter Ganzhorn <peter.ganzhorn@googlemail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210525074100.1154090-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -829,14 +829,10 @@ static void xhci_giveback_invalidated_td
 	list_for_each_entry_safe(td, tmp_td, &ep->cancelled_td_list,
 				 cancelled_td_list) {
 
-		/*
-		 * Doesn't matter what we pass for status, since the core will
-		 * just overwrite it (because the URB has been unlinked).
-		 */
 		ring = xhci_urb_to_transfer_ring(ep->xhci, td->urb);
 
 		if (td->cancel_status == TD_CLEARED)
-			xhci_td_cleanup(ep->xhci, td, ring, 0);
+			xhci_td_cleanup(ep->xhci, td, ring, td->status);
 
 		if (ep->xhci->xhc_state & XHCI_STATE_DYING)
 			return;


