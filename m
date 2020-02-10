Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7963C157AAC
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbgBJNYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:24:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:57880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728000AbgBJMhD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:03 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18702208C4;
        Mon, 10 Feb 2020 12:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338223;
        bh=Ij0hfG6Hsb9nxUaFvyNt85tsg8GkDcEXtR5HNI+GKqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+8DMkF8vGQNX58sUJmEKDvuhUCY8b/ILcqffeemsiLYMV8BP1Qbz7dptpewwyn2i
         4rj4nf8iriMWlKRslNkBOgUXWg1sxtKyoJgvqvSjFi7uJpv+yvGOnchdKr5IlxBqM8
         zceMNeZKbOy+tk1jo8Qf9TSmrhSyLlqP5RrtCq6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Hao <haokexin@gmail.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.4 059/309] irqdomain: Fix a memory leak in irq_domain_push_irq()
Date:   Mon, 10 Feb 2020 04:30:15 -0800
Message-Id: <20200210122411.636308109@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Hao <haokexin@gmail.com>

commit 0f394daef89b38d58c91118a2b08b8a1b316703b upstream.

Fix a memory leak reported by kmemleak:
unreferenced object 0xffff000bc6f50e80 (size 128):
  comm "kworker/23:2", pid 201, jiffies 4294894947 (age 942.132s)
  hex dump (first 32 bytes):
    00 00 00 00 41 00 00 00 86 c0 03 00 00 00 00 00  ....A...........
    00 a0 b2 c6 0b 00 ff ff 40 51 fd 10 00 80 ff ff  ........@Q......
  backtrace:
    [<00000000e62d2240>] kmem_cache_alloc_trace+0x1a4/0x320
    [<00000000279143c9>] irq_domain_push_irq+0x7c/0x188
    [<00000000d9f4c154>] thunderx_gpio_probe+0x3ac/0x438
    [<00000000fd09ec22>] pci_device_probe+0xe4/0x198
    [<00000000d43eca75>] really_probe+0xdc/0x320
    [<00000000d3ebab09>] driver_probe_device+0x5c/0xf0
    [<000000005b3ecaa0>] __device_attach_driver+0x88/0xc0
    [<000000004e5915f5>] bus_for_each_drv+0x7c/0xc8
    [<0000000079d4db41>] __device_attach+0xe4/0x140
    [<00000000883bbda9>] device_initial_probe+0x18/0x20
    [<000000003be59ef6>] bus_probe_device+0x98/0xa0
    [<0000000039b03d3f>] deferred_probe_work_func+0x74/0xa8
    [<00000000870934ce>] process_one_work+0x1c8/0x470
    [<00000000e3cce570>] worker_thread+0x1f8/0x428
    [<000000005d64975e>] kthread+0xfc/0x128
    [<00000000f0eaa764>] ret_from_fork+0x10/0x18

Fixes: 495c38d3001f ("irqdomain: Add irq_domain_{push,pop}_irq() functions")
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200120043547.22271-1-haokexin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/irq/irqdomain.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -1459,6 +1459,7 @@ int irq_domain_push_irq(struct irq_domai
 	if (rv) {
 		/* Restore the original irq_data. */
 		*root_irq_data = *child_irq_data;
+		kfree(child_irq_data);
 		goto error;
 	}
 


