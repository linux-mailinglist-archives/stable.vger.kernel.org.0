Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E335C4ABB87
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376652AbiBGL3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382811AbiBGLUw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:20:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D47C03E90A;
        Mon,  7 Feb 2022 03:20:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1549BB81028;
        Mon,  7 Feb 2022 11:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E227C004E1;
        Mon,  7 Feb 2022 11:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232826;
        bh=jIwfAxVEMGhpnFVreXI7ObayC/K7pZmZBtoSvlANXFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2jzMkgG5Wvn8ETq+aQCSh+xCGG+tQojRvfGXojXMNVY4ELnDfgYaKkZnDmshigR6G
         HrS4FKClV28oRmiTzBFcBwHxlIsFdGbvAIz3Tx5FtOVXJpZaFsY6nVCJedWsBZzOeJ
         gylW4ivFbnkjIUTdiYBof0oFyCYQVdf5SPyzyQRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangwu Zhang <guazhang@redhat.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        John Meneghini <jmeneghi@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 37/44] scsi: bnx2fc: Make bnx2fc_recv_frame() mp safe
Date:   Mon,  7 Feb 2022 12:06:53 +0100
Message-Id: <20220207103754.362566762@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103753.155627314@linuxfoundation.org>
References: <20220207103753.155627314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Meneghini <jmeneghi@redhat.com>

commit 936bd03405fc83ba039d42bc93ffd4b88418f1d3 upstream.

Running tests with a debug kernel shows that bnx2fc_recv_frame() is
modifying the per_cpu lport stats counters in a non-mpsafe way.  Just boot
a debug kernel and run the bnx2fc driver with the hardware enabled.

[ 1391.699147] BUG: using smp_processor_id() in preemptible [00000000] code: bnx2fc_
[ 1391.699160] caller is bnx2fc_recv_frame+0xbf9/0x1760 [bnx2fc]
[ 1391.699174] CPU: 2 PID: 4355 Comm: bnx2fc_l2_threa Kdump: loaded Tainted: G    B
[ 1391.699180] Hardware name: HP ProLiant DL120 G7, BIOS J01 07/01/2013
[ 1391.699183] Call Trace:
[ 1391.699188]  dump_stack_lvl+0x57/0x7d
[ 1391.699198]  check_preemption_disabled+0xc8/0xd0
[ 1391.699205]  bnx2fc_recv_frame+0xbf9/0x1760 [bnx2fc]
[ 1391.699215]  ? do_raw_spin_trylock+0xb5/0x180
[ 1391.699221]  ? bnx2fc_npiv_create_vports.isra.0+0x4e0/0x4e0 [bnx2fc]
[ 1391.699229]  ? bnx2fc_l2_rcv_thread+0xb7/0x3a0 [bnx2fc]
[ 1391.699240]  bnx2fc_l2_rcv_thread+0x1af/0x3a0 [bnx2fc]
[ 1391.699250]  ? bnx2fc_ulp_init+0xc0/0xc0 [bnx2fc]
[ 1391.699258]  kthread+0x364/0x420
[ 1391.699263]  ? _raw_spin_unlock_irq+0x24/0x50
[ 1391.699268]  ? set_kthread_struct+0x100/0x100
[ 1391.699273]  ret_from_fork+0x22/0x30

Restore the old get_cpu/put_cpu code with some modifications to reduce the
size of the critical section.

Link: https://lore.kernel.org/r/20220124145110.442335-1-jmeneghi@redhat.com
Fixes: d576a5e80cd0 ("bnx2fc: Improve stats update mechanism")
Tested-by: Guangwu Zhang <guazhang@redhat.com>
Acked-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -506,7 +506,8 @@ static int bnx2fc_l2_rcv_thread(void *ar
 
 static void bnx2fc_recv_frame(struct sk_buff *skb)
 {
-	u32 fr_len;
+	u64 crc_err;
+	u32 fr_len, fr_crc;
 	struct fc_lport *lport;
 	struct fcoe_rcv_info *fr;
 	struct fc_stats *stats;
@@ -540,6 +541,11 @@ static void bnx2fc_recv_frame(struct sk_
 	skb_pull(skb, sizeof(struct fcoe_hdr));
 	fr_len = skb->len - sizeof(struct fcoe_crc_eof);
 
+	stats = per_cpu_ptr(lport->stats, get_cpu());
+	stats->RxFrames++;
+	stats->RxWords += fr_len / FCOE_WORD_TO_BYTE;
+	put_cpu();
+
 	fp = (struct fc_frame *)skb;
 	fc_frame_init(fp);
 	fr_dev(fp) = lport;
@@ -622,16 +628,15 @@ static void bnx2fc_recv_frame(struct sk_
 		return;
 	}
 
-	stats = per_cpu_ptr(lport->stats, smp_processor_id());
-	stats->RxFrames++;
-	stats->RxWords += fr_len / FCOE_WORD_TO_BYTE;
+	fr_crc = le32_to_cpu(fr_crc(fp));
 
-	if (le32_to_cpu(fr_crc(fp)) !=
-			~crc32(~0, skb->data, fr_len)) {
-		if (stats->InvalidCRCCount < 5)
+	if (unlikely(fr_crc != ~crc32(~0, skb->data, fr_len))) {
+		stats = per_cpu_ptr(lport->stats, get_cpu());
+		crc_err = (stats->InvalidCRCCount++);
+		put_cpu();
+		if (crc_err < 5)
 			printk(KERN_WARNING PFX "dropping frame with "
 			       "CRC error\n");
-		stats->InvalidCRCCount++;
 		kfree_skb(skb);
 		return;
 	}


