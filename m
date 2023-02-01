Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92AEE685C5D
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 01:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbjBAAqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 19:46:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbjBAApl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 19:45:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B6253E55;
        Tue, 31 Jan 2023 16:45:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A64AB81FD1;
        Wed,  1 Feb 2023 00:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D416BC4339C;
        Wed,  1 Feb 2023 00:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675212327;
        bh=X4Sw1lg99gq0n/tEgnu2qBfZh0mxeuXmkyNYPOLrqEQ=;
        h=Date:To:From:Subject:From;
        b=bSjUmUZLn0I4mF/JbnEzoEjR35L/slSlUhkPOQsDp/UFoNyCIgTJcHeTfX1ftLeXT
         szZM1DuvZ+NdfwsMZmur3rZ6AfPJZ3cBGKKppF3kyw4fKWsSPPHhxpV3/vOffhgx9X
         6bcOlFzo+v2C3f4hfs2AxGIeqJthjQ+AmnwFjYtA=
Date:   Tue, 31 Jan 2023 16:45:27 -0800
To:     mm-commits@vger.kernel.org, tj@kernel.org, stable@vger.kernel.org,
        shakeelb@google.com, naoya.horiguchi@nec.com, mikoxyzzz@gmail.com,
        mhocko@suse.com, mawupeng1@huawei.com, jack@suse.cz,
        axboe@kernel.dk, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memcg-fix-null-pointer-in-mem_cgroup_track_foreign_dirty_slowpath.patch removed from -mm tree
Message-Id: <20230201004527.D416BC4339C@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: memcg: fix NULL pointer in mem_cgroup_track_foreign_dirty_slowpath()
has been removed from the -mm tree.  Its filename was
     mm-memcg-fix-null-pointer-in-mem_cgroup_track_foreign_dirty_slowpath.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memcg: fix NULL pointer in mem_cgroup_track_foreign_dirty_slowpath()
Date: Sun, 29 Jan 2023 12:09:45 +0800

As commit 18365225f044 ("hwpoison, memcg: forcibly uncharge LRU pages"),
hwpoison will forcibly uncharg a LRU hwpoisoned page, the folio_memcg
could be NULl, then, mem_cgroup_track_foreign_dirty_slowpath() could
occurs a NULL pointer dereference, let's do not record the foreign
writebacks for folio memcg is null in mem_cgroup_track_foreign_dirty() to
fix it.

Link: https://lkml.kernel.org/r/20230129040945.180629-1-wangkefeng.wang@huawei.com
Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reported-by: Ma Wupeng <mawupeng1@huawei.com>
Tested-by: Miko Larsson <mikoxyzzz@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Ma Wupeng <mawupeng1@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~mm-memcg-fix-null-pointer-in-mem_cgroup_track_foreign_dirty_slowpath
+++ a/include/linux/memcontrol.h
@@ -1666,10 +1666,13 @@ void mem_cgroup_track_foreign_dirty_slow
 static inline void mem_cgroup_track_foreign_dirty(struct folio *folio,
 						  struct bdi_writeback *wb)
 {
+	struct mem_cgroup *memcg;
+
 	if (mem_cgroup_disabled())
 		return;
 
-	if (unlikely(&folio_memcg(folio)->css != wb->memcg_css))
+	memcg = folio_memcg(folio);
+	if (unlikely(memcg && &memcg->css != wb->memcg_css))
 		mem_cgroup_track_foreign_dirty_slowpath(folio, wb);
 }
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch
mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v3.patch
mm-madvise-use-vm_normal_folio-in-madvise_free_pte_range.patch

