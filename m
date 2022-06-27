Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A796A55D013
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236465AbiF0Lid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236563AbiF0Lhl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:37:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D58165A4;
        Mon, 27 Jun 2022 04:34:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8678B8111C;
        Mon, 27 Jun 2022 11:34:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3737DC36AE5;
        Mon, 27 Jun 2022 11:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329642;
        bh=6Fo1wAyr7tO5qRk4E8yu6RNuC6CD3MimmdsEmLbqlU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRaE5u843kt/w+xSdKG0Z5rzlN9BbjiCO0p5SIBhYhgZ6FfEQJehLxq9Sck4WmBU1
         jGhKyBIhQfQS8XC7rD98sUdmPIGb2Qq2eU6dc7GmETMCj0UFRMWI5Qr3cNFLDNfzq7
         DZJKe/9NYC4XO8URTKcpyj/2DF7NIZMd+EOBazs4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>,
        Jason Andryuk <jandryuk@gmail.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 065/135] xen-blkfront: Handle NULL gendisk
Date:   Mon, 27 Jun 2022 13:21:12 +0200
Message-Id: <20220627111940.044327188@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Andryuk <jandryuk@gmail.com>

[ Upstream commit f9710c357e5bbf64d7ce45ba0bc75a52222491c1 ]

When a VBD is not fully created and then closed, the kernel can have a
NULL pointer dereference:

The reproducer is trivial:

[user@dom0 ~]$ sudo xl block-attach work backend=sys-usb vdev=xvdi target=/dev/sdz
[user@dom0 ~]$ xl block-list work
Vdev  BE  handle state evt-ch ring-ref BE-path
51712 0   241    4     -1     -1       /local/domain/0/backend/vbd/241/51712
51728 0   241    4     -1     -1       /local/domain/0/backend/vbd/241/51728
51744 0   241    4     -1     -1       /local/domain/0/backend/vbd/241/51744
51760 0   241    4     -1     -1       /local/domain/0/backend/vbd/241/51760
51840 3   241    3     -1     -1       /local/domain/3/backend/vbd/241/51840
                 ^ note state, the /dev/sdz doesn't exist in the backend

[user@dom0 ~]$ sudo xl block-detach work xvdi
[user@dom0 ~]$ xl block-list work
Vdev  BE  handle state evt-ch ring-ref BE-path
work is an invalid domain identifier

And its console has:

BUG: kernel NULL pointer dereference, address: 0000000000000050
PGD 80000000edebb067 P4D 80000000edebb067 PUD edec2067 PMD 0
Oops: 0000 [#1] PREEMPT SMP PTI
CPU: 1 PID: 52 Comm: xenwatch Not tainted 5.16.18-2.43.fc32.qubes.x86_64 #1
RIP: 0010:blk_mq_stop_hw_queues+0x5/0x40
Code: 00 48 83 e0 fd 83 c3 01 48 89 85 a8 00 00 00 41 39 5c 24 50 77 c0 5b 5d 41 5c 41 5d c3 c3 0f 1f 80 00 00 00 00 0f 1f 44 00 00 <8b> 47 50 85 c0 74 32 41 54 49 89 fc 55 53 31 db 49 8b 44 24 48 48
RSP: 0018:ffffc90000bcfe98 EFLAGS: 00010293
RAX: ffffffffc0008370 RBX: 0000000000000005 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000005 RDI: 0000000000000000
RBP: ffff88800775f000 R08: 0000000000000001 R09: ffff888006e620b8
R10: ffff888006e620b0 R11: f000000000000000 R12: ffff8880bff39000
R13: ffff8880bff39000 R14: 0000000000000000 R15: ffff88800604be00
FS:  0000000000000000(0000) GS:ffff8880f3300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000050 CR3: 00000000e932e002 CR4: 00000000003706e0
Call Trace:
 <TASK>
 blkback_changed+0x95/0x137 [xen_blkfront]
 ? read_reply+0x160/0x160
 xenwatch_thread+0xc0/0x1a0
 ? do_wait_intr_irq+0xa0/0xa0
 kthread+0x16b/0x190
 ? set_kthread_struct+0x40/0x40
 ret_from_fork+0x22/0x30
 </TASK>
Modules linked in: snd_seq_dummy snd_hrtimer snd_seq snd_seq_device snd_timer snd soundcore ipt_REJECT nf_reject_ipv4 xt_state xt_conntrack nft_counter nft_chain_nat xt_MASQUERADE nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nft_compat nf_tables nfnetlink intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel xen_netfront pcspkr xen_scsiback target_core_mod xen_netback xen_privcmd xen_gntdev xen_gntalloc xen_blkback xen_evtchn ipmi_devintf ipmi_msghandler fuse bpf_preload ip_tables overlay xen_blkfront
CR2: 0000000000000050
---[ end trace 7bc9597fd06ae89d ]---
RIP: 0010:blk_mq_stop_hw_queues+0x5/0x40
Code: 00 48 83 e0 fd 83 c3 01 48 89 85 a8 00 00 00 41 39 5c 24 50 77 c0 5b 5d 41 5c 41 5d c3 c3 0f 1f 80 00 00 00 00 0f 1f 44 00 00 <8b> 47 50 85 c0 74 32 41 54 49 89 fc 55 53 31 db 49 8b 44 24 48 48
RSP: 0018:ffffc90000bcfe98 EFLAGS: 00010293
RAX: ffffffffc0008370 RBX: 0000000000000005 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000005 RDI: 0000000000000000
RBP: ffff88800775f000 R08: 0000000000000001 R09: ffff888006e620b8
R10: ffff888006e620b0 R11: f000000000000000 R12: ffff8880bff39000
R13: ffff8880bff39000 R14: 0000000000000000 R15: ffff88800604be00
FS:  0000000000000000(0000) GS:ffff8880f3300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000050 CR3: 00000000e932e002 CR4: 00000000003706e0
Kernel panic - not syncing: Fatal exception
Kernel Offset: disabled

info->rq and info->gd are only set in blkfront_connect(), which is
called for state 4 (XenbusStateConnected).  Guard against using NULL
variables in blkfront_closing() to avoid the issue.

The rest of blkfront_closing looks okay.  If info->nr_rings is 0, then
for_each_rinfo won't do anything.

blkfront_remove also needs to check for non-NULL pointers before
cleaning up the gendisk and request queue.

Fixes: 05d69d950d9d "xen-blkfront: sanitize the removal state machine"
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20220601195341.28581-1-jandryuk@gmail.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/xen-blkfront.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 390817cf1221..d7a9bf43fb32 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2140,9 +2140,11 @@ static void blkfront_closing(struct blkfront_info *info)
 		return;
 
 	/* No more blkif_request(). */
-	blk_mq_stop_hw_queues(info->rq);
-	blk_mark_disk_dead(info->gd);
-	set_capacity(info->gd, 0);
+	if (info->rq && info->gd) {
+		blk_mq_stop_hw_queues(info->rq);
+		blk_mark_disk_dead(info->gd);
+		set_capacity(info->gd, 0);
+	}
 
 	for_each_rinfo(info, rinfo, i) {
 		/* No more gnttab callback work. */
@@ -2478,16 +2480,19 @@ static int blkfront_remove(struct xenbus_device *xbdev)
 
 	dev_dbg(&xbdev->dev, "%s removed", xbdev->nodename);
 
-	del_gendisk(info->gd);
+	if (info->gd)
+		del_gendisk(info->gd);
 
 	mutex_lock(&blkfront_mutex);
 	list_del(&info->info_list);
 	mutex_unlock(&blkfront_mutex);
 
 	blkif_free(info, 0);
-	xlbd_release_minors(info->gd->first_minor, info->gd->minors);
-	blk_cleanup_disk(info->gd);
-	blk_mq_free_tag_set(&info->tag_set);
+	if (info->gd) {
+		xlbd_release_minors(info->gd->first_minor, info->gd->minors);
+		blk_cleanup_disk(info->gd);
+		blk_mq_free_tag_set(&info->tag_set);
+	}
 
 	kfree(info);
 	return 0;
-- 
2.35.1



