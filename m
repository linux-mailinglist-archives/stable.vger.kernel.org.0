Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF6B5106F9D
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfKVKul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:50:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:60704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727173AbfKVKug (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:50:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AB13205C9;
        Fri, 22 Nov 2019 10:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419836;
        bh=QNKsw1ScWAI/B1oICO7w9vn1HmKyrpOW0OpdHrOzMbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJMEOfIP7s6pRDDG/FFxjdYO3JJxWlt/GtOratC1cNtGgwT7z+inBKh8KdbP4tLDG
         MG7VF4hiSesw13icbUPhTWWKeFRjuMgNB+vt9J3CcrNaLlSyBwgOojEz9Rw9yi38Qd
         zGXhnAoQk+fYO1TBvEw+nzSgkAGMDdz/zkDocfDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 025/122] usb: gadget: udc: fotg210-udc: Fix a sleep-in-atomic-context bug in fotg210_get_status()
Date:   Fri, 22 Nov 2019 11:27:58 +0100
Message-Id: <20191122100740.548126868@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 2337a77c1cc86bc4e504ecf3799f947659c86026 ]

The driver may sleep in an interrupt handler.
The function call path (from bottom to top) in Linux-4.17 is:

[FUNC] fotg210_ep_queue(GFP_KERNEL)
drivers/usb/gadget/udc/fotg210-udc.c, 744:
	fotg210_ep_queue in fotg210_get_status
drivers/usb/gadget/udc/fotg210-udc.c, 768:
	fotg210_get_status in fotg210_setup_packet
drivers/usb/gadget/udc/fotg210-udc.c, 949:
	fotg210_setup_packet in fotg210_irq (interrupt handler)

To fix this bug, GFP_KERNEL is replaced with GFP_ATOMIC.
If possible, spin_unlock() and spin_lock() around fotg210_ep_queue()
can be also removed.

This bug is found by my static analysis tool DSAC.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/fotg210-udc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/fotg210-udc.c b/drivers/usb/gadget/udc/fotg210-udc.c
index d17d7052605ba..6866a0be249e4 100644
--- a/drivers/usb/gadget/udc/fotg210-udc.c
+++ b/drivers/usb/gadget/udc/fotg210-udc.c
@@ -744,7 +744,7 @@ static void fotg210_get_status(struct fotg210_udc *fotg210,
 	fotg210->ep0_req->length = 2;
 
 	spin_unlock(&fotg210->lock);
-	fotg210_ep_queue(fotg210->gadget.ep0, fotg210->ep0_req, GFP_KERNEL);
+	fotg210_ep_queue(fotg210->gadget.ep0, fotg210->ep0_req, GFP_ATOMIC);
 	spin_lock(&fotg210->lock);
 }
 
-- 
2.20.1



