Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE7834FD604
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353332AbiDLHds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353567AbiDLHZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A2043495;
        Tue, 12 Apr 2022 00:01:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9399260B2E;
        Tue, 12 Apr 2022 07:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1F4C385A6;
        Tue, 12 Apr 2022 07:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746888;
        bh=JGF3BTHTo8aLg9YxNAXPCm4HKDigWN7JMvT3iSkIewc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AraxGQEApQQIIpIkOAqZmqkvCWk0b/PwGenbr9Eo3+N5xaUGM8sy1CKDzCG/ZOnTy
         mtROrVI1+DzANSkE9oBefYb5CUEj9H/MYdwDDa1pZX62WwXVP9huNAVViPwXlL34E7
         4kj4MxA//l9Cdnh32cy7HXKajeWN6VHwlhCdX7PA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Aleksandrov <razor@blackwall.org>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 167/285] net: ipv4: fix route with nexthop object delete warning
Date:   Tue, 12 Apr 2022 08:30:24 +0200
Message-Id: <20220412062948.489476895@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 6bf92d70e690b7ff12b24f4bfff5e5434d019b82 ]

FRR folks have hit a kernel warning[1] while deleting routes[2] which is
caused by trying to delete a route pointing to a nexthop id without
specifying nhid but matching on an interface. That is, a route is found
but we hit a warning while matching it. The warning is from
fib_info_nh() in include/net/nexthop.h because we run it on a fib_info
with nexthop object. The call chain is:
 inet_rtm_delroute -> fib_table_delete -> fib_nh_match (called with a
nexthop fib_info and also with fc_oif set thus calling fib_info_nh on
the fib_info and triggering the warning). The fix is to not do any
matching in that branch if the fi has a nexthop object because those are
managed separately. I.e. we should match when deleting without nh spec and
should fail when deleting a nexthop route with old-style nh spec because
nexthop objects are managed separately, e.g.:
 $ ip r show 1.2.3.4/32
 1.2.3.4 nhid 12 via 192.168.11.2 dev dummy0

 $ ip r del 1.2.3.4/32
 $ ip r del 1.2.3.4/32 nhid 12
 <both should work>

 $ ip r del 1.2.3.4/32 dev dummy0
 <should fail with ESRCH>

[1]
 [  523.462226] ------------[ cut here ]------------
 [  523.462230] WARNING: CPU: 14 PID: 22893 at include/net/nexthop.h:468 fi=
b_nh_match+0x210/0x460
 [  523.462236] Modules linked in: dummy rpcsec_gss_krb5 xt_socket nf_socke=
t_ipv4 nf_socket_ipv6 ip6table_raw iptable_raw bpf_preload xt_statistic ip_=
set ip_vs_sh ip_vs_wrr ip_vs_rr ip_vs xt_mark nf_tables xt_nat veth nf_conn=
track_netlink nfnetlink xt_addrtype br_netfilter overlay dm_crypt nfsv3 nfs=
 fscache netfs vhost_net vhost vhost_iotlb tap tun xt_CHECKSUM xt_MASQUERAD=
E xt_conntrack 8021q garp mrp ipt_REJECT nf_reject_ipv4 ip6table_mangle ip6=
table_nat iptable_mangle iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_=
defrag_ipv4 iptable_filter bridge stp llc rfcomm snd_seq_dummy snd_hrtimer =
rpcrdma rdma_cm iw_cm ib_cm ib_core ip6table_filter xt_comment ip6_tables v=
boxnetadp(OE) vboxnetflt(OE) vboxdrv(OE) qrtr bnep binfmt_misc xfs vfat fat=
 squashfs loop nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(P=
OE) intel_rapl_msr intel_rapl_common snd_hda_codec_realtek snd_hda_codec_ge=
neric ledtrig_audio snd_hda_codec_hdmi btusb btrtl iwlmvm uvcvideo btbcm sn=
d_hda_intel edac_mce_amd
 [  523.462274]  videobuf2_vmalloc videobuf2_memops btintel snd_intel_dspcf=
g videobuf2_v4l2 snd_intel_sdw_acpi bluetooth snd_usb_audio snd_hda_codec m=
ac80211 snd_usbmidi_lib joydev snd_hda_core videobuf2_common kvm_amd snd_ra=
wmidi snd_hwdep snd_seq videodev ccp snd_seq_device libarc4 ecdh_generic mc=
 snd_pcm kvm iwlwifi snd_timer drm_kms_helper snd cfg80211 cec soundcore ir=
qbypass rapl wmi_bmof i2c_piix4 rfkill k10temp pcspkr acpi_cpufreq nfsd aut=
h_rpcgss nfs_acl lockd grace sunrpc drm zram ip_tables crct10dif_pclmul crc=
32_pclmul crc32c_intel ghash_clmulni_intel nvme sp5100_tco r8169 nvme_core =
wmi ipmi_devintf ipmi_msghandler fuse
 [  523.462300] CPU: 14 PID: 22893 Comm: ip Tainted: P           OE     5.1=
6.18-200.fc35.x86_64 #1
 [  523.462302] Hardware name: Micro-Star International Co., Ltd. MS-7C37/M=
PG X570 GAMING EDGE WIFI (MS-7C37), BIOS 1.C0 10/29/2020
 [  523.462303] RIP: 0010:fib_nh_match+0x210/0x460
 [  523.462304] Code: 7c 24 20 48 8b b5 90 00 00 00 e8 bb ee f4 ff 48 8b 7c=
 24 20 41 89 c4 e8 ee eb f4 ff 45 85 e4 0f 85 2e fe ff ff e9 4c ff ff ff <0=
f> 0b e9 17 ff ff ff 3c 0a 0f 85 61 fe ff ff 48 8b b5 98 00 00 00
 [  523.462306] RSP: 0018:ffffaa53d4d87928 EFLAGS: 00010286
 [  523.462307] RAX: 0000000000000000 RBX: ffffaa53d4d87a90 RCX: ffffaa53d4=
d87bb0
 [  523.462308] RDX: ffff9e3d2ee6be80 RSI: ffffaa53d4d87a90 RDI: ffffffff92=
0ed380
 [  523.462309] RBP: ffff9e3d2ee6be80 R08: 0000000000000064 R09: 0000000000=
000000
 [  523.462310] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000=
000031
 [  523.462310] R13: 0000000000000020 R14: 0000000000000000 R15: ffff9e3d33=
1054e0
 [  523.462311] FS:  00007f245517c1c0(0000) GS:ffff9e492ed80000(0000) knlGS=
:0000000000000000
 [  523.462313] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 [  523.462313] CR2: 000055e5dfdd8268 CR3: 00000003ef488000 CR4: 0000000000=
350ee0
 [  523.462315] Call Trace:
 [  523.462316]  <TASK>
 [  523.462320]  fib_table_delete+0x1a9/0x310
 [  523.462323]  inet_rtm_delroute+0x93/0x110
 [  523.462325]  rtnetlink_rcv_msg+0x133/0x370
 [  523.462327]  ? _copy_to_iter+0xb5/0x6f0
 [  523.462330]  ? rtnl_calcit.isra.0+0x110/0x110
 [  523.462331]  netlink_rcv_skb+0x50/0xf0
 [  523.462334]  netlink_unicast+0x211/0x330
 [  523.462336]  netlink_sendmsg+0x23f/0x480
 [  523.462338]  sock_sendmsg+0x5e/0x60
 [  523.462340]  ____sys_sendmsg+0x22c/0x270
 [  523.462341]  ? import_iovec+0x17/0x20
 [  523.462343]  ? sendmsg_copy_msghdr+0x59/0x90
 [  523.462344]  ? __mod_lruvec_page_state+0x85/0x110
 [  523.462348]  ___sys_sendmsg+0x81/0xc0
 [  523.462350]  ? netlink_seq_start+0x70/0x70
 [  523.462352]  ? __dentry_kill+0x13a/0x180
 [  523.462354]  ? __fput+0xff/0x250
 [  523.462356]  __sys_sendmsg+0x49/0x80
 [  523.462358]  do_syscall_64+0x3b/0x90
 [  523.462361]  entry_SYSCALL_64_after_hwframe+0x44/0xae
 [  523.462364] RIP: 0033:0x7f24552aa337
 [  523.462365] Code: 0e 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b9 0f 1f=
 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <4=
8> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
 [  523.462366] RSP: 002b:00007fff7f05a838 EFLAGS: 00000246 ORIG_RAX: 00000=
0000000002e
 [  523.462368] RAX: ffffffffffffffda RBX: 000000006245bf91 RCX: 00007f2455=
2aa337
 [  523.462368] RDX: 0000000000000000 RSI: 00007fff7f05a8a0 RDI: 0000000000=
000003
 [  523.462369] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000=
000000
 [  523.462370] R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000=
000001
 [  523.462370] R13: 00007fff7f05ce08 R14: 0000000000000000 R15: 000055e5df=
dd1040
 [  523.462373]  </TASK>
 [  523.462374] ---[ end trace ba537bc16f6bf4ed ]---

[2] https://github.com/FRRouting/frr/issues/6412

Fixes: 4c7e8084fd46 ("ipv4: Plumb support for nexthop object in a fib_info")
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_semantics.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index d244c57b7303..b5563f5ff176 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -887,8 +887,13 @@ int fib_nh_match(struct net *net, struct fib_config *c=
fg, struct fib_info *fi,
 	}
=20
 	if (cfg->fc_oif || cfg->fc_gw_family) {
-		struct fib_nh *nh =3D fib_info_nh(fi, 0);
+		struct fib_nh *nh;
+
+		/* cannot match on nexthop object attributes */
+		if (fi->nh)
+			return 1;
=20
+		nh =3D fib_info_nh(fi, 0);
 		if (cfg->fc_encap) {
 			if (fib_encap_match(net, cfg->fc_encap_type,
 					    cfg->fc_encap, nh, cfg, extack))
--=20
2.35.1



