Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D60AF5EA495
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238652AbiIZLrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238654AbiIZLqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:46:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B468974CDC;
        Mon, 26 Sep 2022 03:47:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9AE960C41;
        Mon, 26 Sep 2022 10:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD373C433D6;
        Mon, 26 Sep 2022 10:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189153;
        bh=AxCMt/ANClaQoCG6b0NU/yzunWIxmxLfOMnEhAJ6OZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xr/t66AJ67pzv/x6g8V7zo5PNQ6CZV2/0r3CyJtmS9XFkKsU7oQjbQoi2EML4oi3J
         rrJ0gCavXvgxHzUmCxKVE0UJlCnOxicUVAx2fZd9cIAT0oiHBghAJSwNi9Y9lkmg/3
         16FBtKOGpU2cqLrn3nJq7QBXrjA46D8zdoNoFKfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Ertman <david.m.ertman@intel.com>,
        Helena Anna Dubel <helena.anna.dubel@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 090/207] ice: Dont double unplug aux on peer initiated reset
Date:   Mon, 26 Sep 2022 12:11:19 +0200
Message-Id: <20220926100810.617881253@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

[ Upstream commit 23c619190318376769ad7b61504c2ea0703fb783 ]

In the IDC callback that is accessed when the aux drivers request a reset,
the function to unplug the aux devices is called.  This function is also
called in the ice_prepare_for_reset function. This double call is causing
a "scheduling while atomic" BUG.

[  662.676430] ice 0000:4c:00.0 rocep76s0: cqp opcode = 0x1 maj_err_code = 0xffff min_err_code = 0x8003

[  662.676609] ice 0000:4c:00.0 rocep76s0: [Modify QP Cmd Error][op_code=8] status=-29 waiting=1 completion_err=1 maj=0xffff min=0x8003

[  662.815006] ice 0000:4c:00.0 rocep76s0: ICE OICR event notification: oicr = 0x10000003

[  662.815014] ice 0000:4c:00.0 rocep76s0: critical PE Error, GLPE_CRITERR=0x00011424

[  662.815017] ice 0000:4c:00.0 rocep76s0: Requesting a reset

[  662.815475] BUG: scheduling while atomic: swapper/37/0/0x00010002

[  662.815475] BUG: scheduling while atomic: swapper/37/0/0x00010002
[  662.815477] Modules linked in: rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache netfs rfkill 8021q garp mrp stp llc vfat fat rpcrdma intel_rapl_msr intel_rapl_common sunrpc i10nm_edac rdma_ucm nfit ib_srpt libnvdimm ib_isert iscsi_target_mod x86_pkg_temp_thermal intel_powerclamp coretemp target_core_mod snd_hda_intel ib_iser snd_intel_dspcfg libiscsi snd_intel_sdw_acpi scsi_transport_iscsi kvm_intel iTCO_wdt rdma_cm snd_hda_codec kvm iw_cm ipmi_ssif iTCO_vendor_support snd_hda_core irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel snd_hwdep snd_seq snd_seq_device rapl snd_pcm snd_timer isst_if_mbox_pci pcspkr isst_if_mmio irdma intel_uncore idxd acpi_ipmi joydev isst_if_common snd mei_me idxd_bus ipmi_si soundcore i2c_i801 mei ipmi_devintf i2c_smbus i2c_ismt ipmi_msghandler acpi_power_meter acpi_pad rv(OE) ib_uverbs ib_cm ib_core xfs libcrc32c ast i2c_algo_bit drm_vram_helper drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm_ttm_helpe
 r ttm
[  662.815546]  nvme nvme_core ice drm crc32c_intel i40e t10_pi wmi pinctrl_emmitsburg dm_mirror dm_region_hash dm_log dm_mod fuse
[  662.815557] Preemption disabled at:
[  662.815558] [<0000000000000000>] 0x0
[  662.815563] CPU: 37 PID: 0 Comm: swapper/37 Kdump: loaded Tainted: G S         OE     5.17.1 #2
[  662.815566] Hardware name: Intel Corporation D50DNP/D50DNP, BIOS SE5C6301.86B.6624.D18.2111021741 11/02/2021
[  662.815568] Call Trace:
[  662.815572]  <IRQ>
[  662.815574]  dump_stack_lvl+0x33/0x42
[  662.815581]  __schedule_bug.cold.147+0x7d/0x8a
[  662.815588]  __schedule+0x798/0x990
[  662.815595]  schedule+0x44/0xc0
[  662.815597]  schedule_preempt_disabled+0x14/0x20
[  662.815600]  __mutex_lock.isra.11+0x46c/0x490
[  662.815603]  ? __ibdev_printk+0x76/0xc0 [ib_core]
[  662.815633]  device_del+0x37/0x3d0
[  662.815639]  ice_unplug_aux_dev+0x1a/0x40 [ice]
[  662.815674]  ice_schedule_reset+0x3c/0xd0 [ice]
[  662.815693]  irdma_iidc_event_handler.cold.7+0xb6/0xd3 [irdma]
[  662.815712]  ? bitmap_find_next_zero_area_off+0x45/0xa0
[  662.815719]  ice_send_event_to_aux+0x54/0x70 [ice]
[  662.815741]  ice_misc_intr+0x21d/0x2d0 [ice]
[  662.815756]  __handle_irq_event_percpu+0x4c/0x180
[  662.815762]  handle_irq_event_percpu+0xf/0x40
[  662.815764]  handle_irq_event+0x34/0x60
[  662.815766]  handle_edge_irq+0x9a/0x1c0
[  662.815770]  __common_interrupt+0x62/0x100
[  662.815774]  common_interrupt+0xb4/0xd0
[  662.815779]  </IRQ>
[  662.815780]  <TASK>
[  662.815780]  asm_common_interrupt+0x1e/0x40
[  662.815785] RIP: 0010:cpuidle_enter_state+0xd6/0x380
[  662.815789] Code: 49 89 c4 0f 1f 44 00 00 31 ff e8 65 d7 95 ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 64 02 00 00 31 ff e8 ae c5 9c ff fb 45 85 f6 <0f> 88 12 01 00 00 49 63 d6 4c 2b 24 24 48 8d 04 52 48 8d 04 82 49
[  662.815791] RSP: 0018:ff2c2c4f18edbe80 EFLAGS: 00000202
[  662.815793] RAX: ff280805df140000 RBX: 0000000000000002 RCX: 000000000000001f
[  662.815795] RDX: 0000009a52da2d08 RSI: ffffffff93f8240b RDI: ffffffff93f53ee7
[  662.815796] RBP: ff5e2bd11ff41928 R08: 0000000000000000 R09: 000000000002f8c0
[  662.815797] R10: 0000010c3f18e2cf R11: 000000000000000f R12: 0000009a52da2d08
[  662.815798] R13: ffffffff94ad7e20 R14: 0000000000000002 R15: 0000000000000000
[  662.815801]  cpuidle_enter+0x29/0x40
[  662.815803]  do_idle+0x261/0x2b0
[  662.815807]  cpu_startup_entry+0x19/0x20
[  662.815809]  start_secondary+0x114/0x150
[  662.815813]  secondary_startup_64_no_verify+0xd5/0xdb
[  662.815818]  </TASK>
[  662.815846] bad: scheduling from the idle thread!
[  662.815849] CPU: 37 PID: 0 Comm: swapper/37 Kdump: loaded Tainted: G S      W  OE     5.17.1 #2
[  662.815852] Hardware name: Intel Corporation D50DNP/D50DNP, BIOS SE5C6301.86B.6624.D18.2111021741 11/02/2021
[  662.815853] Call Trace:
[  662.815855]  <IRQ>
[  662.815856]  dump_stack_lvl+0x33/0x42
[  662.815860]  dequeue_task_idle+0x20/0x30
[  662.815863]  __schedule+0x1c3/0x990
[  662.815868]  schedule+0x44/0xc0
[  662.815871]  schedule_preempt_disabled+0x14/0x20
[  662.815873]  __mutex_lock.isra.11+0x3a8/0x490
[  662.815876]  ? __ibdev_printk+0x76/0xc0 [ib_core]
[  662.815904]  device_del+0x37/0x3d0
[  662.815909]  ice_unplug_aux_dev+0x1a/0x40 [ice]
[  662.815937]  ice_schedule_reset+0x3c/0xd0 [ice]
[  662.815961]  irdma_iidc_event_handler.cold.7+0xb6/0xd3 [irdma]
[  662.815979]  ? bitmap_find_next_zero_area_off+0x45/0xa0
[  662.815985]  ice_send_event_to_aux+0x54/0x70 [ice]
[  662.816011]  ice_misc_intr+0x21d/0x2d0 [ice]
[  662.816033]  __handle_irq_event_percpu+0x4c/0x180
[  662.816037]  handle_irq_event_percpu+0xf/0x40
[  662.816039]  handle_irq_event+0x34/0x60
[  662.816042]  handle_edge_irq+0x9a/0x1c0
[  662.816045]  __common_interrupt+0x62/0x100
[  662.816048]  common_interrupt+0xb4/0xd0
[  662.816052]  </IRQ>
[  662.816053]  <TASK>
[  662.816054]  asm_common_interrupt+0x1e/0x40
[  662.816057] RIP: 0010:cpuidle_enter_state+0xd6/0x380
[  662.816060] Code: 49 89 c4 0f 1f 44 00 00 31 ff e8 65 d7 95 ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 64 02 00 00 31 ff e8 ae c5 9c ff fb 45 85 f6 <0f> 88 12 01 00 00 49 63 d6 4c 2b 24 24 48 8d 04 52 48 8d 04 82 49
[  662.816063] RSP: 0018:ff2c2c4f18edbe80 EFLAGS: 00000202
[  662.816065] RAX: ff280805df140000 RBX: 0000000000000002 RCX: 000000000000001f
[  662.816067] RDX: 0000009a52da2d08 RSI: ffffffff93f8240b RDI: ffffffff93f53ee7
[  662.816068] RBP: ff5e2bd11ff41928 R08: 0000000000000000 R09: 000000000002f8c0
[  662.816070] R10: 0000010c3f18e2cf R11: 000000000000000f R12: 0000009a52da2d08
[  662.816071] R13: ffffffff94ad7e20 R14: 0000000000000002 R15: 0000000000000000
[  662.816075]  cpuidle_enter+0x29/0x40
[  662.816077]  do_idle+0x261/0x2b0
[  662.816080]  cpu_startup_entry+0x19/0x20
[  662.816083]  start_secondary+0x114/0x150
[  662.816087]  secondary_startup_64_no_verify+0xd5/0xdb
[  662.816091]  </TASK>
[  662.816169] bad: scheduling from the idle thread!

The correct place to unplug the aux devices for a reset is in the
prepare_for_reset function, as this is a common place for all reset flows.
It also has built in protection from being called twice in a single reset
instance before the aux devices are replugged.

Fixes: f9f5301e7e2d4 ("ice: Register auxiliary device to provide RDMA")
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Helena Anna Dubel <helena.anna.dubel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 4c6bb7482b36..0b567e8e3674 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2399,8 +2399,6 @@ int ice_schedule_reset(struct ice_pf *pf, enum ice_reset_req reset)
 		return -EBUSY;
 	}
 
-	ice_unplug_aux_dev(pf);
-
 	switch (reset) {
 	case ICE_RESET_PFR:
 		set_bit(ICE_PFR_REQ, pf->state);
-- 
2.35.1



