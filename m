Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2463284D4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235266AbhCAQnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:43:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:41574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233004AbhCAQgz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:36:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3943A64F42;
        Mon,  1 Mar 2021 16:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616004;
        bh=M34w/zap8absiL+D+1BoyhxGswPSwaINYkePrI6viOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FFNZvF9OLLnw8/vGWAxFNJo1bXh313TaRRaEVkumgbL/yu2Jeu8wbFWdQo6Qs4oRk
         WE+sPCX6Xrg6h5nsuUdXY2QaDFC++rqnJegkOrUGQ17CfwMRwYEvqTIsBePWBq7/00
         gZ6eXXDcTTd6nixwCVSIFsTK3TjTXXuPcWpnK/tQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+15ec7391f3d6a1a7cc7d@syzkaller.appspotmail.com,
        Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Subject: [PATCH 4.9 106/134] drivers/misc/vmw_vmci: restrict too big queue size in qp_host_alloc_queue
Date:   Mon,  1 Mar 2021 17:13:27 +0100
Message-Id: <20210301161018.782681523@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>

commit 2fd10bcf0310b9525b2af9e1f7aa9ddd87c3772e upstream.

syzbot found WARNING in qp_broker_alloc[1] in qp_host_alloc_queue()
when num_pages is 0x100001, giving queue_size + queue_page_size
bigger than KMALLOC_MAX_SIZE for kzalloc(), resulting order >= MAX_ORDER
condition.

queue_size + queue_page_size=0x8000d8, where KMALLOC_MAX_SIZE=0x400000.

[1]
Call Trace:
 alloc_pages include/linux/gfp.h:547 [inline]
 kmalloc_order+0x40/0x130 mm/slab_common.c:837
 kmalloc_order_trace+0x15/0x70 mm/slab_common.c:853
 kmalloc_large include/linux/slab.h:481 [inline]
 __kmalloc+0x257/0x330 mm/slub.c:3959
 kmalloc include/linux/slab.h:557 [inline]
 kzalloc include/linux/slab.h:682 [inline]
 qp_host_alloc_queue drivers/misc/vmw_vmci/vmci_queue_pair.c:540 [inline]
 qp_broker_create drivers/misc/vmw_vmci/vmci_queue_pair.c:1351 [inline]
 qp_broker_alloc+0x936/0x2740 drivers/misc/vmw_vmci/vmci_queue_pair.c:1739

Reported-by: syzbot+15ec7391f3d6a1a7cc7d@syzkaller.appspotmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Link: https://lore.kernel.org/r/20210209102612.2112247-1-snovitoll@gmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/vmw_vmci/vmci_queue_pair.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/misc/vmw_vmci/vmci_queue_pair.c
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
@@ -639,6 +639,9 @@ static struct vmci_queue *qp_host_alloc_
 
 	queue_page_size = num_pages * sizeof(*queue->kernel_if->u.h.page);
 
+	if (queue_size + queue_page_size > KMALLOC_MAX_SIZE)
+		return NULL;
+
 	queue = kzalloc(queue_size + queue_page_size, GFP_KERNEL);
 	if (queue) {
 		queue->q_header = NULL;


