Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 886F859DA06
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352100AbiHWKEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352685AbiHWKCT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:02:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569967C516;
        Tue, 23 Aug 2022 01:50:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5ADBB81BF8;
        Tue, 23 Aug 2022 08:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90282C433C1;
        Tue, 23 Aug 2022 08:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244626;
        bh=G89TDtQh7UXJyXT3f5OHANk4yt9nqIIbINhFV0sK1mA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGRl63L9h/7MEJpg2GWbuoB0mpVgHRiL+mBROiuEqKQ2CWFlWuKGl0CSARcZyjSFs
         14Ym7YTZuJW5kdDUWo2ecQY12LMLhE675xxPIIN+Mneal8ZUe0cr/MBjpwvxrS/rAG
         OP7lsxMfPAbK0qOhEvyBZ0l9Nmg84wdoU3edtVy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.15 116/244] iavf: Fix reset error handling
Date:   Tue, 23 Aug 2022 10:24:35 +0200
Message-Id: <20220823080102.894362117@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,WEIRD_PORT autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

commit 31071173771e079f7bc08dacd61e0db913262fbf upstream.

Do not call iavf_close in iavf_reset_task error handling. Doing so can
lead to double call of napi_disable, which can lead to deadlock there.
Removing VF would lead to iavf_remove task being stuck, because it
requires crit_lock, which is held by iavf_close.
Call iavf_disable_vf if reset fail, so that driver will clean up
remaining invalid resources.
During rapid VF resets, HW can fail to setup VF mailbox. Wrong
error handling can lead to iavf_remove being stuck with:
[ 5218.999087] iavf 0000:82:01.0: Failed to init adminq: -53
...
[ 5267.189211] INFO: task repro.sh:11219 blocked for more than 30 seconds.
[ 5267.189520]       Tainted: G S          E     5.18.0-04958-ga54ce3703613-dirty #1
[ 5267.189764] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5267.190062] task:repro.sh        state:D stack:    0 pid:11219 ppid:  8162 flags:0x00000000
[ 5267.190347] Call Trace:
[ 5267.190647]  <TASK>
[ 5267.190927]  __schedule+0x460/0x9f0
[ 5267.191264]  schedule+0x44/0xb0
[ 5267.191563]  schedule_preempt_disabled+0x14/0x20
[ 5267.191890]  __mutex_lock.isra.12+0x6e3/0xac0
[ 5267.192237]  ? iavf_remove+0xf9/0x6c0 [iavf]
[ 5267.192565]  iavf_remove+0x12a/0x6c0 [iavf]
[ 5267.192911]  ? _raw_spin_unlock_irqrestore+0x1e/0x40
[ 5267.193285]  pci_device_remove+0x36/0xb0
[ 5267.193619]  device_release_driver_internal+0xc1/0x150
[ 5267.193974]  pci_stop_bus_device+0x69/0x90
[ 5267.194361]  pci_stop_and_remove_bus_device+0xe/0x20
[ 5267.194735]  pci_iov_remove_virtfn+0xba/0x120
[ 5267.195130]  sriov_disable+0x2f/0xe0
[ 5267.195506]  ice_free_vfs+0x7d/0x2f0 [ice]
[ 5267.196056]  ? pci_get_device+0x4f/0x70
[ 5267.196496]  ice_sriov_configure+0x78/0x1a0 [ice]
[ 5267.196995]  sriov_numvfs_store+0xfe/0x140
[ 5267.197466]  kernfs_fop_write_iter+0x12e/0x1c0
[ 5267.197918]  new_sync_write+0x10c/0x190
[ 5267.198404]  vfs_write+0x24e/0x2d0
[ 5267.198886]  ksys_write+0x5c/0xd0
[ 5267.199367]  do_syscall_64+0x3a/0x80
[ 5267.199827]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[ 5267.200317] RIP: 0033:0x7f5b381205c8
[ 5267.200814] RSP: 002b:00007fff8c7e8c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[ 5267.201981] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f5b381205c8
[ 5267.202620] RDX: 0000000000000002 RSI: 00005569420ee900 RDI: 0000000000000001
[ 5267.203426] RBP: 00005569420ee900 R08: 000000000000000a R09: 00007f5b38180820
[ 5267.204327] R10: 000000000000000a R11: 0000000000000246 R12: 00007f5b383c06e0
[ 5267.205193] R13: 0000000000000002 R14: 00007f5b383bb880 R15: 0000000000000002
[ 5267.206041]  </TASK>
[ 5267.206970] Kernel panic - not syncing: hung_task: blocked tasks
[ 5267.207809] CPU: 48 PID: 551 Comm: khungtaskd Kdump: loaded Tainted: G S          E     5.18.0-04958-ga54ce3703613-dirty #1
[ 5267.208726] Hardware name: Dell Inc. PowerEdge R730/0WCJNT, BIOS 2.11.0 11/02/2019
[ 5267.209623] Call Trace:
[ 5267.210569]  <TASK>
[ 5267.211480]  dump_stack_lvl+0x33/0x42
[ 5267.212472]  panic+0x107/0x294
[ 5267.213467]  watchdog.cold.8+0xc/0xbb
[ 5267.214413]  ? proc_dohung_task_timeout_secs+0x30/0x30
[ 5267.215511]  kthread+0xf4/0x120
[ 5267.216459]  ? kthread_complete_and_exit+0x20/0x20
[ 5267.217505]  ret_from_fork+0x22/0x30
[ 5267.218459]  </TASK>

Fixes: f0db78928783 ("i40evf: use netdev variable in reset task")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2414,12 +2414,15 @@ continue_reset:
 
 	return;
 reset_err:
+	if (running) {
+		set_bit(__IAVF_VSI_DOWN, adapter->vsi.state);
+		iavf_free_traffic_irqs(adapter);
+	}
+	iavf_disable_vf(adapter);
+
 	mutex_unlock(&adapter->client_lock);
 	mutex_unlock(&adapter->crit_lock);
-	if (running)
-		iavf_change_state(adapter, __IAVF_RUNNING);
 	dev_err(&adapter->pdev->dev, "failed to allocate resources during reinit\n");
-	iavf_close(netdev);
 }
 
 /**


