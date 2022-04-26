Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D5D50F4E1
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343686AbiDZIkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345891AbiDZIjl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:39:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8D17B138;
        Tue, 26 Apr 2022 01:32:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4095561896;
        Tue, 26 Apr 2022 08:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDD5C385A0;
        Tue, 26 Apr 2022 08:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961935;
        bh=0Gjmb8bSJi484acvjTXIK1ezXso4TeB6gDzWM3yh/h0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1nhzNVybLs6GJ6X/wWgUTswgM/Vftm07qyjOKqYfotoYk3/9aS52HqjMfqPAZvExU
         mB1uXdMjwwbZvJaSmDB3PavBAlu246sbDw+wjcO/QDx9rxvAd298tM8d68JMaYeE+c
         PoDg+ewlNJMZ0/t1GDxpoCErhBFf094xibkGA4Q0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corinna Vinschen <vinschen@redhat.com>,
        Dima Ruinskiy <dima.ruinskiy@intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 18/86] igc: Fix BUG: scheduling while atomic
Date:   Tue, 26 Apr 2022 10:20:46 +0200
Message-Id: <20220426081741.732459795@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
References: <20220426081741.202366502@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

[ Upstream commit c80a29f0fe9b6f5457e0788e27d1110577eba99b ]

Replace usleep_range() method with udelay() method to allow atomic contexts
in low-level MDIO access functions.

The following issue can be seen by doing the following:
$ modprobe -r bonding
$ modprobe -v bonding max_bonds=1 mode=1 miimon=100 use_carrier=0
$ ip link set bond0 up
$ ifenslave bond0 eth0 eth1

[  982.357308] BUG: scheduling while atomic: kworker/u64:0/9/0x00000002
[  982.364431] INFO: lockdep is turned off.
[  982.368824] Modules linked in: bonding sctp ip6_udp_tunnel udp_tunnel mlx4_ib ib_uverbs ib_core mlx4_en mlx4_core nfp tls sunrpc intel_rapl_msr iTCO_wdt iTCO_vendor_support mxm_wmi dcdbas intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel rapl intel_cstate intel_uncore pcspkr lpc_ich mei_me ipmi_ssif mei ipmi_si ipmi_devintf ipmi_msghandler wmi acpi_power_meter xfs libcrc32c sr_mod cdrom sd_mod t10_pi sg mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm ahci libahci crc32c_intel libata i2c_algo_bit tg3 megaraid_sas igc dm_mirror dm_region_hash dm_log dm_mod [last unloaded: bonding]
[  982.437941] CPU: 25 PID: 9 Comm: kworker/u64:0 Kdump: loaded Tainted: G        W        --------- -  - 4.18.0-348.el8.x86_64+debug #1
[  982.451333] Hardware name: Dell Inc. PowerEdge R730/0H21J3, BIOS 2.7.0 12/005/2017
[  982.459791] Workqueue: bond0 bond_mii_monitor [bonding]
[  982.465622] Call Trace:
[  982.468355]  dump_stack+0x8e/0xd0
[  982.472056]  __schedule_bug.cold.60+0x3a/0x60
[  982.476919]  __schedule+0x147b/0x1bc0
[  982.481007]  ? firmware_map_remove+0x16b/0x16b
[  982.485967]  ? hrtimer_fixup_init+0x40/0x40
[  982.490625]  schedule+0xd9/0x250
[  982.494227]  schedule_hrtimeout_range_clock+0x10d/0x2c0
[  982.500058]  ? hrtimer_nanosleep_restart+0x130/0x130
[  982.505598]  ? hrtimer_init_sleeper_on_stack+0x90/0x90
[  982.511332]  ? usleep_range+0x88/0x130
[  982.515514]  ? recalibrate_cpu_khz+0x10/0x10
[  982.520279]  ? ktime_get+0xab/0x1c0
[  982.524175]  ? usleep_range+0x88/0x130
[  982.528355]  usleep_range+0xdd/0x130
[  982.532344]  ? console_conditional_schedule+0x30/0x30
[  982.537987]  ? igc_put_hw_semaphore+0x17/0x60 [igc]
[  982.543432]  igc_read_phy_reg_gpy+0x111/0x2b0 [igc]
[  982.548887]  igc_phy_has_link+0xfa/0x260 [igc]
[  982.553847]  ? igc_get_phy_id+0x210/0x210 [igc]
[  982.558894]  ? lock_acquire+0x34d/0x890
[  982.563187]  ? lock_downgrade+0x710/0x710
[  982.567659]  ? rcu_read_unlock+0x50/0x50
[  982.572039]  igc_check_for_copper_link+0x106/0x210 [igc]
[  982.577970]  ? igc_config_fc_after_link_up+0x840/0x840 [igc]
[  982.584286]  ? rcu_read_unlock+0x50/0x50
[  982.588661]  ? lock_release+0x591/0xb80
[  982.592939]  ? lock_release+0x591/0xb80
[  982.597220]  igc_has_link+0x113/0x330 [igc]
[  982.601887]  ? lock_downgrade+0x710/0x710
[  982.606362]  igc_ethtool_get_link+0x6d/0x90 [igc]
[  982.611614]  bond_check_dev_link+0x131/0x2c0 [bonding]
[  982.617350]  ? bond_time_in_interval+0xd0/0xd0 [bonding]
[  982.623277]  ? rcu_read_lock_held+0x62/0xc0
[  982.627944]  ? rcu_read_lock_sched_held+0xe0/0xe0
[  982.633198]  bond_mii_monitor+0x314/0x2500 [bonding]
[  982.638738]  ? lock_contended+0x880/0x880
[  982.643214]  ? bond_miimon_link_change+0xa0/0xa0 [bonding]
[  982.649336]  ? lock_acquire+0x34d/0x890
[  982.653615]  ? lock_downgrade+0x710/0x710
[  982.658089]  ? debug_object_deactivate+0x221/0x340
[  982.663436]  ? rcu_read_unlock+0x50/0x50
[  982.667811]  ? debug_print_object+0x2b0/0x2b0
[  982.672672]  ? __switch_to_asm+0x41/0x70
[  982.677049]  ? __switch_to_asm+0x35/0x70
[  982.681426]  ? _raw_spin_unlock_irq+0x24/0x40
[  982.686288]  ? trace_hardirqs_on+0x20/0x195
[  982.690956]  ? _raw_spin_unlock_irq+0x24/0x40
[  982.695818]  process_one_work+0x8f0/0x1770
[  982.700390]  ? pwq_dec_nr_in_flight+0x320/0x320
[  982.705443]  ? debug_show_held_locks+0x50/0x50
[  982.710403]  worker_thread+0x87/0xb40
[  982.714489]  ? process_one_work+0x1770/0x1770
[  982.719349]  kthread+0x344/0x410
[  982.722950]  ? kthread_insert_work_sanity_check+0xd0/0xd0
[  982.728975]  ret_from_fork+0x3a/0x50

Fixes: 5586838fe9ce ("igc: Add code for PHY support")
Reported-by: Corinna Vinschen <vinschen@redhat.com>
Suggested-by: Dima Ruinskiy <dima.ruinskiy@intel.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Corinna Vinschen <vinschen@redhat.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_phy.c b/drivers/net/ethernet/intel/igc/igc_phy.c
index e380b7a3ea63..8de4de2e5636 100644
--- a/drivers/net/ethernet/intel/igc/igc_phy.c
+++ b/drivers/net/ethernet/intel/igc/igc_phy.c
@@ -583,7 +583,7 @@ static s32 igc_read_phy_reg_mdic(struct igc_hw *hw, u32 offset, u16 *data)
 	 * the lower time out
 	 */
 	for (i = 0; i < IGC_GEN_POLL_TIMEOUT; i++) {
-		usleep_range(500, 1000);
+		udelay(50);
 		mdic = rd32(IGC_MDIC);
 		if (mdic & IGC_MDIC_READY)
 			break;
@@ -640,7 +640,7 @@ static s32 igc_write_phy_reg_mdic(struct igc_hw *hw, u32 offset, u16 data)
 	 * the lower time out
 	 */
 	for (i = 0; i < IGC_GEN_POLL_TIMEOUT; i++) {
-		usleep_range(500, 1000);
+		udelay(50);
 		mdic = rd32(IGC_MDIC);
 		if (mdic & IGC_MDIC_READY)
 			break;
-- 
2.35.1



