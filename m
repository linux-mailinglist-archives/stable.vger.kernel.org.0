Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7126AECE8
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjCGR7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:59:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbjCGR66 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:58:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1C88C838
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:53:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C7C761526
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 532F5C433D2;
        Tue,  7 Mar 2023 17:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211591;
        bh=M7lKYZFY7LZpPsVC8cmH4es1NYqClKPkG9ohnWy+nfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Umy7vLGeN/HA8KkTsyf3Om7FcWfkdd+ikRXc1A5AVVchCavb+XylIivj0M74jIp1O
         ocAQDjKbXkNUxsRuFGnpfXikWobm0YTRRSCdVbJRbG+TxD6wov48kBEKwIP1f5k1pc
         YMqaN7IRskMkIecVmnO+AVjJbmj80SA1PcGLDtqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Benjamin Marzinski <bmarzins@redhat.com>,
        Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.2 0912/1001] dm cache: free background trackers queued work in btracker_destroy
Date:   Tue,  7 Mar 2023 18:01:24 +0100
Message-Id: <20230307170101.613748245@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Thornber <ejt@redhat.com>

commit 95ab80a8a0fef2ce0cc494a306dd283948066ce7 upstream.

Otherwise the kernel can BUG with:

[ 2245.426978] =============================================================================
[ 2245.435155] BUG bt_work (Tainted: G    B   W         ): Objects remaining in bt_work on __kmem_cache_shutdown()
[ 2245.445233] -----------------------------------------------------------------------------
[ 2245.445233]
[ 2245.454879] Slab 0x00000000b0ce2b30 objects=64 used=2 fp=0x000000000a3c6a4e flags=0x17ffffc0000200(slab|node=0|zone=2|lastcpupid=0x1fffff)
[ 2245.467300] CPU: 7 PID: 10805 Comm: lvm Kdump: loaded Tainted: G    B   W          6.0.0-rc2 #19
[ 2245.476078] Hardware name: Dell Inc. PowerEdge R7525/0590KW, BIOS 2.5.6 10/06/2021
[ 2245.483646] Call Trace:
[ 2245.486100]  <TASK>
[ 2245.488206]  dump_stack_lvl+0x34/0x48
[ 2245.491878]  slab_err+0x95/0xcd
[ 2245.495028]  __kmem_cache_shutdown.cold+0x31/0x136
[ 2245.499821]  kmem_cache_destroy+0x49/0x130
[ 2245.503928]  btracker_destroy+0x12/0x20 [dm_cache]
[ 2245.508728]  smq_destroy+0x15/0x60 [dm_cache_smq]
[ 2245.513435]  dm_cache_policy_destroy+0x12/0x20 [dm_cache]
[ 2245.518834]  destroy+0xc0/0x110 [dm_cache]
[ 2245.522933]  dm_table_destroy+0x5c/0x120 [dm_mod]
[ 2245.527649]  __dm_destroy+0x10e/0x1c0 [dm_mod]
[ 2245.532102]  dev_remove+0x117/0x190 [dm_mod]
[ 2245.536384]  ctl_ioctl+0x1a2/0x290 [dm_mod]
[ 2245.540579]  dm_ctl_ioctl+0xa/0x20 [dm_mod]
[ 2245.544773]  __x64_sys_ioctl+0x8a/0xc0
[ 2245.548524]  do_syscall_64+0x5c/0x90
[ 2245.552104]  ? syscall_exit_to_user_mode+0x12/0x30
[ 2245.556897]  ? do_syscall_64+0x69/0x90
[ 2245.560648]  ? do_syscall_64+0x69/0x90
[ 2245.564394]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[ 2245.569447] RIP: 0033:0x7fe52583ec6b
...
[ 2245.646771] ------------[ cut here ]------------
[ 2245.651395] kmem_cache_destroy bt_work: Slab cache still has objects when called from btracker_destroy+0x12/0x20 [dm_cache]
[ 2245.651408] WARNING: CPU: 7 PID: 10805 at mm/slab_common.c:478 kmem_cache_destroy+0x128/0x130

Found using: lvm2-testsuite --only "cache-single-split.sh"

Ben bisected and found that commit 0495e337b703 ("mm/slab_common:
Deleting kobject in kmem_cache_destroy() without holding
slab_mutex/cpu_hotplug_lock") first exposed dm-cache's incomplete
cleanup of its background tracker work objects.

Reported-by: Benjamin Marzinski <bmarzins@redhat.com>
Tested-by: Benjamin Marzinski <bmarzins@redhat.com>
Cc: stable@vger.kernel.org # 6.0+
Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-cache-background-tracker.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/md/dm-cache-background-tracker.c
+++ b/drivers/md/dm-cache-background-tracker.c
@@ -60,6 +60,14 @@ EXPORT_SYMBOL_GPL(btracker_create);
 
 void btracker_destroy(struct background_tracker *b)
 {
+	struct bt_work *w, *tmp;
+
+	BUG_ON(!list_empty(&b->issued));
+	list_for_each_entry_safe (w, tmp, &b->queued, list) {
+		list_del(&w->list);
+		kmem_cache_free(b->work_cache, w);
+	}
+
 	kmem_cache_destroy(b->work_cache);
 	kfree(b);
 }


