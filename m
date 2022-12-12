Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2674864A00E
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbiLLNTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbiLLNTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:19:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E86113DEA
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:18:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A3E4B80D3B
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4698FC43396;
        Mon, 12 Dec 2022 13:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851093;
        bh=c8sSGmDDcvTN2xMqNFTYlSDfD3XeucYpq/3DzkkWCHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VxAPab5ihev6DXqiulRuQepCsCda49UimDSeVjVPpZb1cKAwCW9+lPjgAkv8uw16N
         QD9eCcennxPriffcOzVeG+SS4c9jgkxsMCeYHWwIplhJZEd3JZ6kCaVLHFsd5h5dEc
         m9su3mqqXSWN+XTd8AVjQzhS9pioD3jWIWjyoXYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lin Liu <lin.liu@citrix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/106] xen-netfront: Fix NULL sring after live migration
Date:   Mon, 12 Dec 2022 14:10:26 +0100
Message-Id: <20221212130928.498255952@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
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

From: Lin Liu <lin.liu@citrix.com>

[ Upstream commit d50b7914fae04d840ce36491d22133070b18cca9 ]

A NAPI is setup for each network sring to poll data to kernel
The sring with source host is destroyed before live migration and
new sring with target host is setup after live migration.
The NAPI for the old sring is not deleted until setup new sring
with target host after migration. With busy_poll/busy_read enabled,
the NAPI can be polled before got deleted when resume VM.

BUG: unable to handle kernel NULL pointer dereference at
0000000000000008
IP: xennet_poll+0xae/0xd20
PGD 0 P4D 0
Oops: 0000 [#1] SMP PTI
Call Trace:
 finish_task_switch+0x71/0x230
 timerqueue_del+0x1d/0x40
 hrtimer_try_to_cancel+0xb5/0x110
 xennet_alloc_rx_buffers+0x2a0/0x2a0
 napi_busy_loop+0xdb/0x270
 sock_poll+0x87/0x90
 do_sys_poll+0x26f/0x580
 tracing_map_insert+0x1d4/0x2f0
 event_hist_trigger+0x14a/0x260

 finish_task_switch+0x71/0x230
 __schedule+0x256/0x890
 recalc_sigpending+0x1b/0x50
 xen_sched_clock+0x15/0x20
 __rb_reserve_next+0x12d/0x140
 ring_buffer_lock_reserve+0x123/0x3d0
 event_triggers_call+0x87/0xb0
 trace_event_buffer_commit+0x1c4/0x210
 xen_clocksource_get_cycles+0x15/0x20
 ktime_get_ts64+0x51/0xf0
 SyS_ppoll+0x160/0x1a0
 SyS_ppoll+0x160/0x1a0
 do_syscall_64+0x73/0x130
 entry_SYSCALL_64_after_hwframe+0x41/0xa6
...
RIP: xennet_poll+0xae/0xd20 RSP: ffffb4f041933900
CR2: 0000000000000008
---[ end trace f8601785b354351c ]---

xen frontend should remove the NAPIs for the old srings before live
migration as the bond srings are destroyed

There is a tiny window between the srings are set to NULL and
the NAPIs are disabled, It is safe as the NAPI threads are still
frozen at that time

Signed-off-by: Lin Liu <lin.liu@citrix.com>
Fixes: 4ec2411980d0 ([NET]: Do not check netif_running() and carrier state in ->poll())
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netfront.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 569f3c8e7b75..3d149890fa36 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1868,6 +1868,12 @@ static int netfront_resume(struct xenbus_device *dev)
 	netif_tx_unlock_bh(info->netdev);
 
 	xennet_disconnect_backend(info);
+
+	rtnl_lock();
+	if (info->queues)
+		xennet_destroy_queues(info);
+	rtnl_unlock();
+
 	return 0;
 }
 
-- 
2.35.1



