Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93DEF46273D
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbhK2XBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237154AbhK2XAr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:00:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E38CC0800FE;
        Mon, 29 Nov 2021 10:39:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AA55ECE13D8;
        Mon, 29 Nov 2021 18:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F9FC53FAD;
        Mon, 29 Nov 2021 18:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211156;
        bh=sNOh8vmMVzAlq9OU5N2DoMQXhzhUKdTW+IYU4lr4Ru8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qvJYwG33w9LPj4x7kl5rU5/2yJ5AG9+5CMHR3dOtVbW69rUXTb+10JDy/tLUe1tHb
         kB7od+NOBd5KfmCRyeC1BWcYcrHmG5/owhpFCm5hlxKfPnyJPgQ7OToThHcukFsz5W
         NcTbwk+7MRI6hf3Vze7dnHtnovKVRZfAtrZV45es=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Marta Plantykow <marta.a.plantykow@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Kiran Bhandare <kiranx.bhandare@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/179] ice: avoid bpf_prog refcount underflow
Date:   Mon, 29 Nov 2021 19:18:28 +0100
Message-Id: <20211129181722.712604187@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marta Plantykow <marta.a.plantykow@intel.com>

[ Upstream commit f65ee535df775a13a1046c0a0b2d72db342f8a5b ]

Ice driver has the routines for managing XDP resources that are shared
between ndo_bpf op and VSI rebuild flow. The latter takes place for
example when user changes queue count on an interface via ethtool's
set_channels().

There is an issue around the bpf_prog refcounting when VSI is being
rebuilt - since ice_prepare_xdp_rings() is called with vsi->xdp_prog as
an argument that is used later on by ice_vsi_assign_bpf_prog(), same
bpf_prog pointers are swapped with each other. Then it is also
interpreted as an 'old_prog' which in turn causes us to call
bpf_prog_put on it that will decrement its refcount.

Below splat can be interpreted in a way that due to zero refcount of a
bpf_prog it is wiped out from the system while kernel still tries to
refer to it:

[  481.069429] BUG: unable to handle page fault for address: ffffc9000640f038
[  481.077390] #PF: supervisor read access in kernel mode
[  481.083335] #PF: error_code(0x0000) - not-present page
[  481.089276] PGD 100000067 P4D 100000067 PUD 1001cb067 PMD 106d2b067 PTE 0
[  481.097141] Oops: 0000 [#1] PREEMPT SMP PTI
[  481.101980] CPU: 12 PID: 3339 Comm: sudo Tainted: G           OE     5.15.0-rc5+ #1
[  481.110840] Hardware name: Intel Corp. GRANTLEY/GRANTLEY, BIOS GRRFCRB1.86B.0276.D07.1605190235 05/19/2016
[  481.122021] RIP: 0010:dev_xdp_prog_id+0x25/0x40
[  481.127265] Code: 80 00 00 00 00 0f 1f 44 00 00 89 f6 48 c1 e6 04 48 01 fe 48 8b 86 98 08 00 00 48 85 c0 74 13 48 8b 50 18 31 c0 48 85 d2 74 07 <48> 8b 42 38 8b 40 20 c3 48 8b 96 90 08 00 00 eb e8 66 2e 0f 1f 84
[  481.148991] RSP: 0018:ffffc90007b63868 EFLAGS: 00010286
[  481.155034] RAX: 0000000000000000 RBX: ffff889080824000 RCX: 0000000000000000
[  481.163278] RDX: ffffc9000640f000 RSI: ffff889080824010 RDI: ffff889080824000
[  481.171527] RBP: ffff888107af7d00 R08: 0000000000000000 R09: ffff88810db5f6e0
[  481.179776] R10: 0000000000000000 R11: ffff8890885b9988 R12: ffff88810db5f4bc
[  481.188026] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  481.196276] FS:  00007f5466d5bec0(0000) GS:ffff88903fb00000(0000) knlGS:0000000000000000
[  481.205633] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  481.212279] CR2: ffffc9000640f038 CR3: 000000014429c006 CR4: 00000000003706e0
[  481.220530] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  481.228771] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  481.237029] Call Trace:
[  481.239856]  rtnl_fill_ifinfo+0x768/0x12e0
[  481.244602]  rtnl_dump_ifinfo+0x525/0x650
[  481.249246]  ? __alloc_skb+0xa5/0x280
[  481.253484]  netlink_dump+0x168/0x3c0
[  481.257725]  netlink_recvmsg+0x21e/0x3e0
[  481.262263]  ____sys_recvmsg+0x87/0x170
[  481.266707]  ? __might_fault+0x20/0x30
[  481.271046]  ? _copy_from_user+0x66/0xa0
[  481.275591]  ? iovec_from_user+0xf6/0x1c0
[  481.280226]  ___sys_recvmsg+0x82/0x100
[  481.284566]  ? sock_sendmsg+0x5e/0x60
[  481.288791]  ? __sys_sendto+0xee/0x150
[  481.293129]  __sys_recvmsg+0x56/0xa0
[  481.297267]  do_syscall_64+0x3b/0xc0
[  481.301395]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  481.307238] RIP: 0033:0x7f5466f39617
[  481.311373] Code: 0c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb bd 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2f 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
[  481.342944] RSP: 002b:00007ffedc7f4308 EFLAGS: 00000246 ORIG_RAX: 000000000000002f
[  481.361783] RAX: ffffffffffffffda RBX: 00007ffedc7f5460 RCX: 00007f5466f39617
[  481.380278] RDX: 0000000000000000 RSI: 00007ffedc7f5360 RDI: 0000000000000003
[  481.398500] RBP: 00007ffedc7f53f0 R08: 0000000000000000 R09: 000055d556f04d50
[  481.416463] R10: 0000000000000077 R11: 0000000000000246 R12: 00007ffedc7f5360
[  481.434131] R13: 00007ffedc7f5350 R14: 00007ffedc7f5344 R15: 0000000000000e98
[  481.451520] Modules linked in: ice(OE) af_packet binfmt_misc nls_iso8859_1 ipmi_ssif intel_rapl_msr intel_rapl_common x86_pkg_temp_thermal intel_powerclamp mxm_wmi mei_me coretemp mei ipmi_si ipmi_msghandler wmi acpi_pad acpi_power_meter ip_tables x_tables autofs4 crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel ahci crypto_simd cryptd libahci lpc_ich [last unloaded: ice]
[  481.528558] CR2: ffffc9000640f038
[  481.542041] ---[ end trace d1f24c9ecf5b61c1 ]---

Fix this by only calling ice_vsi_assign_bpf_prog() inside
ice_prepare_xdp_rings() when current vsi->xdp_prog pointer is NULL.
This way set_channels() flow will not attempt to swap the vsi->xdp_prog
pointers with itself.

Also, sprinkle around some comments that provide a reasoning about
correlation between driver and kernel in terms of bpf_prog refcount.

Fixes: efc2214b6047 ("ice: Add support for XDP")
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Marta Plantykow <marta.a.plantykow@intel.com>
Co-developed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a39136b0bd16a..f622ee20ac40d 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2497,7 +2497,18 @@ int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog)
 			ice_stat_str(status));
 		goto clear_xdp_rings;
 	}
-	ice_vsi_assign_bpf_prog(vsi, prog);
+
+	/* assign the prog only when it's not already present on VSI;
+	 * this flow is a subject of both ethtool -L and ndo_bpf flows;
+	 * VSI rebuild that happens under ethtool -L can expose us to
+	 * the bpf_prog refcount issues as we would be swapping same
+	 * bpf_prog pointers from vsi->xdp_prog and calling bpf_prog_put
+	 * on it as it would be treated as an 'old_prog'; for ndo_bpf
+	 * this is not harmful as dev_xdp_install bumps the refcount
+	 * before calling the op exposed by the driver;
+	 */
+	if (!ice_is_xdp_ena_vsi(vsi))
+		ice_vsi_assign_bpf_prog(vsi, prog);
 
 	return 0;
 clear_xdp_rings:
@@ -2643,6 +2654,11 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 		if (xdp_ring_err)
 			NL_SET_ERR_MSG_MOD(extack, "Freeing XDP Tx resources failed");
 	} else {
+		/* safe to call even when prog == vsi->xdp_prog as
+		 * dev_xdp_install in net/core/dev.c incremented prog's
+		 * refcount so corresponding bpf_prog_put won't cause
+		 * underflow
+		 */
 		ice_vsi_assign_bpf_prog(vsi, prog);
 	}
 
-- 
2.33.0



