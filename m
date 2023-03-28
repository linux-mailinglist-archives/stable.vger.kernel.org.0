Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5076CC356
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbjC1OxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233374AbjC1OxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:53:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312E4CDE4
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:52:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4772B81D68
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315F9C433D2;
        Tue, 28 Mar 2023 14:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015165;
        bh=nzBpbAX6GUHoyDmkTBMF6QoSW4vYSZx7G+9QiY7sN40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zp6uGo8Sd3LRy1/rQdEY/uIeB9c+rjSUr30qNdRdMRhOY5ulDk91n7jgGxghCnq51
         3/5xRTN++B6V72XXhJwf1UzxjVCigYbJzsyzxY3TIy43F4uFQqSNoil9Mmg+NNu2Df
         LmLE0wjluiCvCthWVysueRxdabK2WpC94NxB+ijw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Corinna Vinschen <vinschen@redhat.com>,
        Lin Ma <linma@zju.edu.cn>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Simon Horman <simon.horman@corigine.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.2 189/240] igb: revert rtnl_lock() that causes deadlock
Date:   Tue, 28 Mar 2023 16:42:32 +0200
Message-Id: <20230328142627.515380987@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

commit 65f69851e44d71248b952a687e44759a7abb5016 upstream.

The commit 6faee3d4ee8b ("igb: Add lock to avoid data race") adds
rtnl_lock to eliminate a false data race shown below

 (FREE from device detaching)      |   (USE from netdev core)
igb_remove                         |  igb_ndo_get_vf_config
 igb_disable_sriov                 |  vf >= adapter->vfs_allocated_count?
  kfree(adapter->vf_data)          |
  adapter->vfs_allocated_count = 0 |
                                   |    memcpy(... adapter->vf_data[vf]

The above race will never happen and the extra rtnl_lock causes deadlock
below

[  141.420169]  <TASK>
[  141.420672]  __schedule+0x2dd/0x840
[  141.421427]  schedule+0x50/0xc0
[  141.422041]  schedule_preempt_disabled+0x11/0x20
[  141.422678]  __mutex_lock.isra.13+0x431/0x6b0
[  141.423324]  unregister_netdev+0xe/0x20
[  141.423578]  igbvf_remove+0x45/0xe0 [igbvf]
[  141.423791]  pci_device_remove+0x36/0xb0
[  141.423990]  device_release_driver_internal+0xc1/0x160
[  141.424270]  pci_stop_bus_device+0x6d/0x90
[  141.424507]  pci_stop_and_remove_bus_device+0xe/0x20
[  141.424789]  pci_iov_remove_virtfn+0xba/0x120
[  141.425452]  sriov_disable+0x2f/0xf0
[  141.425679]  igb_disable_sriov+0x4e/0x100 [igb]
[  141.426353]  igb_remove+0xa0/0x130 [igb]
[  141.426599]  pci_device_remove+0x36/0xb0
[  141.426796]  device_release_driver_internal+0xc1/0x160
[  141.427060]  driver_detach+0x44/0x90
[  141.427253]  bus_remove_driver+0x55/0xe0
[  141.427477]  pci_unregister_driver+0x2a/0xa0
[  141.428296]  __x64_sys_delete_module+0x141/0x2b0
[  141.429126]  ? mntput_no_expire+0x4a/0x240
[  141.429363]  ? syscall_trace_enter.isra.19+0x126/0x1a0
[  141.429653]  do_syscall_64+0x5b/0x80
[  141.429847]  ? exit_to_user_mode_prepare+0x14d/0x1c0
[  141.430109]  ? syscall_exit_to_user_mode+0x12/0x30
[  141.430849]  ? do_syscall_64+0x67/0x80
[  141.431083]  ? syscall_exit_to_user_mode_prepare+0x183/0x1b0
[  141.431770]  ? syscall_exit_to_user_mode+0x12/0x30
[  141.432482]  ? do_syscall_64+0x67/0x80
[  141.432714]  ? exc_page_fault+0x64/0x140
[  141.432911]  entry_SYSCALL_64_after_hwframe+0x72/0xdc

Since the igb_disable_sriov() will call pci_disable_sriov() before
releasing any resources, the netdev core will synchronize the cleanup to
avoid any races. This patch removes the useless rtnl_(un)lock to guarantee
correctness.

CC: stable@vger.kernel.org
Fixes: 6faee3d4ee8b ("igb: Add lock to avoid data race")
Reported-by: Corinna Vinschen <vinschen@redhat.com>
Link: https://lore.kernel.org/intel-wired-lan/ZAcJvkEPqWeJHO2r@calimero.vinschen.de/
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Tested-by: Corinna Vinschen <vinschen@redhat.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3841,9 +3841,7 @@ static void igb_remove(struct pci_dev *p
 	igb_release_hw_control(adapter);
 
 #ifdef CONFIG_PCI_IOV
-	rtnl_lock();
 	igb_disable_sriov(pdev);
-	rtnl_unlock();
 #endif
 
 	unregister_netdev(netdev);


