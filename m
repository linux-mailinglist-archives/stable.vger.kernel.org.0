Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05BE8313682
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbhBHPLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:11:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:52242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233213AbhBHPHt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:07:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D456164EAC;
        Mon,  8 Feb 2021 15:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796763;
        bh=ilW9tlGTvGucd3EwDI6duTFYu25KxszIyWc7Px5kUEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1eg2Qakt+L7aGj1l5DaaOqd73QXicahb4Jbw0J+rcAd0jdFQmJvzsxxXSBnexfrEh
         pTAuAvIlxgFcaz8NiWdnTE7GhzWvcHFllW0P2ACjGwJ+HBZj/NVk3OZUbG/ct/TJQg
         eKi37RYzznz3x7/densqG8NFqgSHnpqi/sPVDLb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gerhard Klostermeier <gerhard.klostermeier@syss.de>,
        Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
Subject: [PATCH 4.14 12/30] usb: dwc2: Fix endpoint direction check in ep_from_windex
Date:   Mon,  8 Feb 2021 16:00:58 +0100
Message-Id: <20210208145805.747408062@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145805.239714726@linuxfoundation.org>
References: <20210208145805.239714726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>

commit f670e9f9c8cac716c3506c6bac9e997b27ad441a upstream.

dwc2_hsotg_process_req_status uses ep_from_windex() to retrieve
the endpoint for the index provided in the wIndex request param.

In a test-case with a rndis gadget running and sending a malformed
packet to it like:
    dev.ctrl_transfer(
        0x82,      # bmRequestType
        0x00,       # bRequest
        0x0000,     # wValue
        0x0001,     # wIndex
        0x00       # wLength
    )
it is possible to cause a crash:

[  217.533022] dwc2 ff300000.usb: dwc2_hsotg_process_req_status: USB_REQ_GET_STATUS
[  217.559003] Unable to handle kernel read from unreadable memory at virtual address 0000000000000088
...
[  218.313189] Call trace:
[  218.330217]  ep_from_windex+0x3c/0x54
[  218.348565]  usb_gadget_giveback_request+0x10/0x20
[  218.368056]  dwc2_hsotg_complete_request+0x144/0x184

This happens because ep_from_windex wants to compare the endpoint
direction even if index_to_ep() didn't return an endpoint due to
the direction not matching.

The fix is easy insofar that the actual direction check is already
happening when calling index_to_ep() which will return NULL if there
is no endpoint for the targeted direction, so the offending check
can go away completely.

Fixes: c6f5c050e2a7 ("usb: dwc2: gadget: add bi-directional endpoint support")
Cc: stable@vger.kernel.org
Reported-by: Gerhard Klostermeier <gerhard.klostermeier@syss.de>
Signed-off-by: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
Link: https://lore.kernel.org/r/20210127103919.58215-1-heiko@sntech.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/gadget.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -1470,7 +1470,6 @@ static void dwc2_hsotg_complete_oursetup
 static struct dwc2_hsotg_ep *ep_from_windex(struct dwc2_hsotg *hsotg,
 					    u32 windex)
 {
-	struct dwc2_hsotg_ep *ep;
 	int dir = (windex & USB_DIR_IN) ? 1 : 0;
 	int idx = windex & 0x7F;
 
@@ -1480,12 +1479,7 @@ static struct dwc2_hsotg_ep *ep_from_win
 	if (idx > hsotg->num_of_eps)
 		return NULL;
 
-	ep = index_to_ep(hsotg, idx, dir);
-
-	if (idx && ep->dir_in != dir)
-		return NULL;
-
-	return ep;
+	return index_to_ep(hsotg, idx, dir);
 }
 
 /**


