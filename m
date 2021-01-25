Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8C7302AD0
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbhAYSxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:53:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:39598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731232AbhAYSxN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:53:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2674C22D58;
        Mon, 25 Jan 2021 18:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600764;
        bh=Otdx/4uXP1vIh12+8pO3NNJbSGYpwcNiDH8GCaqQ3x0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lNQ4dSzv0CFhKB4vDgpmSGxSnn/Qlz1DiI+x7i+neqWpugouIZYjIsv5MGaIqJZwU
         iDZL3CVdYMQOGCPBVIQlgV5MVs+4Dc54oqFkxei0z2x39FpXOyQCSEmRojPucLC9uo
         Vi0edbmuYvPO5Jrt50hnnAeBP+ClemWIY9Oue6CU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meng Li <Meng.Li@windriver.com>
Subject: [PATCH 5.10 142/199] drivers core: Free dma_range_map when driver probe failed
Date:   Mon, 25 Jan 2021 19:39:24 +0100
Message-Id: <20210125183222.206380485@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Meng Li <Meng.Li@windriver.com>

commit d0243bbd5dd3ebbd49dafa8b56bb911d971131d0 upstream.

There will be memory leak if driver probe failed. Trace as below:
  backtrace:
    [<000000002415258f>] kmemleak_alloc+0x3c/0x50
    [<00000000f447ebe4>] __kmalloc+0x208/0x530
    [<0000000048bc7b3a>] of_dma_get_range+0xe4/0x1b0
    [<0000000041e39065>] of_dma_configure_id+0x58/0x27c
    [<000000006356866a>] platform_dma_configure+0x2c/0x40
    ......
    [<000000000afcf9b5>] ret_from_fork+0x10/0x3c

This issue is introduced by commit e0d072782c73("dma-mapping:
introduce DMA range map, supplanting dma_pfn_offset "). It doesn't
free dma_range_map when driver probe failed and cause above
memory leak. So, add code to free it in error path.

Fixes: e0d072782c73 ("dma-mapping: introduce DMA range map, supplanting dma_pfn_offset ")
Cc: stable@vger.kernel.org
Signed-off-by: Meng Li <Meng.Li@windriver.com>
Link: https://lore.kernel.org/r/20210105070927.14968-1-Meng.Li@windriver.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/dd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -612,6 +612,8 @@ dev_groups_failed:
 	else if (drv->remove)
 		drv->remove(dev);
 probe_failed:
+	kfree(dev->dma_range_map);
+	dev->dma_range_map = NULL;
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 					     BUS_NOTIFY_DRIVER_NOT_BOUND, dev);


