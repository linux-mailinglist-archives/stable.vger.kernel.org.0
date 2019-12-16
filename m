Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD3EE12164D
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731069AbfLPSPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:15:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:35638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731140AbfLPSPI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:15:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9A9E207FF;
        Mon, 16 Dec 2019 18:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520108;
        bh=5a748kLGJg5Pdn84wMLWJVrxWQepfISWoeHI/WVEMYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ARlEaBRu1bYrOkeb2U5wAMwPEP9z024/pQq8m2etAfOCR+GIHX2kmkgfEzFqu15V3
         JnBGqEi+DI0XteCibZrBgSiv7O778EBFGnLNsjI6CDAjxD3KgL1GopiEnomupuV+Il
         caJYTbh6/yPreFCYXISNLZ1hPuD0ohaTKGYiPNXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 5.4 002/177] usb: gadget: pch_udc: fix use after free
Date:   Mon, 16 Dec 2019 18:47:38 +0100
Message-Id: <20191216174811.579762730@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
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
@@ -1519,7 +1519,6 @@ static void pch_udc_free_dma_chain(struc
 		td = phys_to_virt(addr);
 		addr2 = (dma_addr_t)td->next;
 		dma_pool_free(dev->data_requests, td, addr);
-		td->next = 0x00;
 		addr = addr2;
 	}
 	req->chain_len = 1;


