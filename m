Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB750314E31
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 12:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhBILZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 06:25:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:47632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229710AbhBILXY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 06:23:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80F4564E5A;
        Tue,  9 Feb 2021 11:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612869764;
        bh=BGIOfdLFQYvp9UfrVVdwrvF7XmokHCPm6EhZQBkeo+c=;
        h=Subject:To:From:Date:From;
        b=QM2JnYjxFzYhgTmsfWiL7JbD3xJCTJqeGyn/ZhRl8lgdB3p6wqjjYyYecClqXbra3
         gsGcHSoPGubIAmB0MWlf9GSKD4hobLA/ng89vmvWbCjGHTFULEsI1qdkLrvBHY2P4u
         hOj4JMt/P+aTdky7LmyaSaIrkD/JJ062Gt+muO4A=
Subject: patch "drivers/misc/vmw_vmci: restrict too big queue size in" added to char-misc-testing
To:     snovitoll@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 09 Feb 2021 12:22:41 +0100
Message-ID: <16128697619520@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    drivers/misc/vmw_vmci: restrict too big queue size in

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 2fd10bcf0310b9525b2af9e1f7aa9ddd87c3772e Mon Sep 17 00:00:00 2001
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Date: Tue, 9 Feb 2021 16:26:12 +0600
Subject: drivers/misc/vmw_vmci: restrict too big queue size in
 qp_host_alloc_queue

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
 drivers/misc/vmw_vmci/vmci_queue_pair.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.c b/drivers/misc/vmw_vmci/vmci_queue_pair.c
index d787ddecee77..880c33ab9f47 100644
--- a/drivers/misc/vmw_vmci/vmci_queue_pair.c
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
@@ -539,6 +539,9 @@ static struct vmci_queue *qp_host_alloc_queue(u64 size)
 
 	queue_page_size = num_pages * sizeof(*queue->kernel_if->u.h.page);
 
+	if (queue_size + queue_page_size > KMALLOC_MAX_SIZE)
+		return NULL;
+
 	queue = kzalloc(queue_size + queue_page_size, GFP_KERNEL);
 	if (queue) {
 		queue->q_header = NULL;
-- 
2.30.0


