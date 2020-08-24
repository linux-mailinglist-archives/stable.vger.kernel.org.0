Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0EB324F479
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbgHXIhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:37:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728361AbgHXIhA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:37:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98A94207DF;
        Mon, 24 Aug 2020 08:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258220;
        bh=woyqq0iGieHRlS+G0TycRP69+XZ2LrEamldPHGlnPIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQuirNXFDqn4O9kr5KobEFre5Ac11shE+Y0jCA4wfgR+a8DzfCwM4HTlGy6HmucYA
         uyuFT+DS3/nITv/f/Jib17Bl38vFeogv+hbmvGeNgIG3VJqeo2EXlGb3CxuMx7a0PS
         uRGJctpCZETSUhd8kRgC6j+1gdFLB9UKAzCE3ZlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 089/148] i40e: Fix crash during removing i40e driver
Date:   Mon, 24 Aug 2020 10:29:47 +0200
Message-Id: <20200824082418.308843744@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>

[ Upstream commit 5b6d4a7f20b09c47ca598760f6dafd554af8b6d5 ]

Fix the reason of crashing system by add waiting time to finish reset
recovery process before starting remove driver procedure.
Now VSI is releasing if VSI is not in reset recovery mode.
Without this fix it was possible to start remove driver if other
processing command need reset recovery procedure which resulted in
null pointer dereference. VSI used by the ethtool process has been
cleared by remove driver process.

[ 6731.508665] BUG: kernel NULL pointer dereference, address: 0000000000000000
[ 6731.508668] #PF: supervisor read access in kernel mode
[ 6731.508670] #PF: error_code(0x0000) - not-present page
[ 6731.508671] PGD 0 P4D 0
[ 6731.508674] Oops: 0000 [#1] SMP PTI
[ 6731.508679] Hardware name: Intel Corporation S2600WT2R/S2600WT2R, BIOS SE5C610.86B.01.01.0021.032120170601 03/21/2017
[ 6731.508694] RIP: 0010:i40e_down+0x252/0x310 [i40e]
[ 6731.508696] Code: c7 78 de fa c0 e8 61 02 3a c1 66 83 bb f6 0c 00 00 00 0f 84 bf 00 00 00 45 31 e4 45 31 ff eb 03 41 89 c7 48 8b 83 98 0c 00 00 <4a> 8b 3c 20 e8 a5 79 02 00 48 83 bb d0 0c 00 00 00 74 10 48 8b 83
[ 6731.508698] RSP: 0018:ffffb75ac7b3faf0 EFLAGS: 00010246
[ 6731.508700] RAX: 0000000000000000 RBX: ffff9c9874bd5000 RCX: 0000000000000007
[ 6731.508701] RDX: 0000000000000000 RSI: 0000000000000096 RDI: ffff9c987f4d9780
[ 6731.508703] RBP: ffffb75ac7b3fb30 R08: 0000000000005b60 R09: 0000000000000004
[ 6731.508704] R10: ffffb75ac64fbd90 R11: 0000000000000001 R12: 0000000000000000
[ 6731.508706] R13: ffff9c97a08e0000 R14: ffff9c97a08e0a68 R15: 0000000000000000
[ 6731.508708] FS:  00007f2617cd2740(0000) GS:ffff9c987f4c0000(0000) knlGS:0000000000000000
[ 6731.508710] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6731.508711] CR2: 0000000000000000 CR3: 0000001e765c4006 CR4: 00000000003606e0
[ 6731.508713] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6731.508714] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 6731.508715] Call Trace:
[ 6731.508734]  i40e_vsi_close+0x84/0x90 [i40e]
[ 6731.508742]  i40e_quiesce_vsi.part.98+0x3c/0x40 [i40e]
[ 6731.508749]  i40e_pf_quiesce_all_vsi+0x55/0x60 [i40e]
[ 6731.508757]  i40e_prep_for_reset+0x59/0x130 [i40e]
[ 6731.508765]  i40e_reconfig_rss_queues+0x5a/0x120 [i40e]
[ 6731.508774]  i40e_set_channels+0xda/0x170 [i40e]
[ 6731.508778]  ethtool_set_channels+0xe9/0x150
[ 6731.508781]  dev_ethtool+0x1b94/0x2920
[ 6731.508805]  dev_ioctl+0xc2/0x590
[ 6731.508811]  sock_do_ioctl+0xae/0x150
[ 6731.508813]  sock_ioctl+0x34f/0x3c0
[ 6731.508821]  ksys_ioctl+0x98/0xb0
[ 6731.508828]  __x64_sys_ioctl+0x1a/0x20
[ 6731.508831]  do_syscall_64+0x57/0x1c0
[ 6731.508835]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 4b8164467b85 ("i40e: Add common function for finding VSI by type")
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 56ecd6c3f2362..6af6367e7cac2 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -15352,6 +15352,9 @@ static void i40e_remove(struct pci_dev *pdev)
 	i40e_write_rx_ctl(hw, I40E_PFQF_HENA(0), 0);
 	i40e_write_rx_ctl(hw, I40E_PFQF_HENA(1), 0);
 
+	while (test_bit(__I40E_RESET_RECOVERY_PENDING, pf->state))
+		usleep_range(1000, 2000);
+
 	/* no more scheduling of any task */
 	set_bit(__I40E_SUSPENDED, pf->state);
 	set_bit(__I40E_DOWN, pf->state);
-- 
2.25.1



