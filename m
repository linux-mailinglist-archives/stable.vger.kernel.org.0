Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639A4520C0B
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 05:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235628AbiEJDcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 23:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235831AbiEJDb3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 23:31:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C25F774DD9
        for <stable@vger.kernel.org>; Mon,  9 May 2022 20:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652153232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nUpq+q51eEzVEqJ5wmSXQd0tgNfMLWL9fpZxn4g4jys=;
        b=OgLVXTxYQ4iwshCdcwLb6pq5+i7o1U/zX6EiNEOhfp4LKwX/8X+3rCH5EdHyCt5CS2fHGx
        27007FH09hDUApmXmsIykVslVhH9KUA0CVJqq+B+mg1zdnjlIlrQyKhC9ZPei+FBeWAcu7
        Vomfv2anMOdpeVqC/YoCPf9L7jBqrCA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-52-BHzazZjjPSeThCaR7dudyg-1; Mon, 09 May 2022 23:27:09 -0400
X-MC-Unique: BHzazZjjPSeThCaR7dudyg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93A8E3C11A0D;
        Tue, 10 May 2022 03:27:08 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18A04111E3EC;
        Tue, 10 May 2022 03:27:05 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH] ceph: fix possible NULL pointer dereference of the ci
Date:   Tue, 10 May 2022 11:27:03 +0800
Message-Id: <20220510032703.588333-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When unmounting and if there still have some caps or capsnaps flushing
still not get the acks it will wait and dump them, but for the capsnaps
they didn't initialize the ->ci, so when deferencing the ->ci we will
see the kernel crash:

kernel: ceph: dump_cap_flushes: still waiting for cap flushes through 45572:
kernel: ceph: 5000000008b:fffffffffffffffe Fw 23183 0 0
kernel: ceph: 5000000008a:fffffffffffffffe Fw 23184 0 0
kernel: ceph: 50000000089:fffffffffffffffe Fw 23185 0 0
kernel: ceph: 50000000084:fffffffffffffffe Fw 23189 0 0
kernel: ceph: 5000000007a:fffffffffffffffe Fw 23199 0 0
kernel: ceph: 50000000094:fffffffffffffffe Fw 23374 0 0
kernel: ceph: 50000000092:fffffffffffffffe Fw 23377 0 0
kernel: ceph: 50000000091:fffffffffffffffe Fw 23378 0 0
kernel: ceph: 5000000008e:fffffffffffffffe Fw 23380 0 0
kernel: ceph: 50000000087:fffffffffffffffe Fw 23382 0 0
kernel: ceph: 50000000086:fffffffffffffffe Fw 23383 0 0
kernel: ceph: 50000000083:fffffffffffffffe Fw 23384 0 0
kernel: ceph: 50000000082:fffffffffffffffe Fw 23385 0 0
kernel: ceph: 50000000081:fffffffffffffffe Fw 23386 0 0
kernel: ceph: 50000000080:fffffffffffffffe Fw 23387 0 0
kernel: ceph: 5000000007e:fffffffffffffffe Fw 23389 0 0
kernel: ceph: 5000000007b:fffffffffffffffe Fw 23392 0 0
kernel: BUG: kernel NULL pointer dereference, address: 0000000000000780
kernel: #PF: supervisor read access in kernel mode
kernel: #PF: error_code(0x0000) - not-present page
kernel: PGD 0 P4D 0
kernel: Oops: 0000 [#1] PREEMPT SMP PTI
kernel: CPU: 3 PID: 46268 Comm: umount Tainted: G S                5.18.0-rc2-ceph-g1771083b2f18 #1
kernel: Hardware name: Supermicro SYS-5018R-WR/X10SRW-F, BIOS 2.0 12/17/2015
kernel: RIP: 0010:ceph_mdsc_sync.cold.64+0x77/0xc3 [ceph]
kernel: RSP: 0018:ffffc90009c4fda8 EFLAGS: 00010212
kernel: RAX: 0000000000000000 RBX: ffff8881abf63000 RCX: 0000000000000000
kernel: RDX: 0000000000000000 RSI: ffffffff823932ad RDI: 0000000000000000
kernel: RBP: ffff8881abf634f0 R08: 0000000000005dc7 R09: c0000000ffffdfff
kernel: R10: 0000000000000001 R11: ffffc90009c4fbc8 R12: 0000000000000001
kernel: R13: 000000000000b204 R14: ffffffffa0ab3598 R15: ffff88815d36a110
kernel: FS:  00007f50eb25e080(0000) GS:ffff88885fcc0000(0000) knlGS:0000000000000000
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: CR2: 0000000000000780 CR3: 0000000116ea2003 CR4: 00000000003706e0
kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
kernel: Call Trace:
kernel: <TASK>
kernel: ? schedstat_stop+0x10/0x10
kernel: ceph_sync_fs+0x2c/0x100 [ceph]
kernel: sync_filesystem+0x6d/0x90
kernel: generic_shutdown_super+0x22/0x120
kernel: kill_anon_super+0x14/0x30
kernel: ceph_kill_sb+0x36/0x90 [ceph]
kernel: deactivate_locked_super+0x29/0x60
kernel: cleanup_mnt+0xb8/0x140
kernel: task_work_run+0x6d/0xb0
kernel: exit_to_user_mode_prepare+0x226/0x230
kernel: syscall_exit_to_user_mode+0x25/0x60
kernel: do_syscall_64+0x40/0x80
kernel: entry_SYSCALL_64_after_hwframe+0x44/0xae

Cc: stable@vger.kernel.org
https://tracker.ceph.com/issues/55332
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 5 +++--
 fs/ceph/snap.c       | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 46a13ea9d284..e8c87dea0551 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2001,10 +2001,11 @@ static void dump_cap_flushes(struct ceph_mds_client *mdsc, u64 want_tid)
 	list_for_each_entry(cf, &mdsc->cap_flush_list, g_list) {
 		if (cf->tid > want_tid)
 			break;
-		pr_info("%llx:%llx %s %llu %llu %d\n",
+		pr_info("%llx:%llx %s %llu %llu %d%s\n",
 			ceph_vinop(&cf->ci->vfs_inode),
 			ceph_cap_string(cf->caps), cf->tid,
-			cf->ci->i_last_cap_flush_ack, cf->wake);
+			cf->ci->i_last_cap_flush_ack, cf->wake,
+			cf->is_capsnap ? " is_capsnap" : "");
 	}
 	spin_unlock(&mdsc->cap_dirty_lock);
 }
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 322ee5add942..db1433ce666e 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -585,6 +585,7 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci,
 	     ceph_cap_string(dirty), capsnap->need_flush ? "" : "no_flush");
 	ihold(inode);
 
+	capsnap->cap_flush.ci = ci;
 	capsnap->follows = old_snapc->seq;
 	capsnap->issued = __ceph_caps_issued(ci, NULL);
 	capsnap->dirty = dirty;
-- 
2.36.0.rc1

