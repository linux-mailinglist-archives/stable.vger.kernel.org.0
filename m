Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28676CC4CB
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbjC1PIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjC1PIo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:08:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B4CEC4E
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:07:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4311E61867
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C8BC433D2;
        Tue, 28 Mar 2023 15:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016038;
        bh=6Nqa+qwPwxkgF8UeBErng6+VQx2MC5FGAbfYfb1BuNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aw0jV3YjHBqn75iOlfU2bvyc7/7zVBjEWwGY3ic7T0Q+kvJN5v27CN1ui2DtkMZkd
         79M1fg/mkGsZF7mx/eYW2hLc/gM4N7vNIUNat0K33BEsND6qHoBs7ZffBVVpgMXkGm
         zvfdlLM8NbxRBR3TpqLSDf+f42lD1lAL7tkJetDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marius Cornea <mcornea@redhat.com>,
        Stefan Assmann <sassmann@kpanic.de>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/146] iavf: fix hang on reboot with ice
Date:   Tue, 28 Mar 2023 16:42:12 +0200
Message-Id: <20230328142604.513721146@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
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

From: Stefan Assmann <sassmann@kpanic.de>

[ Upstream commit 4e264be98b88a6d6f476c11087fe865696e8bef5 ]

When a system with E810 with existing VFs gets rebooted the following
hang may be observed.

 Pid 1 is hung in iavf_remove(), part of a network driver:
 PID: 1        TASK: ffff965400e5a340  CPU: 24   COMMAND: "systemd-shutdow"
  #0 [ffffaad04005fa50] __schedule at ffffffff8b3239cb
  #1 [ffffaad04005fae8] schedule at ffffffff8b323e2d
  #2 [ffffaad04005fb00] schedule_hrtimeout_range_clock at ffffffff8b32cebc
  #3 [ffffaad04005fb80] usleep_range_state at ffffffff8b32c930
  #4 [ffffaad04005fbb0] iavf_remove at ffffffffc12b9b4c [iavf]
  #5 [ffffaad04005fbf0] pci_device_remove at ffffffff8add7513
  #6 [ffffaad04005fc10] device_release_driver_internal at ffffffff8af08baa
  #7 [ffffaad04005fc40] pci_stop_bus_device at ffffffff8adcc5fc
  #8 [ffffaad04005fc60] pci_stop_and_remove_bus_device at ffffffff8adcc81e
  #9 [ffffaad04005fc70] pci_iov_remove_virtfn at ffffffff8adf9429
 #10 [ffffaad04005fca8] sriov_disable at ffffffff8adf98e4
 #11 [ffffaad04005fcc8] ice_free_vfs at ffffffffc04bb2c8 [ice]
 #12 [ffffaad04005fd10] ice_remove at ffffffffc04778fe [ice]
 #13 [ffffaad04005fd38] ice_shutdown at ffffffffc0477946 [ice]
 #14 [ffffaad04005fd50] pci_device_shutdown at ffffffff8add58f1
 #15 [ffffaad04005fd70] device_shutdown at ffffffff8af05386
 #16 [ffffaad04005fd98] kernel_restart at ffffffff8a92a870
 #17 [ffffaad04005fda8] __do_sys_reboot at ffffffff8a92abd6
 #18 [ffffaad04005fee0] do_syscall_64 at ffffffff8b317159
 #19 [ffffaad04005ff08] __context_tracking_enter at ffffffff8b31b6fc
 #20 [ffffaad04005ff18] syscall_exit_to_user_mode at ffffffff8b31b50d
 #21 [ffffaad04005ff28] do_syscall_64 at ffffffff8b317169
 #22 [ffffaad04005ff50] entry_SYSCALL_64_after_hwframe at ffffffff8b40009b
     RIP: 00007f1baa5c13d7  RSP: 00007fffbcc55a98  RFLAGS: 00000202
     RAX: ffffffffffffffda  RBX: 0000000000000000  RCX: 00007f1baa5c13d7
     RDX: 0000000001234567  RSI: 0000000028121969  RDI: 00000000fee1dead
     RBP: 00007fffbcc55ca0   R8: 0000000000000000   R9: 00007fffbcc54e90
     R10: 00007fffbcc55050  R11: 0000000000000202  R12: 0000000000000005
     R13: 0000000000000000  R14: 00007fffbcc55af0  R15: 0000000000000000
     ORIG_RAX: 00000000000000a9  CS: 0033  SS: 002b

During reboot all drivers PM shutdown callbacks are invoked.
In iavf_shutdown() the adapter state is changed to __IAVF_REMOVE.
In ice_shutdown() the call chain above is executed, which at some point
calls iavf_remove(). However iavf_remove() expects the VF to be in one
of the states __IAVF_RUNNING, __IAVF_DOWN or __IAVF_INIT_FAILED. If
that's not the case it sleeps forever.
So if iavf_shutdown() gets invoked before iavf_remove() the system will
hang indefinitely because the adapter is already in state __IAVF_REMOVE.

Fix this by returning from iavf_remove() if the state is __IAVF_REMOVE,
as we already went through iavf_shutdown().

Fixes: 974578017fc1 ("iavf: Add waiting so the port is initialized in remove")
Fixes: a8417330f8a5 ("iavf: Fix race condition between iavf_shutdown and iavf_remove")
Reported-by: Marius Cornea <mcornea@redhat.com>
Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 82c4f1190e41c..f5e6ae2c683f4 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4213,6 +4213,11 @@ static void iavf_remove(struct pci_dev *pdev)
 			mutex_unlock(&adapter->crit_lock);
 			break;
 		}
+		/* Simply return if we already went through iavf_shutdown */
+		if (adapter->state == __IAVF_REMOVE) {
+			mutex_unlock(&adapter->crit_lock);
+			return;
+		}
 
 		mutex_unlock(&adapter->crit_lock);
 		usleep_range(500, 1000);
-- 
2.39.2



