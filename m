Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9F92A5262
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731537AbgKCUtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:49:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:42212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731530AbgKCUtX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:49:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 476E720719;
        Tue,  3 Nov 2020 20:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436562;
        bh=jpzdvuNokXslXBUxDdzdKnwXxagvAnLCYfVtnc+1j+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hvCh1PSryb80AdpvrGJVp06zsofQEaWc3hS8unwr+cCpeJ9XPaQ75z7phqF4fHFul
         S0tc3HkzXI+ErDndfVL6YJroS9WSNXNTSpN44v6RwQM2F+HO1prk94S4CVCSfjDlTN
         SDr21WHEd4ZklPNYbmoCekf/5vGWUfCUDjSCiF5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH 5.9 266/391] vdpa_sim: Fix DMA mask
Date:   Tue,  3 Nov 2020 21:35:17 +0100
Message-Id: <20201103203404.974056762@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Vivier <lvivier@redhat.com>

commit 1eca16b231570c8ae57fb91fdfbc48eb52c6a93b upstream.

Since commit f959dcd6ddfd
("dma-direct: Fix potential NULL pointer dereference")
an error is reported when we load vdpa_sim and virtio-vdpa:

[  129.351207] net eth0: Unexpected TXQ (0) queue failure: -12

It seems that dma_mask is not initialized.

This patch initializes dma_mask() and calls dma_set_mask_and_coherent()
to fix the problem.

Full log:

[  128.548628] ------------[ cut here ]------------
[  128.553268] WARNING: CPU: 23 PID: 1105 at kernel/dma/mapping.c:149 dma_m=
ap_page_attrs+0x14c/0x1d0
[  128.562139] Modules linked in: virtio_net net_failover failover virtio_v=
dpa vdpa_sim vringh vhost_iotlb vdpa xt_CHECKSUM xt_MASQUERADE xt_conntrack=
 ipt_REJECT nf_reject_ipv4 nft_compat nft_counter nft_chain_nat nf_nat nf_c=
onntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables nfnetlink tun bridge stp l=
lc iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi rfkill intel_rapl_m=
sr intel_rapl_common isst_if_common sunrpc skx_edac nfit libnvdimm x86_pkg_=
temp_thermal intel_powerclamp coretemp kvm_intel ipmi_ssif kvm mgag200 i2c_=
algo_bit irqbypass drm_kms_helper crct10dif_pclmul crc32_pclmul syscopyarea=
 ghash_clmulni_intel iTCO_wdt sysfillrect iTCO_vendor_support sysimgblt rap=
l fb_sys_fops dcdbas intel_cstate drm acpi_ipmi ipmi_si mei_me dell_smbios =
intel_uncore ipmi_devintf mei i2c_i801 dell_wmi_descriptor wmi_bmof pcspkr =
lpc_ich i2c_smbus ipmi_msghandler acpi_power_meter ip_tables xfs libcrc32c =
sd_mod t10_pi sg ahci libahci libata megaraid_sas tg3 crc32c_intel wmi dm_m=
irror dm_region_hash dm_log
[  128.562188]  dm_mod
[  128.651334] CPU: 23 PID: 1105 Comm: NetworkManager Tainted: G S        I=
       5.10.0-rc1+ #59
[  128.659939] Hardware name: Dell Inc. PowerEdge R440/04JN2K, BIOS 2.8.1 0=
6/30/2020
[  128.667419] RIP: 0010:dma_map_page_attrs+0x14c/0x1d0
[  128.672384] Code: 1c 25 28 00 00 00 0f 85 97 00 00 00 48 83 c4 10 5b 5d =
41 5c 41 5d c3 4c 89 da eb d7 48 89 f2 48 2b 50 18 48 89 d0 eb 8d 0f 0b <0f=
> 0b 48 c7 c0 ff ff ff ff eb c3 48 89 d9 48 8b 40 40 e8 2d a0 aa
[  128.691131] RSP: 0018:ffffae0f0151f3c8 EFLAGS: 00010246
[  128.696357] RAX: ffffffffc06b7400 RBX: 00000000000005fa RCX: 00000000000=
00000
[  128.703488] RDX: 0000000000000040 RSI: ffffcee3c7861200 RDI: ffff9e2bc16=
cd000
[  128.710620] RBP: 0000000000000000 R08: 0000000000000002 R09: 00000000000=
00000
[  128.717754] R10: 0000000000000002 R11: 0000000000000000 R12: ffff9e472cb=
291f8
[  128.724886] R13: ffff9e2bc14da780 R14: ffff9e472bc20000 R15: ffff9e2bc1b=
14940
[  128.732020] FS:  00007f887bae23c0(0000) GS:ffff9e4ac01c0000(0000) knlGS:=
0000000000000000
[  128.740105] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  128.745852] CR2: 0000562bc09de998 CR3: 00000003c156c006 CR4: 00000000007=
706e0
[  128.752982] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  128.760114] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[  128.767247] PKRU: 55555554
[  128.769961] Call Trace:
[  128.772418]  virtqueue_add+0x81e/0xb00
[  128.776176]  virtqueue_add_inbuf_ctx+0x26/0x30
[  128.780625]  try_fill_recv+0x3a2/0x6e0 [virtio_net]
[  128.785509]  virtnet_open+0xf9/0x180 [virtio_net]
[  128.790217]  __dev_open+0xe8/0x180
[  128.793620]  __dev_change_flags+0x1a7/0x210
[  128.797808]  dev_change_flags+0x21/0x60
[  128.801646]  do_setlink+0x328/0x10e0
[  128.805227]  ? __nla_validate_parse+0x121/0x180
[  128.809757]  ? __nla_parse+0x21/0x30
[  128.813338]  ? inet6_validate_link_af+0x5c/0xf0
[  128.817871]  ? cpumask_next+0x17/0x20
[  128.821535]  ? __snmp6_fill_stats64.isra.54+0x6b/0x110
[  128.826676]  ? __nla_validate_parse+0x47/0x180
[  128.831120]  __rtnl_newlink+0x541/0x8e0
[  128.834962]  ? __nla_reserve+0x38/0x50
[  128.838713]  ? security_sock_rcv_skb+0x2a/0x40
[  128.843158]  ? netlink_deliver_tap+0x2c/0x1e0
[  128.847518]  ? netlink_attachskb+0x1d8/0x220
[  128.851793]  ? skb_queue_tail+0x1b/0x50
[  128.855641]  ? fib6_clean_node+0x43/0x170
[  128.859652]  ? _cond_resched+0x15/0x30
[  128.863406]  ? kmem_cache_alloc_trace+0x3a3/0x420
[  128.868110]  rtnl_newlink+0x43/0x60
[  128.871602]  rtnetlink_rcv_msg+0x12c/0x380
[  128.875701]  ? rtnl_calcit.isra.39+0x110/0x110
[  128.880147]  netlink_rcv_skb+0x50/0x100
[  128.883987]  netlink_unicast+0x1a5/0x280
[  128.887913]  netlink_sendmsg+0x23d/0x470
[  128.891839]  sock_sendmsg+0x5b/0x60
[  128.895331]  ____sys_sendmsg+0x1ef/0x260
[  128.899255]  ? copy_msghdr_from_user+0x5c/0x90
[  128.903702]  ___sys_sendmsg+0x7c/0xc0
[  128.907369]  ? dev_forward_change+0x130/0x130
[  128.911731]  ? sysctl_head_finish.part.29+0x24/0x40
[  128.916616]  ? new_sync_write+0x11f/0x1b0
[  128.920628]  ? mntput_no_expire+0x47/0x240
[  128.924727]  __sys_sendmsg+0x57/0xa0
[  128.928309]  do_syscall_64+0x33/0x40
[  128.931887]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  128.936937] RIP: 0033:0x7f88792e3857
[  128.940518] Code: c3 66 90 41 54 41 89 d4 55 48 89 f5 53 89 fb 48 83 ec =
10 e8 0b ed ff ff 44 89 e2 48 89 ee 89 df 41 89 c0 b8 2e 00 00 00 0f 05 <48=
> 3d 00 f0 ff ff 77 35 44 89 c7 48 89 44 24 08 e8 44 ed ff ff 48
[  128.959263] RSP: 002b:00007ffdca60dea0 EFLAGS: 00000293 ORIG_RAX: 000000=
000000002e
[  128.966827] RAX: ffffffffffffffda RBX: 000000000000000c RCX: 00007f88792=
e3857
[  128.973960] RDX: 0000000000000000 RSI: 00007ffdca60def0 RDI: 00000000000=
0000c
[  128.981095] RBP: 00007ffdca60def0 R08: 0000000000000000 R09: 00000000000=
00000
[  128.988224] R10: 0000000000000001 R11: 0000000000000293 R12: 00000000000=
00000
[  128.995357] R13: 0000000000000000 R14: 00007ffdca60e0a8 R15: 00007ffdca6=
0e09c
[  129.002492] CPU: 23 PID: 1105 Comm: NetworkManager Tainted: G S        I=
       5.10.0-rc1+ #59
[  129.011093] Hardware name: Dell Inc. PowerEdge R440/04JN2K, BIOS 2.8.1 0=
6/30/2020
[  129.018571] Call Trace:
[  129.021027]  dump_stack+0x57/0x6a
[  129.024346]  __warn.cold.14+0xe/0x3d
[  129.027925]  ? dma_map_page_attrs+0x14c/0x1d0
[  129.032283]  report_bug+0xbd/0xf0
[  129.035602]  handle_bug+0x44/0x80
[  129.038922]  exc_invalid_op+0x13/0x60
[  129.042589]  asm_exc_invalid_op+0x12/0x20
[  129.046602] RIP: 0010:dma_map_page_attrs+0x14c/0x1d0
[  129.051566] Code: 1c 25 28 00 00 00 0f 85 97 00 00 00 48 83 c4 10 5b 5d =
41 5c 41 5d c3 4c 89 da eb d7 48 89 f2 48 2b 50 18 48 89 d0 eb 8d 0f 0b <0f=
> 0b 48 c7 c0 ff ff ff ff eb c3 48 89 d9 48 8b 40 40 e8 2d a0 aa
[  129.070311] RSP: 0018:ffffae0f0151f3c8 EFLAGS: 00010246
[  129.075536] RAX: ffffffffc06b7400 RBX: 00000000000005fa RCX: 00000000000=
00000
[  129.082669] RDX: 0000000000000040 RSI: ffffcee3c7861200 RDI: ffff9e2bc16=
cd000
[  129.089803] RBP: 0000000000000000 R08: 0000000000000002 R09: 00000000000=
00000
[  129.096936] R10: 0000000000000002 R11: 0000000000000000 R12: ffff9e472cb=
291f8
[  129.104068] R13: ffff9e2bc14da780 R14: ffff9e472bc20000 R15: ffff9e2bc1b=
14940
[  129.111200]  virtqueue_add+0x81e/0xb00
[  129.114952]  virtqueue_add_inbuf_ctx+0x26/0x30
[  129.119399]  try_fill_recv+0x3a2/0x6e0 [virtio_net]
[  129.124280]  virtnet_open+0xf9/0x180 [virtio_net]
[  129.128984]  __dev_open+0xe8/0x180
[  129.132390]  __dev_change_flags+0x1a7/0x210
[  129.136575]  dev_change_flags+0x21/0x60
[  129.140415]  do_setlink+0x328/0x10e0
[  129.143994]  ? __nla_validate_parse+0x121/0x180
[  129.148528]  ? __nla_parse+0x21/0x30
[  129.152107]  ? inet6_validate_link_af+0x5c/0xf0
[  129.156639]  ? cpumask_next+0x17/0x20
[  129.160306]  ? __snmp6_fill_stats64.isra.54+0x6b/0x110
[  129.165443]  ? __nla_validate_parse+0x47/0x180
[  129.169890]  __rtnl_newlink+0x541/0x8e0
[  129.173731]  ? __nla_reserve+0x38/0x50
[  129.177483]  ? security_sock_rcv_skb+0x2a/0x40
[  129.181928]  ? netlink_deliver_tap+0x2c/0x1e0
[  129.186286]  ? netlink_attachskb+0x1d8/0x220
[  129.190560]  ? skb_queue_tail+0x1b/0x50
[  129.194401]  ? fib6_clean_node+0x43/0x170
[  129.198411]  ? _cond_resched+0x15/0x30
[  129.202163]  ? kmem_cache_alloc_trace+0x3a3/0x420
[  129.206869]  rtnl_newlink+0x43/0x60
[  129.210361]  rtnetlink_rcv_msg+0x12c/0x380
[  129.214462]  ? rtnl_calcit.isra.39+0x110/0x110
[  129.218908]  netlink_rcv_skb+0x50/0x100
[  129.222747]  netlink_unicast+0x1a5/0x280
[  129.226672]  netlink_sendmsg+0x23d/0x470
[  129.230599]  sock_sendmsg+0x5b/0x60
[  129.234090]  ____sys_sendmsg+0x1ef/0x260
[  129.238015]  ? copy_msghdr_from_user+0x5c/0x90
[  129.242461]  ___sys_sendmsg+0x7c/0xc0
[  129.246128]  ? dev_forward_change+0x130/0x130
[  129.250487]  ? sysctl_head_finish.part.29+0x24/0x40
[  129.255368]  ? new_sync_write+0x11f/0x1b0
[  129.259381]  ? mntput_no_expire+0x47/0x240
[  129.263478]  __sys_sendmsg+0x57/0xa0
[  129.267058]  do_syscall_64+0x33/0x40
[  129.270639]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  129.275689] RIP: 0033:0x7f88792e3857
[  129.279268] Code: c3 66 90 41 54 41 89 d4 55 48 89 f5 53 89 fb 48 83 ec =
10 e8 0b ed ff ff 44 89 e2 48 89 ee 89 df 41 89 c0 b8 2e 00 00 00 0f 05 <48=
> 3d 00 f0 ff ff 77 35 44 89 c7 48 89 44 24 08 e8 44 ed ff ff 48
[  129.298015] RSP: 002b:00007ffdca60dea0 EFLAGS: 00000293 ORIG_RAX: 000000=
000000002e
[  129.305581] RAX: ffffffffffffffda RBX: 000000000000000c RCX: 00007f88792=
e3857
[  129.312712] RDX: 0000000000000000 RSI: 00007ffdca60def0 RDI: 00000000000=
0000c
[  129.319846] RBP: 00007ffdca60def0 R08: 0000000000000000 R09: 00000000000=
00000
[  129.326978] R10: 0000000000000001 R11: 0000000000000293 R12: 00000000000=
00000
[  129.334109] R13: 0000000000000000 R14: 00007ffdca60e0a8 R15: 00007ffdca6=
0e09c
[  129.341249] ---[ end trace c551e8028fbaf59d ]---
[  129.351207] net eth0: Unexpected TXQ (0) queue failure: -12
[  129.360445] net eth0: Unexpected TXQ (0) queue failure: -12
[  129.824428] net eth0: Unexpected TXQ (0) queue failure: -12

Fixes: 2c53d0f64c06 ("vdpasim: vDPA device simulator")
Signed-off-by: Laurent Vivier <lvivier@redhat.com>
Link: https://lore.kernel.org/r/20201027175914.689278-1-lvivier@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: stable@vger.kernel.org
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vdpa/vdpa_sim/vdpa_sim.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -362,7 +362,9 @@ static struct vdpasim *vdpasim_create(vo
 	spin_lock_init(&vdpasim->iommu_lock);
=20
 	dev =3D &vdpasim->vdpa.dev;
-	dev->coherent_dma_mask =3D DMA_BIT_MASK(64);
+	dev->dma_mask =3D &dev->coherent_dma_mask;
+	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64)))
+		goto err_iommu;
 	set_dma_ops(dev, &vdpasim_dma_ops);
=20
 	vdpasim->iommu =3D vhost_iotlb_alloc(2048, 0);


