Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D485B7159
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbiIMOmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbiIMOla (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:41:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985E06DAD7;
        Tue, 13 Sep 2022 07:22:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1151614C5;
        Tue, 13 Sep 2022 14:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE25C433C1;
        Tue, 13 Sep 2022 14:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078489;
        bh=4w9IJ5p0KIo2cCqtVwVOaTjqIDbKYOmulQrGy6TtSQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wLLKLjR56mSz9znjdslPdla4llHbsqSyAvP7oWc8Tbu3M+HpSR5ls89JEMmKvtPUe
         X29jyoG92ifoUUlK91Re4YWeEbA7e92CANv6x39KiZxkkOoc7ehqIogNuti2WkhA72
         a/xFwev/5MxkXgt1pH1bjZdwwxL6YiooPiMQu870=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yue Hu <huyue2@coolpad.com>,
        Chao Yu <chao@kernel.org>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 134/192] erofs: fix pcluster use-after-free on UP platforms
Date:   Tue, 13 Sep 2022 16:04:00 +0200
Message-Id: <20220913140416.687857176@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 2f44013e39984c127c6efedf70e6b5f4e9dcf315 ]

During stress testing with CONFIG_SMP disabled, KASAN reports as below:

==================================================================
BUG: KASAN: use-after-free in __mutex_lock+0xe5/0xc30
Read of size 8 at addr ffff8881094223f8 by task stress/7789

CPU: 0 PID: 7789 Comm: stress Not tainted 6.0.0-rc1-00002-g0d53d2e882f9 #3
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Call Trace:
 <TASK>
..
 __mutex_lock+0xe5/0xc30
..
 z_erofs_do_read_page+0x8ce/0x1560
..
 z_erofs_readahead+0x31c/0x580
..
Freed by task 7787
 kasan_save_stack+0x1e/0x40
 kasan_set_track+0x20/0x30
 kasan_set_free_info+0x20/0x40
 __kasan_slab_free+0x10c/0x190
 kmem_cache_free+0xed/0x380
 rcu_core+0x3d5/0xc90
 __do_softirq+0x12d/0x389

Last potentially related work creation:
 kasan_save_stack+0x1e/0x40
 __kasan_record_aux_stack+0x97/0xb0
 call_rcu+0x3d/0x3f0
 erofs_shrink_workstation+0x11f/0x210
 erofs_shrink_scan+0xdc/0x170
 shrink_slab.constprop.0+0x296/0x530
 drop_slab+0x1c/0x70
 drop_caches_sysctl_handler+0x70/0x80
 proc_sys_call_handler+0x20a/0x2f0
 vfs_write+0x555/0x6c0
 ksys_write+0xbe/0x160
 do_syscall_64+0x3b/0x90

The root cause is that erofs_workgroup_unfreeze() doesn't reset to
orig_val thus it causes a race that the pcluster reuses unexpectedly
before freeing.

Since UP platforms are quite rare now, such path becomes unnecessary.
Let's drop such specific-designed path directly instead.

Fixes: 73f5c66df3e2 ("staging: erofs: fix `erofs_workgroup_{try_to_freeze, unfreeze}'")
Reviewed-by: Yue Hu <huyue2@coolpad.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20220902045710.109530-1-hsiangkao@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/internal.h | 29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index cfee49d33b95a..a01cc82795a25 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -195,7 +195,6 @@ struct erofs_workgroup {
 	atomic_t refcount;
 };
 
-#if defined(CONFIG_SMP)
 static inline bool erofs_workgroup_try_to_freeze(struct erofs_workgroup *grp,
 						 int val)
 {
@@ -224,34 +223,6 @@ static inline int erofs_wait_on_workgroup_freezed(struct erofs_workgroup *grp)
 	return atomic_cond_read_relaxed(&grp->refcount,
 					VAL != EROFS_LOCKED_MAGIC);
 }
-#else
-static inline bool erofs_workgroup_try_to_freeze(struct erofs_workgroup *grp,
-						 int val)
-{
-	preempt_disable();
-	/* no need to spin on UP platforms, let's just disable preemption. */
-	if (val != atomic_read(&grp->refcount)) {
-		preempt_enable();
-		return false;
-	}
-	return true;
-}
-
-static inline void erofs_workgroup_unfreeze(struct erofs_workgroup *grp,
-					    int orig_val)
-{
-	preempt_enable();
-}
-
-static inline int erofs_wait_on_workgroup_freezed(struct erofs_workgroup *grp)
-{
-	int v = atomic_read(&grp->refcount);
-
-	/* workgroup is never freezed on uniprocessor systems */
-	DBG_BUGON(v == EROFS_LOCKED_MAGIC);
-	return v;
-}
-#endif	/* !CONFIG_SMP */
 #endif	/* !CONFIG_EROFS_FS_ZIP */
 
 /* we strictly follow PAGE_SIZE and no buffer head yet */
-- 
2.35.1



