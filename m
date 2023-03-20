Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D506C1722
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbjCTPMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbjCTPLg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:11:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5992ED7D;
        Mon, 20 Mar 2023 08:06:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3131561590;
        Mon, 20 Mar 2023 15:06:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40979C4339B;
        Mon, 20 Mar 2023 15:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324796;
        bh=FGhj+Dsz92X2+5UcnDsbRDcofJC7lWDEjheT5sM0jms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DERsDA0kARLaxpWMfzqd5XIP1tUhFXtA+qqmsWrbTlFRUIMSHraxmMeu5hCoVIXXA
         IylAalBIAcSoTizI4374vsY9JIAmh6mEImedxJXSOq+P2iuzGvfmJIUM5nxVdFlre2
         34yrGDOOs7VR+lPgnEAUeq5XepCdIqouPkj3NtXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Amit Sunil Dhamne <amit.sunil.dhamne@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5.10 59/99] firmware: xilinx: dont make a sleepable memory allocation from an atomic context
Date:   Mon, 20 Mar 2023 15:54:37 +0100
Message-Id: <20230320145445.853890193@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Gushchin <roman.gushchin@linux.dev>

commit 38ed310c22e7a0fc978b1f8292136a4a4a8b3051 upstream.

The following issue was discovered using lockdep:
[    6.691371] BUG: sleeping function called from invalid context at include/linux/sched/mm.h:209
[    6.694602] in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 1, name: swapper/0
[    6.702431] 2 locks held by swapper/0/1:
[    6.706300]  #0: ffffff8800f6f188 (&dev->mutex){....}-{3:3}, at: __device_driver_lock+0x4c/0x90
[    6.714900]  #1: ffffffc009a2abb8 (enable_lock){....}-{2:2}, at: clk_enable_lock+0x4c/0x140
[    6.723156] irq event stamp: 304030
[    6.726596] hardirqs last  enabled at (304029): [<ffffffc008d17ee0>] _raw_spin_unlock_irqrestore+0xc0/0xd0
[    6.736142] hardirqs last disabled at (304030): [<ffffffc00876bc5c>] clk_enable_lock+0xfc/0x140
[    6.744742] softirqs last  enabled at (303958): [<ffffffc0080904f0>] _stext+0x4f0/0x894
[    6.752655] softirqs last disabled at (303951): [<ffffffc0080e53b8>] irq_exit+0x238/0x280
[    6.760744] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G     U            5.15.36 #2
[    6.768048] Hardware name: xlnx,zynqmp (DT)
[    6.772179] Call trace:
[    6.774584]  dump_backtrace+0x0/0x300
[    6.778197]  show_stack+0x18/0x30
[    6.781465]  dump_stack_lvl+0xb8/0xec
[    6.785077]  dump_stack+0x1c/0x38
[    6.788345]  ___might_sleep+0x1a8/0x2a0
[    6.792129]  __might_sleep+0x6c/0xd0
[    6.795655]  kmem_cache_alloc_trace+0x270/0x3d0
[    6.800127]  do_feature_check_call+0x100/0x220
[    6.804513]  zynqmp_pm_invoke_fn+0x8c/0xb0
[    6.808555]  zynqmp_pm_clock_getstate+0x90/0xe0
[    6.813027]  zynqmp_pll_is_enabled+0x8c/0x120
[    6.817327]  zynqmp_pll_enable+0x38/0xc0
[    6.821197]  clk_core_enable+0x144/0x400
[    6.825067]  clk_core_enable+0xd4/0x400
[    6.828851]  clk_core_enable+0xd4/0x400
[    6.832635]  clk_core_enable+0xd4/0x400
[    6.836419]  clk_core_enable+0xd4/0x400
[    6.840203]  clk_core_enable+0xd4/0x400
[    6.843987]  clk_core_enable+0xd4/0x400
[    6.847771]  clk_core_enable+0xd4/0x400
[    6.851555]  clk_core_enable_lock+0x24/0x50
[    6.855683]  clk_enable+0x24/0x40
[    6.858952]  fclk_probe+0x84/0xf0
[    6.862220]  platform_probe+0x8c/0x110
[    6.865918]  really_probe+0x110/0x5f0
[    6.869530]  __driver_probe_device+0xcc/0x210
[    6.873830]  driver_probe_device+0x64/0x140
[    6.877958]  __driver_attach+0x114/0x1f0
[    6.881828]  bus_for_each_dev+0xe8/0x160
[    6.885698]  driver_attach+0x34/0x50
[    6.889224]  bus_add_driver+0x228/0x300
[    6.893008]  driver_register+0xc0/0x1e0
[    6.896792]  __platform_driver_register+0x44/0x60
[    6.901436]  fclk_driver_init+0x1c/0x28
[    6.905220]  do_one_initcall+0x104/0x590
[    6.909091]  kernel_init_freeable+0x254/0x2bc
[    6.913390]  kernel_init+0x24/0x130
[    6.916831]  ret_from_fork+0x10/0x20

Fix it by passing the GFP_ATOMIC gfp flag for the corresponding
memory allocation.

Fixes: acfdd18591ea ("firmware: xilinx: Use hash-table for api feature check")
Cc: stable <stable@kernel.org>
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Amit Sunil Dhamne <amit.sunil.dhamne@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Link: https://lore.kernel.org/r/20230308222602.123866-1-roman.gushchin@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/xilinx/zynqmp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/xilinx/zynqmp.c
+++ b/drivers/firmware/xilinx/zynqmp.c
@@ -171,7 +171,7 @@ static int zynqmp_pm_feature(u32 api_id)
 	}
 
 	/* Add new entry if not present */
-	feature_data = kmalloc(sizeof(*feature_data), GFP_KERNEL);
+	feature_data = kmalloc(sizeof(*feature_data), GFP_ATOMIC);
 	if (!feature_data)
 		return -ENOMEM;
 


