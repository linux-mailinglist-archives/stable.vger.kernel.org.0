Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB081AC806
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394883AbgDPPC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:02:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897385AbgDPNx5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:53:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84C2A20732;
        Thu, 16 Apr 2020 13:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045237;
        bh=kgB0fWHWLd8OQi91eKRL0HlRnAwZjRg96qiPO2GbR5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FPtsiaNkeYAU1ZYzvu5ShuPqNdyEOYFGtyKGT6dy6n6j7HYr9HoqLjWiBn8qePKMr
         ineNJB5/7uK7CbxbsR5mZhaZV+ZtWGNxmiPIOi+4TEMl9ZOMvlMeI/pEk9+D6IHDIX
         52xbcB4RQ8fk2/dXakS1SbaSCNZdgSaBuc5oOkG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sahitya Tummala <stummala@codeaurora.org>,
        Pradeep P V K <ppvk@codeaurora.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 050/254] block: Fix use-after-free issue accessing struct io_cq
Date:   Thu, 16 Apr 2020 15:22:19 +0200
Message-Id: <20200416131332.137059548@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sahitya Tummala <stummala@codeaurora.org>

[ Upstream commit 30a2da7b7e225ef6c87a660419ea04d3cef3f6a7 ]

There is a potential race between ioc_release_fn() and
ioc_clear_queue() as shown below, due to which below kernel
crash is observed. It also can result into use-after-free
issue.

context#1:				context#2:
ioc_release_fn()			__ioc_clear_queue() gets the same icq
->spin_lock(&ioc->lock);		->spin_lock(&ioc->lock);
->ioc_destroy_icq(icq);
  ->list_del_init(&icq->q_node);
  ->call_rcu(&icq->__rcu_head,
  	icq_free_icq_rcu);
->spin_unlock(&ioc->lock);
					->ioc_destroy_icq(icq);
					  ->hlist_del_init(&icq->ioc_node);
					  This results into below crash as this memory
					  is now used by icq->__rcu_head in context#1.
					  There is a chance that icq could be free'd
					  as well.

22150.386550:   <6> Unable to handle kernel write to read-only memory
at virtual address ffffffaa8d31ca50
...
Call trace:
22150.607350:   <2>  ioc_destroy_icq+0x44/0x110
22150.611202:   <2>  ioc_clear_queue+0xac/0x148
22150.615056:   <2>  blk_cleanup_queue+0x11c/0x1a0
22150.619174:   <2>  __scsi_remove_device+0xdc/0x128
22150.623465:   <2>  scsi_forget_host+0x2c/0x78
22150.627315:   <2>  scsi_remove_host+0x7c/0x2a0
22150.631257:   <2>  usb_stor_disconnect+0x74/0xc8
22150.635371:   <2>  usb_unbind_interface+0xc8/0x278
22150.639665:   <2>  device_release_driver_internal+0x198/0x250
22150.644897:   <2>  device_release_driver+0x24/0x30
22150.649176:   <2>  bus_remove_device+0xec/0x140
22150.653204:   <2>  device_del+0x270/0x460
22150.656712:   <2>  usb_disable_device+0x120/0x390
22150.660918:   <2>  usb_disconnect+0xf4/0x2e0
22150.664684:   <2>  hub_event+0xd70/0x17e8
22150.668197:   <2>  process_one_work+0x210/0x480
22150.672222:   <2>  worker_thread+0x32c/0x4c8

Fix this by adding a new ICQ_DESTROYED flag in ioc_destroy_icq() to
indicate this icq is once marked as destroyed. Also, ensure
__ioc_clear_queue() is accessing icq within rcu_read_lock/unlock so
that icq doesn't get free'd up while it is still using it.

Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Co-developed-by: Pradeep P V K <ppvk@codeaurora.org>
Signed-off-by: Pradeep P V K <ppvk@codeaurora.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-ioc.c           | 7 +++++++
 include/linux/iocontext.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 5ed59ac6ae58b..9df50fb507caf 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -84,6 +84,7 @@ static void ioc_destroy_icq(struct io_cq *icq)
 	 * making it impossible to determine icq_cache.  Record it in @icq.
 	 */
 	icq->__rcu_icq_cache = et->icq_cache;
+	icq->flags |= ICQ_DESTROYED;
 	call_rcu(&icq->__rcu_head, icq_free_icq_rcu);
 }
 
@@ -212,15 +213,21 @@ static void __ioc_clear_queue(struct list_head *icq_list)
 {
 	unsigned long flags;
 
+	rcu_read_lock();
 	while (!list_empty(icq_list)) {
 		struct io_cq *icq = list_entry(icq_list->next,
 						struct io_cq, q_node);
 		struct io_context *ioc = icq->ioc;
 
 		spin_lock_irqsave(&ioc->lock, flags);
+		if (icq->flags & ICQ_DESTROYED) {
+			spin_unlock_irqrestore(&ioc->lock, flags);
+			continue;
+		}
 		ioc_destroy_icq(icq);
 		spin_unlock_irqrestore(&ioc->lock, flags);
 	}
+	rcu_read_unlock();
 }
 
 /**
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index dba15ca8e60bc..1dcd9198beb7f 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -8,6 +8,7 @@
 
 enum {
 	ICQ_EXITED		= 1 << 2,
+	ICQ_DESTROYED		= 1 << 3,
 };
 
 /*
-- 
2.20.1



