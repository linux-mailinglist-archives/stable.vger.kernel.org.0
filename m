Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22B962EE00
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732428AbfE3DnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:43:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732479AbfE3DVL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:21:11 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C65F249BB;
        Thu, 30 May 2019 03:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186470;
        bh=xtknEr5gRj5yzbIvJSUC9zhCIRFREdHB0wB2ftvKlWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ADMx1+c48rdxbcFazWuOl3JG1p6ByAuCWs2itpOhBOEmCwLYCu61oT/4teRc6WDgg
         aeShxErUK50geBpHp0v57PVF9cxBByeZian7LObbbbpC68fBaT8KgFRDMZbBzkkNTC
         yVnFA0KQmjVyk9LRUI0tv7Ny/DzLnVqM4vL0hQlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Piotr Figiel <p.figiel@camlintechnologies.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 098/128] brcmfmac: fix Oops when bringing up interface during USB disconnect
Date:   Wed, 29 May 2019 20:07:10 -0700
Message-Id: <20190530030452.253412030@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 24d413a31afaee9bbbf79226052c386b01780ce2 ]

Fix a race which leads to an Oops with NULL pointer dereference.  The
dereference is in brcmf_config_dongle() when cfg_to_ndev() attempts to get
net_device structure of interface with index 0 via if2bss mapping. This
shouldn't fail because of check for bus being ready in brcmf_netdev_open(),
but it's not synchronised with USB disconnect and there is a race: after
the check the bus can be marked down and the mapping for interface 0 may be
gone.

Solve this by modifying disconnect handling so that the removal of mapping
of ifidx to brcmf_if structure happens after netdev removal (which is
synchronous with brcmf_netdev_open() thanks to rtln being locked in
devinet_ioctl()). This assures brcmf_netdev_open() returns before the
mapping is removed during disconnect.

Unable to handle kernel NULL pointer dereference at virtual address 00000008
pgd = bcae2612
[00000008] *pgd=8be73831
Internal error: Oops: 17 [#1] PREEMPT SMP ARM
Modules linked in: brcmfmac brcmutil nf_log_ipv4 nf_log_common xt_LOG xt_limit
iptable_mangle xt_connmark xt_tcpudp xt_conntrack nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 iptable_filter ip_tables x_tables usb_f_mass_storage usb_f_rndis
u_ether usb_serial_simple usbserial cdc_acm smsc95xx usbnet ci_hdrc_imx ci_hdrc
usbmisc_imx ulpi 8250_exar 8250_pci 8250 8250_base libcomposite configfs
udc_core [last unloaded: brcmutil]
CPU: 2 PID: 24478 Comm: ifconfig Not tainted 4.19.23-00078-ga62866d-dirty #115
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
PC is at brcmf_cfg80211_up+0x94/0x29c [brcmfmac]
LR is at brcmf_cfg80211_up+0x8c/0x29c [brcmfmac]
pc : [<7f26a91c>]    lr : [<7f26a914>]    psr: a0070013
sp : eca99d28  ip : 00000000  fp : ee9c6c00
r10: 00000036  r9 : 00000000  r8 : ece4002c
r7 : edb5b800  r6 : 00000000  r5 : 80f08448  r4 : edb5b968
r3 : ffffffff  r2 : 00000000  r1 : 00000002  r0 : 00000000
Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 10c5387d  Table: 7ca0c04a  DAC: 00000051
Process ifconfig (pid: 24478, stack limit = 0xd9e85a0e)
Stack: (0xeca99d28 to 0xeca9a000)
9d20:                   00000000 80f873b0 0000000d 80f08448 eca99d68 50d45f32
9d40: 7f27de94 ece40000 80f08448 80f08448 7f27de94 ece4002c 00000000 00000036
9d60: ee9c6c00 7f27262c 00001002 50d45f32 ece40000 00000000 80f08448 80772008
9d80: 00000001 00001043 00001002 ece40000 00000000 50d45f32 ece40000 00000001
9da0: 80f08448 00001043 00001002 807723d0 00000000 50d45f32 80f08448 eca99e58
9dc0: 80f87113 50d45f32 80f08448 ece40000 ece40138 00001002 80f08448 00000000
9de0: 00000000 80772434 edbd5380 eca99e58 edbd5380 80f08448 ee9c6c0c 80805f70
9e00: 00000000 ede08e00 00008914 ece40000 00000014 ee9c6c0c 600c0013 00001043
9e20: 0208a8c0 ffffffff 00000000 50d45f32 eca98000 80f08448 7ee9fc38 00008914
9e40: 80f68e40 00000051 eca98000 00000036 00000003 80808b9c 6e616c77 00000030
9e60: 00000000 00000000 00001043 0208a8c0 ffffffff 00000000 80f08448 00000000
9e80: 00000000 816d8b20 600c0013 00000001 ede09320 801763d4 00000000 50d45f32
9ea0: eca98000 80f08448 7ee9fc38 50d45f32 00008914 80f08448 7ee9fc38 80f68e40
9ec0: ed531540 8074721c 00000800 00000001 00000000 6e616c77 00000030 00000000
9ee0: 00000000 00001002 0208a8c0 ffffffff 00000000 50d45f32 80f08448 7ee9fc38
9f00: ed531560 ec8fc900 80285a6c 80285138 edb910c0 00000000 ecd91008 ede08e00
9f20: 80f08448 00000000 00000000 816d8b20 600c0013 00000001 ede09320 801763d4
9f40: 00000000 50d45f32 00021000 edb91118 edb910c0 80f08448 01b29000 edb91118
9f60: eca99f7c 50d45f32 00021000 ec8fc900 00000003 ec8fc900 00008914 7ee9fc38
9f80: eca98000 00000036 00000003 80285a6c 00086364 7ee9fe1c 000000c3 00000036
9fa0: 801011c4 80101000 00086364 7ee9fe1c 00000003 00008914 7ee9fc38 00086364
9fc0: 00086364 7ee9fe1c 000000c3 00000036 0008630c 7ee9fe1c 7ee9fc38 00000003
9fe0: 000a42b8 7ee9fbd4 00019914 76e09acc 600c0010 00000003 00000000 00000000
[<7f26a91c>] (brcmf_cfg80211_up [brcmfmac]) from [<7f27262c>] (brcmf_netdev_open+0x74/0xe8 [brcmfmac])
[<7f27262c>] (brcmf_netdev_open [brcmfmac]) from [<80772008>] (__dev_open+0xcc/0x150)
[<80772008>] (__dev_open) from [<807723d0>] (__dev_change_flags+0x168/0x1b4)
[<807723d0>] (__dev_change_flags) from [<80772434>] (dev_change_flags+0x18/0x48)
[<80772434>] (dev_change_flags) from [<80805f70>] (devinet_ioctl+0x67c/0x79c)
[<80805f70>] (devinet_ioctl) from [<80808b9c>] (inet_ioctl+0x210/0x3d4)
[<80808b9c>] (inet_ioctl) from [<8074721c>] (sock_ioctl+0x350/0x524)
[<8074721c>] (sock_ioctl) from [<80285138>] (do_vfs_ioctl+0xb0/0x9b0)
[<80285138>] (do_vfs_ioctl) from [<80285a6c>] (ksys_ioctl+0x34/0x5c)
[<80285a6c>] (ksys_ioctl) from [<80101000>] (ret_fast_syscall+0x0/0x28)
Exception stack(0xeca99fa8 to 0xeca99ff0)
9fa0:                   00086364 7ee9fe1c 00000003 00008914 7ee9fc38 00086364
9fc0: 00086364 7ee9fe1c 000000c3 00000036 0008630c 7ee9fe1c 7ee9fc38 00000003
9fe0: 000a42b8 7ee9fbd4 00019914 76e09acc
Code: e5970328 eb002021 e1a02006 e3a01002 (e5909008)
---[ end trace 5cbac2333f3ac5df ]---

Signed-off-by: Piotr Figiel <p.figiel@camlintechnologies.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/core.c    | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index f877301c9454b..ecfe056d76437 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -685,17 +685,17 @@ static void brcmf_del_if(struct brcmf_pub *drvr, s32 bsscfgidx,
 			 bool rtnl_locked)
 {
 	struct brcmf_if *ifp;
+	int ifidx;
 
 	ifp = drvr->iflist[bsscfgidx];
-	drvr->iflist[bsscfgidx] = NULL;
 	if (!ifp) {
 		brcmf_err("Null interface, bsscfgidx=%d\n", bsscfgidx);
 		return;
 	}
 	brcmf_dbg(TRACE, "Enter, bsscfgidx=%d, ifidx=%d\n", bsscfgidx,
 		  ifp->ifidx);
-	if (drvr->if2bss[ifp->ifidx] == bsscfgidx)
-		drvr->if2bss[ifp->ifidx] = BRCMF_BSSIDX_INVALID;
+	ifidx = ifp->ifidx;
+
 	if (ifp->ndev) {
 		if (bsscfgidx == 0) {
 			if (ifp->ndev->netdev_ops == &brcmf_netdev_ops_pri) {
@@ -723,6 +723,10 @@ static void brcmf_del_if(struct brcmf_pub *drvr, s32 bsscfgidx,
 		brcmf_p2p_ifp_removed(ifp, rtnl_locked);
 		kfree(ifp);
 	}
+
+	drvr->iflist[bsscfgidx] = NULL;
+	if (drvr->if2bss[ifidx] == bsscfgidx)
+		drvr->if2bss[ifidx] = BRCMF_BSSIDX_INVALID;
 }
 
 void brcmf_remove_interface(struct brcmf_if *ifp, bool rtnl_locked)
-- 
2.20.1



