Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6139712180E
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbfLPSBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:01:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:36850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727711AbfLPSBj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:01:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D8F32072D;
        Mon, 16 Dec 2019 18:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519299;
        bh=bHY+hH+oy5H5ZMf0BwWbtEFg6DNlTY265tdURzve4P8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDToMEgJskIG7qHqTCJiKRJOA5JGlnZEKsaxRnhoYFQLmgRzpjyFw/XPZSDARZQ76
         J8WkyxyLGIXJS+SxQNgO+YvmAXSdi9W31ITN1yMdaH/r5pXrk4K0j7RGNsrLfZXBT6
         iWeBy66HvEO9pN5d0jGz6varSBMloGm11f4xVJk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 4.19 002/140] usb: gadget: pch_udc: fix use after free
Date:   Mon, 16 Dec 2019 18:47:50 +0100
Message-Id: <20191216174748.287062615@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavo@embeddedor.com>

commit 66d1b0c0580b7f1b1850ee4423f32ac42afa2e92 upstream.

Remove pointer dereference after free.

pci_pool_free doesn't care about contents of td.
It's just a void* for it

Addresses-Coverity-ID: 1091173 ("Use after free")
Cc: stable@vger.kernel.org
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Link: https://lore.kernel.org/r/20191106202821.GA20347@embeddedor
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/udc/pch_udc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/gadget/udc/pch_udc.c
+++ b/drivers/usb/gadget/udc/pch_udc.c
@@ -1520,7 +1520,6 @@ static void pch_udc_free_dma_chain(struc
 		td = phys_to_virt(addr);
 		addr2 = (dma_addr_t)td->next;
 		dma_pool_free(dev->data_requests, td, addr);
-		td->next = 0x00;
 		addr = addr2;
 	}
 	req->chain_len = 1;


