Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6425417FCB3
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbgCJNWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:22:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727891AbgCJNBF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:01:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A26592467D;
        Tue, 10 Mar 2020 13:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845265;
        bh=ECmkxUpoyr1wOSULnzk6Oo5QIYAGvgFnObdab+nzFdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hj/Cgu9SDNcbu6zjX7t3JZXn5lR4LICTJq3PWPNLJ/wvxDVPGgxihaF/2ay/P46f3
         zoezqHKM8pTEVjH8LnNzoussAlfMCHHQZ5bv0lQSDg6tbdep3UOkmyMBA4xFFSKsF1
         pMl1baQk6D67aD0S4n0WLNA9xs4W3YX5IvXO8AnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@nxp.com>
Subject: [PATCH 5.5 073/189] usb: cdns3: gadget: link trb should point to next request
Date:   Tue, 10 Mar 2020 13:38:30 +0100
Message-Id: <20200310123647.002620209@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

commit 8a7c47fb7285b23ca259c888016513d5566fa9e8 upstream.

It has marked the dequeue trb as link trb, but its next segment
pointer is still itself, it causes the transfer can't go on. Fix
it by set its pointer as the trb address for the next request.

Fixes: f616c3bda47e ("usb: cdns3: Fix dequeue implementation")
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200219141455.23257-2-peter.chen@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/cdns3/gadget.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -2107,7 +2107,7 @@ found:
 	/* Update ring only if removed request is on pending_req_list list */
 	if (req_on_hw_ring) {
 		link_trb->buffer = TRB_BUFFER(priv_ep->trb_pool_dma +
-					      (priv_req->start_trb * TRB_SIZE));
+			((priv_req->end_trb + 1) * TRB_SIZE));
 		link_trb->control = (link_trb->control & TRB_CYCLE) |
 				    TRB_TYPE(TRB_LINK) | TRB_CHAIN;
 


