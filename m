Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210183E81AD
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbhHJSBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:01:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238075AbhHJR7S (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:59:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A294061052;
        Tue, 10 Aug 2021 17:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617576;
        bh=ZsicAsX+Fv+8jxm2benBeh1W3xj+m163yJCYck4zA4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XriQ/rrqEJ9KjJa2B45qKdH/H2NgfH5PVJCAfvNTx/PR+itP1WHBY5pwRwogw4XDB
         xzAdlGkTntjWLOKeYKSsqE75SOAL015VR98wwazqUp1DlTSNQR6pAIajM8TzyYDLwF
         ryGau3a/YD0Ellfsrr/wjVaMmbn/aOVMHJIngcjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filip Schauer <filip@mg6.at>
Subject: [PATCH 5.13 119/175] drivers core: Fix oops when driver probe fails
Date:   Tue, 10 Aug 2021 19:30:27 +0200
Message-Id: <20210810173004.866022968@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filip Schauer <filip@mg6.at>

commit 4d1014c1816c0395eca5d1d480f196a4c63119d0 upstream.

dma_range_map is freed to early, which might cause an oops when
a driver probe fails.
 Call trace:
  is_free_buddy_page+0xe4/0x1d4
  __free_pages+0x2c/0x88
  dma_free_contiguous+0x64/0x80
  dma_direct_free+0x38/0xb4
  dma_free_attrs+0x88/0xa0
  dmam_release+0x28/0x34
  release_nodes+0x78/0x8c
  devres_release_all+0xa8/0x110
  really_probe+0x118/0x2d0
  __driver_probe_device+0xc8/0xe0
  driver_probe_device+0x54/0xec
  __driver_attach+0xe0/0xf0
  bus_for_each_dev+0x7c/0xc8
  driver_attach+0x30/0x3c
  bus_add_driver+0x17c/0x1c4
  driver_register+0xc0/0xf8
  __platform_driver_register+0x34/0x40
  ...

This issue is introduced by commit d0243bbd5dd3 ("drivers core:
Free dma_range_map when driver probe failed"). It frees
dma_range_map before the call to devres_release_all, which is too
early. The solution is to free dma_range_map only after
devres_release_all.

Fixes: d0243bbd5dd3 ("drivers core: Free dma_range_map when driver probe failed")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Filip Schauer <filip@mg6.at>
Link: https://lore.kernel.org/r/20210727112311.GA7645@DESKTOP-E8BN1B0.localdomain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/dd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -634,8 +634,6 @@ dev_groups_failed:
 	else if (drv->remove)
 		drv->remove(dev);
 probe_failed:
-	kfree(dev->dma_range_map);
-	dev->dma_range_map = NULL;
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 					     BUS_NOTIFY_DRIVER_NOT_BOUND, dev);
@@ -643,6 +641,8 @@ pinctrl_bind_failed:
 	device_links_no_driver(dev);
 	devres_release_all(dev);
 	arch_teardown_dma_ops(dev);
+	kfree(dev->dma_range_map);
+	dev->dma_range_map = NULL;
 	driver_sysfs_remove(dev);
 	dev->driver = NULL;
 	dev_set_drvdata(dev, NULL);


