Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA3C3ED5CF
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238774AbhHPNPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:15:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238162AbhHPNM4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:12:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEBFC6328D;
        Mon, 16 Aug 2021 13:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119421;
        bh=WKGges9PuYUMOeGIn35Q8an5lf1XD3su9Jta17Pezjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fN+dNlcipkfN6qqHm9GFsoJA8Vxef+Qtbf5IUTlhY0gudEXiZqusWnWGtKaAp3Eh3
         hmLekLbigLP9q7HpgXMeoTN4+ys/IWWFaDeqE/48M3Uo0jpnHU6GckOx63o7i/gOAw
         3VCY0+H350MSGl7mw8I4rdIcDhb13MXMZ2CEXVuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        John Stultz <john.stultz@linaro.org>,
        Ray Chi <raychi@google.com>, Felipe Balbi <balbi@kernel.org>,
        Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 5.13 002/151] Revert "usb: dwc3: gadget: Use list_replace_init() before traversing lists"
Date:   Mon, 16 Aug 2021 15:00:32 +0200
Message-Id: <20210816125444.167955737@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 664cc971fb259007e49cc8a3ac43b0787d89443f upstream.

This reverts commit d25d85061bd856d6be221626605319154f9b5043 as it is
reported to cause problems on many different types of boards.

Reported-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Reported-by: John Stultz <john.stultz@linaro.org>
Cc: Ray Chi <raychi@google.com>
Link: https://lore.kernel.org/r/CANcMJZCEVxVLyFgLwK98hqBEdc0_n4P0x_K6Gih8zNH3ouzbJQ@mail.gmail.com
Fixes: d25d85061bd8 ("usb: dwc3: gadget: Use list_replace_init() before traversing lists")
Cc: stable <stable@vger.kernel.org>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: Wesley Cheng <wcheng@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1741,13 +1741,9 @@ static void dwc3_gadget_ep_cleanup_cance
 {
 	struct dwc3_request		*req;
 	struct dwc3_request		*tmp;
-	struct list_head		local;
 	struct dwc3			*dwc = dep->dwc;
 
-restart:
-	list_replace_init(&dep->cancelled_list, &local);
-
-	list_for_each_entry_safe(req, tmp, &local, list) {
+	list_for_each_entry_safe(req, tmp, &dep->cancelled_list, list) {
 		dwc3_gadget_ep_skip_trbs(dep, req);
 		switch (req->status) {
 		case DWC3_REQUEST_STATUS_DISCONNECTED:
@@ -1765,9 +1761,6 @@ restart:
 			break;
 		}
 	}
-
-	if (!list_empty(&dep->cancelled_list))
-		goto restart;
 }
 
 static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
@@ -2963,12 +2956,8 @@ static void dwc3_gadget_ep_cleanup_compl
 {
 	struct dwc3_request	*req;
 	struct dwc3_request	*tmp;
-	struct list_head	local;
 
-restart:
-	list_replace_init(&dep->started_list, &local);
-
-	list_for_each_entry_safe(req, tmp, &local, list) {
+	list_for_each_entry_safe(req, tmp, &dep->started_list, list) {
 		int ret;
 
 		ret = dwc3_gadget_ep_cleanup_completed_request(dep, event,
@@ -2976,9 +2965,6 @@ restart:
 		if (ret)
 			break;
 	}
-
-	if (!list_empty(&dep->started_list))
-		goto restart;
 }
 
 static bool dwc3_gadget_ep_should_continue(struct dwc3_ep *dep)


