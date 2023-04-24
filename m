Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194706ECDB8
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbjDXN0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbjDXN0E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:26:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C3F5FC9
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:26:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DF6B622BD
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1DCC4339B;
        Mon, 24 Apr 2023 13:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342761;
        bh=ITOpzuJMqiMRRjzf8/JQoUd5iLbNslABVUFXy1iTgd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qluxeB98I2qREcvkXHQ9BL6h9EMkOtkvgyuujzcdleKkdRFA/1J9Zg3an5/B685vd
         1fT3PyYjk2bbLRSjZTvMFDhaf/btfYGA6/1PA7mF8aPbMZqg3He/KsyLU6abmaY/HD
         7TJBAXkiPDnrAEuN0tvpMUA0ooN+r9qXxjAtaix4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Donglin Peng <pengdonglin@sangfor.com.cn>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Ding Hui <dinghui@sangfor.com.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Huang Cun <huangcun@sangfor.com.cn>
Subject: [PATCH 6.1 18/98] sfc: Fix use-after-free due to selftest_work
Date:   Mon, 24 Apr 2023 15:16:41 +0200
Message-Id: <20230424131134.591899714@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ding Hui <dinghui@sangfor.com.cn>

[ Upstream commit a80bb8e7233b2ad6ff119646b6e33fb3edcec37b ]

There is a use-after-free scenario that is:

When the NIC is down, user set mac address or vlan tag to VF,
the xxx_set_vf_mac() or xxx_set_vf_vlan() will invoke efx_net_stop()
and efx_net_open(), since netif_running() is false, the port will not
start and keep port_enabled false, but selftest_work is scheduled
in efx_net_open().

If we remove the device before selftest_work run, the efx_stop_port()
will not be called since the NIC is down, and then efx is freed,
we will soon get a UAF in run_timer_softirq() like this:

[ 1178.907941] ==================================================================
[ 1178.907948] BUG: KASAN: use-after-free in run_timer_softirq+0xdea/0xe90
[ 1178.907950] Write of size 8 at addr ff11001f449cdc80 by task swapper/47/0
[ 1178.907950]
[ 1178.907953] CPU: 47 PID: 0 Comm: swapper/47 Kdump: loaded Tainted: G           O     --------- -t - 4.18.0 #1
[ 1178.907954] Hardware name: SANGFOR X620G40/WI2HG-208T1061A, BIOS SPYH051032-U01 04/01/2022
[ 1178.907955] Call Trace:
[ 1178.907956]  <IRQ>
[ 1178.907960]  dump_stack+0x71/0xab
[ 1178.907963]  print_address_description+0x6b/0x290
[ 1178.907965]  ? run_timer_softirq+0xdea/0xe90
[ 1178.907967]  kasan_report+0x14a/0x2b0
[ 1178.907968]  run_timer_softirq+0xdea/0xe90
[ 1178.907971]  ? init_timer_key+0x170/0x170
[ 1178.907973]  ? hrtimer_cancel+0x20/0x20
[ 1178.907976]  ? sched_clock+0x5/0x10
[ 1178.907978]  ? sched_clock_cpu+0x18/0x170
[ 1178.907981]  __do_softirq+0x1c8/0x5fa
[ 1178.907985]  irq_exit+0x213/0x240
[ 1178.907987]  smp_apic_timer_interrupt+0xd0/0x330
[ 1178.907989]  apic_timer_interrupt+0xf/0x20
[ 1178.907990]  </IRQ>
[ 1178.907991] RIP: 0010:mwait_idle+0xae/0x370

If the NIC is not actually brought up, there is no need to schedule
selftest_work, so let's move invoking efx_selftest_async_start()
into efx_start_all(), and it will be canceled by broughting down.

Fixes: dd40781e3a4e ("sfc: Run event/IRQ self-test asynchronously when interface is brought up")
Fixes: e340be923012 ("sfc: add ndo_set_vf_mac() function for EF10")
Debugged-by: Huang Cun <huangcun@sangfor.com.cn>
Cc: Donglin Peng <pengdonglin@sangfor.com.cn>
Suggested-by: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/efx.c        | 1 -
 drivers/net/ethernet/sfc/efx_common.c | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 6a1bff54bc6c3..e6aedd8ebd750 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -541,7 +541,6 @@ int efx_net_open(struct net_device *net_dev)
 	else
 		efx->state = STATE_NET_UP;
 
-	efx_selftest_async_start(efx);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index c2224e41a694d..ee1cabe3e2429 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -544,6 +544,8 @@ void efx_start_all(struct efx_nic *efx)
 	/* Start the hardware monitor if there is one */
 	efx_start_monitor(efx);
 
+	efx_selftest_async_start(efx);
+
 	/* Link state detection is normally event-driven; we have
 	 * to poll now because we could have missed a change
 	 */
-- 
2.39.2



