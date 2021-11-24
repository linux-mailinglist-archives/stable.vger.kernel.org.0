Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7EB45BA2D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240834AbhKXMIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:08:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:34272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233543AbhKXMHA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:07:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB32E60C51;
        Wed, 24 Nov 2021 12:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755431;
        bh=F4eNFyJm5WoYxKUWjpQAcaTi1pCk82JppJb9aHHpSlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mni0Os7L+lli96IGlgtKJf3OZTewBwA/FSQ01XgIwBOKS+JNlFv6HOhdbn2ofLBSE
         cP+ho76dnJHzZvGZzJYttjbH7ODx/BZ+CoZCCXwqTuHtzUqH4IonPY4+f6Quw57z9J
         N2Laz5ivdENvzJu4GAHUz4ShljPnNZoF5dRoAXG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 060/162] memstick: r592: Fix a UAF bug when removing the driver
Date:   Wed, 24 Nov 2021 12:56:03 +0100
Message-Id: <20211124115700.277973042@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 738216c1953e802aa9f930c5d15b8f9092c847ff ]

In r592_remove(), the driver will free dma after freeing the host, which
may cause a UAF bug.

The following log reveals it:

[   45.361796 ] BUG: KASAN: use-after-free in r592_remove+0x269/0x350 [r592]
[   45.364286 ] Call Trace:
[   45.364472 ]  dump_stack_lvl+0xa8/0xd1
[   45.364751 ]  print_address_description+0x87/0x3b0
[   45.365137 ]  kasan_report+0x172/0x1c0
[   45.365415 ]  ? r592_remove+0x269/0x350 [r592]
[   45.365834 ]  ? r592_remove+0x269/0x350 [r592]
[   45.366168 ]  __asan_report_load8_noabort+0x14/0x20
[   45.366531 ]  r592_remove+0x269/0x350 [r592]
[   45.378785 ]
[   45.378903 ] Allocated by task 4674:
[   45.379162 ]  ____kasan_kmalloc+0xb5/0xe0
[   45.379455 ]  __kasan_kmalloc+0x9/0x10
[   45.379730 ]  __kmalloc+0x150/0x280
[   45.379984 ]  memstick_alloc_host+0x2a/0x190
[   45.380664 ]
[   45.380781 ] Freed by task 5509:
[   45.381014 ]  kasan_set_track+0x3d/0x70
[   45.381293 ]  kasan_set_free_info+0x23/0x40
[   45.381635 ]  ____kasan_slab_free+0x10b/0x140
[   45.381950 ]  __kasan_slab_free+0x11/0x20
[   45.382241 ]  slab_free_freelist_hook+0x81/0x150
[   45.382575 ]  kfree+0x13e/0x290
[   45.382805 ]  memstick_free+0x1c/0x20
[   45.383070 ]  device_release+0x9c/0x1d0
[   45.383349 ]  kobject_put+0x2ef/0x4c0
[   45.383616 ]  put_device+0x1f/0x30
[   45.383865 ]  memstick_free_host+0x24/0x30
[   45.384162 ]  r592_remove+0x242/0x350 [r592]
[   45.384473 ]  pci_device_remove+0xa9/0x250

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Link: https://lore.kernel.org/r/1634383581-11055-1-git-send-email-zheyuma97@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memstick/host/r592.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/memstick/host/r592.c b/drivers/memstick/host/r592.c
index b3857445d6736..7779aaa6b9b81 100644
--- a/drivers/memstick/host/r592.c
+++ b/drivers/memstick/host/r592.c
@@ -842,15 +842,15 @@ static void r592_remove(struct pci_dev *pdev)
 	}
 	memstick_remove_host(dev->host);
 
+	if (dev->dummy_dma_page)
+		dma_free_coherent(&pdev->dev, PAGE_SIZE, dev->dummy_dma_page,
+			dev->dummy_dma_page_physical_address);
+
 	free_irq(dev->irq, dev);
 	iounmap(dev->mmio);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 	memstick_free_host(dev->host);
-
-	if (dev->dummy_dma_page)
-		dma_free_coherent(&pdev->dev, PAGE_SIZE, dev->dummy_dma_page,
-			dev->dummy_dma_page_physical_address);
 }
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.33.0



