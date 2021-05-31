Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2303A395E3C
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbhEaN4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:56:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232183AbhEaNyB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:54:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03F8C6191D;
        Mon, 31 May 2021 13:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468019;
        bh=IGnyTuQjYOOw4G6t0SNltBrM51l310tTmm7+guOXb0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cZj1dmWV4xcLnHJ3KPLAeybinXjWyIc9y5wXmng34EsoLRAmPL6TrrEhhyg35eqcO
         eoAgVsKOdSBbtyHJqAc6IaKzMy6jHiU8UTExcTENlc7elUsy3Z99VujEOSeq/f+vxC
         TOTPiTLn9pj5PzFgmh4Ap0pY4ssMMLYOpnqj8N3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 5.10 087/252] usb: gadget: udc: renesas_usb3: Fix a race in usb3_start_pipen()
Date:   Mon, 31 May 2021 15:12:32 +0200
Message-Id: <20210531130700.936886724@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

commit e752dbc59e1241b13b8c4f7b6eb582862e7668fe upstream.

The usb3_start_pipen() is called by renesas_usb3_ep_queue() and
usb3_request_done_pipen() so that usb3_start_pipen() is possible
to cause a race when getting usb3_first_req like below:

renesas_usb3_ep_queue()
 spin_lock_irqsave()
 list_add_tail()
 spin_unlock_irqrestore()
 usb3_start_pipen()
  usb3_first_req = usb3_get_request() --- [1]
 --- interrupt ---
 usb3_irq_dma_int()
 usb3_request_done_pipen()
  usb3_get_request()
  usb3_start_pipen()
  usb3_first_req = usb3_get_request()
  ...
  (the req is possible to be finished in the interrupt)

The usb3_first_req [1] above may have been finished after the interrupt
ended so that this driver caused to start a transfer wrongly. To fix this
issue, getting/checking the usb3_first_req are under spin_lock_irqsave()
in the same section.

Fixes: 746bfe63bba3 ("usb: gadget: renesas_usb3: add support for Renesas USB3.0 peripheral controller")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20210524060155.1178724-1-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/renesas_usb3.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/udc/renesas_usb3.c
+++ b/drivers/usb/gadget/udc/renesas_usb3.c
@@ -1488,7 +1488,7 @@ static void usb3_start_pipen(struct rene
 			     struct renesas_usb3_request *usb3_req)
 {
 	struct renesas_usb3 *usb3 = usb3_ep_to_usb3(usb3_ep);
-	struct renesas_usb3_request *usb3_req_first = usb3_get_request(usb3_ep);
+	struct renesas_usb3_request *usb3_req_first;
 	unsigned long flags;
 	int ret = -EAGAIN;
 	u32 enable_bits = 0;
@@ -1496,7 +1496,8 @@ static void usb3_start_pipen(struct rene
 	spin_lock_irqsave(&usb3->lock, flags);
 	if (usb3_ep->halt || usb3_ep->started)
 		goto out;
-	if (usb3_req != usb3_req_first)
+	usb3_req_first = __usb3_get_request(usb3_ep);
+	if (!usb3_req_first || usb3_req != usb3_req_first)
 		goto out;
 
 	if (usb3_pn_change(usb3, usb3_ep->num) < 0)


