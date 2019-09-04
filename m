Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA17A8DFB
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732118AbfIDRz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:55:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731852AbfIDRzZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:55:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D959A21883;
        Wed,  4 Sep 2019 17:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619724;
        bh=sCXRnZIpt207PlAEOn+zbeo+kxsHVsTNdhrxpRS55Ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PX2/A3EcM1mYnyHfJoaGAEscIScKMlurQaPMEMQ/FEIZMVYQrXUjtqLtLuB0avJYt
         ZDd4mEz63ujlUVkiYj672gYM/Bpnlfa6kc6tzvXRl/oKUv9hcYaB8PLUxykpMGZywn
         YIn88EDEuJOmRL2noFwR3DHBGOYz7xtQdL5vGobk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 11/77] isdn: mISDN: hfcsusb: Fix possible null-pointer dereferences in start_isoc_chain()
Date:   Wed,  4 Sep 2019 19:52:58 +0200
Message-Id: <20190904175304.717160069@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a0d57a552b836206ad7705a1060e6e1ce5a38203 ]

In start_isoc_chain(), usb_alloc_urb() on line 1392 may fail
and return NULL. At this time, fifo->iso[i].urb is assigned to NULL.

Then, fifo->iso[i].urb is used at some places, such as:
LINE 1405:    fill_isoc_urb(fifo->iso[i].urb, ...)
                  urb->number_of_packets = num_packets;
                  urb->transfer_flags = URB_ISO_ASAP;
                  urb->actual_length = 0;
                  urb->interval = interval;
LINE 1416:    fifo->iso[i].urb->...
LINE 1419:    fifo->iso[i].urb->...

Thus, possible null-pointer dereferences may occur.

To fix these bugs, "continue" is added to avoid using fifo->iso[i].urb
when it is NULL.

These bugs are found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/hfcsusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.c b/drivers/isdn/hardware/mISDN/hfcsusb.c
index c60c7998af173..6f19530ba2a93 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.c
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.c
@@ -1402,6 +1402,7 @@ start_isoc_chain(struct usb_fifo *fifo, int num_packets_per_urb,
 				printk(KERN_DEBUG
 				       "%s: %s: alloc urb for fifo %i failed",
 				       hw->name, __func__, fifo->fifonum);
+				continue;
 			}
 			fifo->iso[i].owner_fifo = (struct usb_fifo *) fifo;
 			fifo->iso[i].indx = i;
-- 
2.20.1



