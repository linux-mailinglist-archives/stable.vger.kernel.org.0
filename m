Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22C654E2958
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348807AbiCUODx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349257AbiCUODe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:03:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393FE17A5B6;
        Mon, 21 Mar 2022 07:00:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A3C1611D5;
        Mon, 21 Mar 2022 14:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0CDC340E8;
        Mon, 21 Mar 2022 14:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871242;
        bh=id3rTSXc9qVDduvaUhiySlvx9cuHzqqhqRBvxy7JmoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bv7hxqn35PbnkQN2lO+LK0oi1LwYwznxTJQ8Zlewd5TwzxQExyL1Gh5KKC1jHNw8w
         qE7tezwuFssrrzUJPzs/IrMNmqMI6PV8fDMCr0j/tTY8sQnr6RyqxrWSoWND6M6Wqt
         jqSDuId+JcbRA1/8zZlKGuQ+nHoVZ/yyWnG+ZAPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ivan Vecera <ivecera@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 24/32] iavf: Fix hang during reboot/shutdown
Date:   Mon, 21 Mar 2022 14:53:00 +0100
Message-Id: <20220321133221.262713778@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133220.559554263@linuxfoundation.org>
References: <20220321133220.559554263@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit b04683ff8f0823b869c219c78ba0d974bddea0b5 ]

Recent commit 974578017fc1 ("iavf: Add waiting so the port is
initialized in remove") adds a wait-loop at the beginning of
iavf_remove() to ensure that port initialization is finished
prior unregistering net device. This causes a regression
in reboot/shutdown scenario because in this case callback
iavf_shutdown() is called and this callback detaches the device,
makes it down if it is running and sets its state to __IAVF_REMOVE.
Later shutdown callback of associated PF driver (e.g. ice_shutdown)
is called. That callback calls among other things sriov_disable()
that calls indirectly iavf_remove() (see stack trace below).
As the adapter state is already __IAVF_REMOVE then the mentioned
loop is end-less and shutdown process hangs.

The patch fixes this by checking adapter's state at the beginning
of iavf_remove() and skips the rest of the function if the adapter
is already in remove state (shutdown is in progress).

Reproducer:
1. Create VF on PF driven by ice or i40e driver
2. Ensure that the VF is bound to iavf driver
3. Reboot

[52625.981294] sysrq: SysRq : Show Blocked State
[52625.988377] task:reboot          state:D stack:    0 pid:17359 ppid:     1 f2
[52625.996732] Call Trace:
[52625.999187]  __schedule+0x2d1/0x830
[52626.007400]  schedule+0x35/0xa0
[52626.010545]  schedule_hrtimeout_range_clock+0x83/0x100
[52626.020046]  usleep_range+0x5b/0x80
[52626.023540]  iavf_remove+0x63/0x5b0 [iavf]
[52626.027645]  pci_device_remove+0x3b/0xc0
[52626.031572]  device_release_driver_internal+0x103/0x1f0
[52626.036805]  pci_stop_bus_device+0x72/0xa0
[52626.040904]  pci_stop_and_remove_bus_device+0xe/0x20
[52626.045870]  pci_iov_remove_virtfn+0xba/0x120
[52626.050232]  sriov_disable+0x2f/0xe0
[52626.053813]  ice_free_vfs+0x7c/0x340 [ice]
[52626.057946]  ice_remove+0x220/0x240 [ice]
[52626.061967]  ice_shutdown+0x16/0x50 [ice]
[52626.065987]  pci_device_shutdown+0x34/0x60
[52626.070086]  device_shutdown+0x165/0x1c5
[52626.074011]  kernel_restart+0xe/0x30
[52626.077593]  __do_sys_reboot+0x1d2/0x210
[52626.093815]  do_syscall_64+0x5b/0x1a0
[52626.097483]  entry_SYSCALL_64_after_hwframe+0x65/0xca

Fixes: 974578017fc1 ("iavf: Add waiting so the port is initialized in remove")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Link: https://lore.kernel.org/r/20220317104524.2802848-1-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 7fca9dd8dcf6..ca74824d40b8 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4025,6 +4025,13 @@ static void iavf_remove(struct pci_dev *pdev)
 	struct iavf_hw *hw = &adapter->hw;
 	int err;
 
+	/* When reboot/shutdown is in progress no need to do anything
+	 * as the adapter is already REMOVE state that was set during
+	 * iavf_shutdown() callback.
+	 */
+	if (adapter->state == __IAVF_REMOVE)
+		return;
+
 	set_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section);
 	/* Wait until port initialization is complete.
 	 * There are flows where register/unregister netdev may race.
-- 
2.34.1



