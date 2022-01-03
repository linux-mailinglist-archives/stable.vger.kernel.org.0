Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C5B48329C
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbiACO3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:29:17 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58320 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234133AbiACO2B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:28:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 668736111B;
        Mon,  3 Jan 2022 14:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE32C36AEE;
        Mon,  3 Jan 2022 14:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220079;
        bh=KHfhOfW6ps0SIGyPEE/RE/jPeJBdNnNF0tRb5eGgZ1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YizUP16ENDJzAKjlXH4aTJOdWw2pOER8bXuFaLCYoHiFl+CItEejO+rB8YsdxKD8P
         VRFYLQuY/orV0z4hjTb1HWRavkXDmbiYgSBTjntvUPcUkuPUPJ7s6HEsVsW0sfgVbB
         dTWVGp3H4yqrP3SZapQTRswGYFHLhqrqz5eEfEeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuwen Ng <yuwen.ng@mediatek.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 5.4 30/37] usb: mtu3: fix list_head check warning
Date:   Mon,  3 Jan 2022 15:24:08 +0100
Message-Id: <20220103142052.807297651@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142051.883166998@linuxfoundation.org>
References: <20220103142051.883166998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

commit 8c313e3bfd9adae8d5c4ba1cc696dcbc86fbf9bf upstream.

This is caused by uninitialization of list_head.

BUG: KASAN: use-after-free in __list_del_entry_valid+0x34/0xe4

Call trace:
dump_backtrace+0x0/0x298
show_stack+0x24/0x34
dump_stack+0x130/0x1a8
print_address_description+0x88/0x56c
__kasan_report+0x1b8/0x2a0
kasan_report+0x14/0x20
__asan_load8+0x9c/0xa0
__list_del_entry_valid+0x34/0xe4
mtu3_req_complete+0x4c/0x300 [mtu3]
mtu3_gadget_stop+0x168/0x448 [mtu3]
usb_gadget_unregister_driver+0x204/0x3a0
unregister_gadget_item+0x44/0xa4

Fixes: 83374e035b62 ("usb: mtu3: add tracepoints to help debug")
Cc: stable@vger.kernel.org
Reported-by: Yuwen Ng <yuwen.ng@mediatek.com>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/20211218095749.6250-3-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/mtu3/mtu3_gadget.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/mtu3/mtu3_gadget.c
+++ b/drivers/usb/mtu3/mtu3_gadget.c
@@ -245,6 +245,7 @@ struct usb_request *mtu3_alloc_request(s
 	mreq->request.dma = DMA_ADDR_INVALID;
 	mreq->epnum = mep->epnum;
 	mreq->mep = mep;
+	INIT_LIST_HEAD(&mreq->list);
 	trace_mtu3_alloc_request(mreq);
 
 	return &mreq->request;


