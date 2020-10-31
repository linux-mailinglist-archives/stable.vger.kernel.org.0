Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50832A16A4
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgJaLp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:45:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727707AbgJaLp2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:45:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF248205F4;
        Sat, 31 Oct 2020 11:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144726;
        bh=yt9pwQKSCvOV8+HFyijjmx3hr9YYSLT/v52Eqcr+jTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UAHTurntdg2XiLhlPVYJaywyiacOPx6ravziiYcA35vCiO9yhutlU3hE8PdMHpnb+
         cuHT1eshQTwMmN1wLHqcg6YjlQ884zN28Pm3p82ZAHyc9NDYd6Jux0xfq8kaKK+syU
         nBo4WeOG9hwRjMpkewCCJ3KOv0cujBNYWuwnlH0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 27/74] bnxt_en: Check abort error state in bnxt_open_nic().
Date:   Sat, 31 Oct 2020 12:36:09 +0100
Message-Id: <20201031113501.347501899@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit a1301f08c5acf992d9c1fafddc84c3a822844b04 ]

bnxt_open_nic() is called during configuration changes that require
the NIC to be closed and then opened.  This call is protected by
rtnl_lock.  Firmware reset can be happening at the same time.  Only
critical portions of the entire firmware reset sequence are protected
by the rtnl_lock.  It is possible that bnxt_open_nic() can be called
when the firmware reset sequence is aborting.  In that case,
bnxt_open_nic() needs to check if the ABORT_ERR flag is set and
abort if it is.  The configuration change that resulted in the
bnxt_open_nic() call will fail but the NIC will be brought to a
consistent IF_DOWN state.

Without this patch, if bnxt_open_nic() were to continue in this error
state, it may crash like this:

[ 1648.659736] BUG: unable to handle kernel NULL pointer dereference at           (null)
[ 1648.659768] IP: [<ffffffffc01e9b3a>] bnxt_alloc_mem+0x50a/0x1140 [bnxt_en]
[ 1648.659796] PGD 101e1b3067 PUD 101e1b2067 PMD 0
[ 1648.659813] Oops: 0000 [#1] SMP
[ 1648.659825] Modules linked in: xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 tun bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter sunrpc dell_smbios dell_wmi_descriptor dcdbas amd64_edac_mod edac_mce_amd kvm_amd kvm irqbypass crc32_pclmul ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper vfat cryptd fat pcspkr ipmi_ssif sg k10temp i2c_piix4 wmi ipmi_si ipmi_devintf ipmi_msghandler tpm_crb acpi_power_meter sch_fq_codel ip_tables xfs libcrc32c sd_mod crc_t10dif crct10dif_generic mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm ahci drm libahci megaraid_sas crct10dif_pclmul crct10dif_common
[ 1648.660063]  tg3 libata crc32c_intel bnxt_en(OE) drm_panel_orientation_quirks devlink ptp pps_core dm_mirror dm_region_hash dm_log dm_mod fuse
[ 1648.660105] CPU: 13 PID: 3867 Comm: ethtool Kdump: loaded Tainted: G           OE  ------------   3.10.0-1152.el7.x86_64 #1
[ 1648.660911] Hardware name: Dell Inc. PowerEdge R7515/0R4CNN, BIOS 1.2.14 01/28/2020
[ 1648.661662] task: ffff94e64cbc9080 ti: ffff94f55df1c000 task.ti: ffff94f55df1c000
[ 1648.662409] RIP: 0010:[<ffffffffc01e9b3a>]  [<ffffffffc01e9b3a>] bnxt_alloc_mem+0x50a/0x1140 [bnxt_en]
[ 1648.663171] RSP: 0018:ffff94f55df1fba8  EFLAGS: 00010202
[ 1648.663927] RAX: 0000000000000000 RBX: ffff94e6827e0000 RCX: 0000000000000000
[ 1648.664684] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff94e6827e08c0
[ 1648.665433] RBP: ffff94f55df1fc20 R08: 00000000000001ff R09: 0000000000000008
[ 1648.666184] R10: 0000000000000d53 R11: ffff94f55df1f7ce R12: ffff94e6827e08c0
[ 1648.666940] R13: ffff94e6827e08c0 R14: ffff94e6827e08c0 R15: ffffffffb9115e40
[ 1648.667695] FS:  00007f8aadba5740(0000) GS:ffff94f57eb40000(0000) knlGS:0000000000000000
[ 1648.668447] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1648.669202] CR2: 0000000000000000 CR3: 0000001022772000 CR4: 0000000000340fe0
[ 1648.669966] Call Trace:
[ 1648.670730]  [<ffffffffc01f1d5d>] ? bnxt_need_reserve_rings+0x9d/0x170 [bnxt_en]
[ 1648.671496]  [<ffffffffc01fa7ea>] __bnxt_open_nic+0x8a/0x9a0 [bnxt_en]
[ 1648.672263]  [<ffffffffc01f7479>] ? bnxt_close_nic+0x59/0x1b0 [bnxt_en]
[ 1648.673031]  [<ffffffffc01fb11b>] bnxt_open_nic+0x1b/0x50 [bnxt_en]
[ 1648.673793]  [<ffffffffc020037c>] bnxt_set_ringparam+0x6c/0xa0 [bnxt_en]
[ 1648.674550]  [<ffffffffb8a5f564>] dev_ethtool+0x1334/0x21a0
[ 1648.675306]  [<ffffffffb8a719ff>] dev_ioctl+0x1ef/0x5f0
[ 1648.676061]  [<ffffffffb8a324bd>] sock_do_ioctl+0x4d/0x60
[ 1648.676810]  [<ffffffffb8a326bb>] sock_ioctl+0x1eb/0x2d0
[ 1648.677548]  [<ffffffffb8663230>] do_vfs_ioctl+0x3a0/0x5b0
[ 1648.678282]  [<ffffffffb8b8e678>] ? __do_page_fault+0x238/0x500
[ 1648.679016]  [<ffffffffb86634e1>] SyS_ioctl+0xa1/0xc0
[ 1648.679745]  [<ffffffffb8b93f92>] system_call_fastpath+0x25/0x2a
[ 1648.680461] Code: 9e 60 01 00 00 0f 1f 40 00 45 8b 8e 48 01 00 00 31 c9 45 85 c9 0f 8e 73 01 00 00 66 0f 1f 44 00 00 49 8b 86 a8 00 00 00 48 63 d1 <48> 8b 14 d0 48 85 d2 0f 84 46 01 00 00 41 8b 86 44 01 00 00 c7
[ 1648.681986] RIP  [<ffffffffc01e9b3a>] bnxt_alloc_mem+0x50a/0x1140 [bnxt_en]
[ 1648.682724]  RSP <ffff94f55df1fba8>
[ 1648.683451] CR2: 0000000000000000

Fixes: ec5d31e3c15d ("bnxt_en: Handle firmware reset status during IF_UP.")
Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9566,7 +9566,10 @@ int bnxt_open_nic(struct bnxt *bp, bool
 {
 	int rc = 0;
 
-	rc = __bnxt_open_nic(bp, irq_re_init, link_re_init);
+	if (test_bit(BNXT_STATE_ABORT_ERR, &bp->state))
+		rc = -EIO;
+	if (!rc)
+		rc = __bnxt_open_nic(bp, irq_re_init, link_re_init);
 	if (rc) {
 		netdev_err(bp->dev, "nic open fail (rc: %x)\n", rc);
 		dev_close(bp->dev);


