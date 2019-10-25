Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBEAE4E16
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 16:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395242AbfJYOEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 10:04:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394652AbfJYN4d (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 09:56:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56748222BD;
        Fri, 25 Oct 2019 13:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011792;
        bh=tH84Z0n/mSY4WyqsWkBcbzxNQsg59IxMwvdWkIi/cDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bCnLBZJrJlYu6AvweXB3cZt3kiuTjPJWS83CVacGhQjdYNoyuztwH3rfB0AVR1mEH
         ICQcZqdHRn3sAzlNiy6mQxfa34RxvAwE4cOryU68J7Kt9Q9hfZHI/34Lhs9TaAscLE
         MCuhuHyw/O4nnESer6QtpSVfsihvdOCAx80IwJZs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chad Dupuis <cdupuis@marvell.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 15/37] scsi: bnx2fc: Only put reference to io_req in bnx2fc_abts_cleanup if cleanup times out
Date:   Fri, 25 Oct 2019 09:55:39 -0400
Message-Id: <20191025135603.25093-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135603.25093-1-sashal@kernel.org>
References: <20191025135603.25093-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chad Dupuis <cdupuis@marvell.com>

[ Upstream commit a92ac6ee7980f3c139910d0d0a079802363818cb ]

In certain tests where the SCSI error handler issues an abort that is
already outstanding, we will cleanup the command so that the SCSI error
handler can proceed.  In some of these cases we were seeing a command
mismatch:

 kernel: scsi host2: bnx2fc: xid:0x42b eh_abort - refcnt = 2
 kernel: bnx2fc: eh_abort: io_req (xid = 0x42b) already in abts processing
 kernel: scsi host2: bnx2fc: xid:0x42b Entered bnx2fc_initiate_cleanup
 kernel: scsi host2: bnx2fc: xid:0x42b CLEANUP io_req xid = 0x80b
 kernel: scsi host2: bnx2fc: xid:0x80b cq_compl- cleanup resp rcvd
 kernel: scsi host2: bnx2fc: xid:0x42b complete - rx_state = 9
 kernel: scsi host2: bnx2fc: xid:0x42b Entered process_cleanup_compl refcnt = 2, cmd_type = 1
 kernel: scsi host2: bnx2fc: xid:0x42b scsi_done. err_code = 0x7
 kernel: scsi host2: bnx2fc: xid:0x42b sc=ffff8807f93dfb80, result=0x7, retries=0, allowed=5
 kernel: ------------[ cut here ]------------
 kernel: WARNING: at /root/rpmbuild/BUILD/netxtreme2-7.14.43/obj/default/bnx2fc-2.12.1/driver/bnx2fc_io.c:1347 bnx2fc_eh_abort+0x56f/0x680 [bnx2fc]()
 kernel: xid=0x42b refcount=-1
 kernel: Modules linked in:
 kernel: nls_utf8 isofs sr_mod cdrom tcp_lp dm_round_robin xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 tun bridge ebtable_filter ebtables fuse ip6table_filter ip6_tables iptable_filter bnx2fc(OE) cnic(OE) uio fcoe libfcoe 8021q libfc garp mrp scsi_transport_fc stp llc scsi_tgt vfat fat dm_service_time intel_powerclamp coretemp intel_rapl iosf_mbi kvm_intel kvm irqbypass crc32_pclmul ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd ses enclosure ipmi_ssif i2c_core hpilo hpwdt wmi sg ipmi_devintf pcspkr ipmi_si ipmi_msghandler shpchp acpi_power_meter dm_multipath nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs sd_mod crc_t10dif
 kernel: crct10dif_generic bnx2x(OE) crct10dif_pclmul crct10dif_common crc32c_intel mdio ptp pps_core libcrc32c smartpqi scsi_transport_sas fjes uas usb_storage dm_mirror dm_region_hash dm_log dm_mod
 kernel: CPU: 9 PID: 2012 Comm: scsi_eh_2 Tainted: G        W  OE  ------------   3.10.0-514.el7.x86_64 #1
 kernel: Hardware name: HPE Synergy 480 Gen10/Synergy 480 Gen10 Compute Module, BIOS I42 03/21/2018
 kernel: ffff8807f25a3d98 0000000015e7fa0c ffff8807f25a3d50 ffffffff81685eac
 kernel: ffff8807f25a3d88 ffffffff81085820 ffff8807f8e39000 ffff880801ff7468
 kernel: ffff880801ff7610 0000000000002002 ffff8807f8e39014 ffff8807f25a3df0
 kernel: Call Trace:
 kernel: [<ffffffff81685eac>] dump_stack+0x19/0x1b
 kernel: [<ffffffff81085820>] warn_slowpath_common+0x70/0xb0
 kernel: [<ffffffff810858bc>] warn_slowpath_fmt+0x5c/0x80
 kernel: [<ffffffff8168d842>] ? _raw_spin_lock_bh+0x12/0x50
 kernel: [<ffffffffa0549e6f>] bnx2fc_eh_abort+0x56f/0x680 [bnx2fc]
 kernel: [<ffffffff814570af>] scsi_error_handler+0x59f/0x8b0
 kernel: [<ffffffff81456b10>] ? scsi_eh_get_sense+0x250/0x250
 kernel: [<ffffffff810b052f>] kthread+0xcf/0xe0
 kernel: [<ffffffff810b0460>] ? kthread_create_on_node+0x140/0x140
 kernel: [<ffffffff81696418>] ret_from_fork+0x58/0x90
 kernel: [<ffffffff810b0460>] ? kthread_create_on_node+0x140/0x140
 kernel: ---[ end trace 42deb88f2032b111 ]---

The reason that there was a mismatch is that the SCSI command is actual
returned from the cleanup handler.  In previous testing, the type of
cleanup notification we'd get from the CQE did not trigger the code that
returned the SCSI command.  To overcome the previous behavior we would put
a reference in bnx2fc_abts_cleanup() to account for the SCSI command.
However, in cases where the SCSI command is actually off, we end up with an
extra put.

The fix for this is to only take the extra put in bnx2fc_abts_cleanup if
the completion for the cleanup times out.

Signed-off-by: Chad Dupuis <cdupuis@marvell.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index bc9f2a2365f4d..d27cf966e5600 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1098,16 +1098,16 @@ static int bnx2fc_abts_cleanup(struct bnx2fc_cmd *io_req)
 	time_left = wait_for_completion_timeout(&io_req->tm_done,
 						BNX2FC_FW_TIMEOUT);
 	io_req->wait_for_comp = 0;
-	if (!time_left)
+	if (!time_left) {
 		BNX2FC_IO_DBG(io_req, "%s(): Wait for cleanup timed out.\n",
 			      __func__);
 
-	/*
-	 * Release reference held by SCSI command the cleanup completion
-	 * hits the BNX2FC_CLEANUP case in bnx2fc_process_cq_compl() and
-	 * thus the SCSI command is not returnedi by bnx2fc_scsi_done().
-	 */
-	kref_put(&io_req->refcount, bnx2fc_cmd_release);
+		/*
+		 * Put the extra reference to the SCSI command since it would
+		 * not have been returned in this case.
+		 */
+		kref_put(&io_req->refcount, bnx2fc_cmd_release);
+	}
 
 	spin_lock_bh(&tgt->tgt_lock);
 	return rc;
-- 
2.20.1

