Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 791A9479A0E
	for <lists+stable@lfdr.de>; Sat, 18 Dec 2021 10:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbhLRJ6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Dec 2021 04:58:05 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:36672 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S232590AbhLRJ6D (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Dec 2021 04:58:03 -0500
X-UUID: ef6e3dc7af2d45eabe733e8796fb6a9e-20211218
X-UUID: ef6e3dc7af2d45eabe733e8796fb6a9e-20211218
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1847628503; Sat, 18 Dec 2021 17:57:59 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 18 Dec 2021 17:57:58 +0800
Received: from mhfsdcap04.gcn.mediatek.inc (10.17.3.154) by
 mtkcas10.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Sat, 18 Dec 2021 17:57:57 +0800
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Eddie Hung <eddie.hung@mediatek.com>, <stable@vger.kernel.org>,
        Yuwen Ng <yuwen.ng@mediatek.com>
Subject: [PATCH v2 3/4] usb: mtu3: fix list_head check warning
Date:   Sat, 18 Dec 2021 17:57:48 +0800
Message-ID: <20211218095749.6250-3-chunfeng.yun@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218095749.6250-1-chunfeng.yun@mediatek.com>
References: <20211218095749.6250-1-chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
v2: add Fixes and Cc suggested by Greg
---
 drivers/usb/mtu3/mtu3_gadget.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/mtu3/mtu3_gadget.c b/drivers/usb/mtu3/mtu3_gadget.c
index c51be015345b..b6c8a4a99c4d 100644
--- a/drivers/usb/mtu3/mtu3_gadget.c
+++ b/drivers/usb/mtu3/mtu3_gadget.c
@@ -235,6 +235,7 @@ struct usb_request *mtu3_alloc_request(struct usb_ep *ep, gfp_t gfp_flags)
 	mreq->request.dma = DMA_ADDR_INVALID;
 	mreq->epnum = mep->epnum;
 	mreq->mep = mep;
+	INIT_LIST_HEAD(&mreq->list);
 	trace_mtu3_alloc_request(mreq);
 
 	return &mreq->request;
-- 
2.18.0

