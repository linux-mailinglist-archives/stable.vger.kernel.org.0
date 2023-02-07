Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B01C68D1A0
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 09:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbjBGIoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 03:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbjBGIoi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 03:44:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EBD199C6
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 00:44:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 871836121B
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 08:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA6DC433EF;
        Tue,  7 Feb 2023 08:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675759474;
        bh=4RJe0SAgVED2dNSeXs/iQoi2HPQQNsa2QtW5TvON1zk=;
        h=Subject:To:Cc:From:Date:From;
        b=rqYmEdNXS2RdmcxkgZJ1+PN4jFsbIP2DwTd6bxpzopk8HEPAg9/Ge8QzUNy79n5A5
         MatRbi3Em7hPPC/J5YlYlDwqqc7JMHCZKnQvxS1JqiO3Qf9YBTgs7DPCaYAIlDjslc
         P7L9lCd34oqUBwjEJ//USJBmlsmBVMd62W78U6WA=
Subject: FAILED: patch "[PATCH] mm: memcg: fix NULL pointer in" failed to apply to 5.15-stable tree
To:     wangkefeng.wang@huawei.com, akpm@linux-foundation.org,
        axboe@kernel.dk, jack@suse.cz, mawupeng1@huawei.com,
        mhocko@suse.com, mikoxyzzz@gmail.com, naoya.horiguchi@nec.com,
        shakeelb@google.com, stable@vger.kernel.org, tj@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Feb 2023 09:44:31 +0100
Message-ID: <16757594719035@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

ac86f547ca10 ("mm: memcg: fix NULL pointer in mem_cgroup_track_foreign_dirty_slowpath()")
203a31516616 ("mm/writeback: Add __folio_mark_dirty()")
9d8053fc7a21 ("mm/memcg: Convert mem_cgroup_track_foreign_dirty_slowpath() to folio")
a49d0c507759 ("mm/writeback: Add folio_wait_stable()")
490e016f229a ("mm/writeback: Add folio_wait_writeback()")
4268b48077e5 ("mm/filemap: Add folio_end_writeback()")
575ced1c8b0d ("mm/swap: Add folio_rotate_reclaimable()")
4e1364286d0a ("mm/filemap: Add folio_unlock()")
2f52578f9c64 ("mm/util: Add folio_mapping() and folio_file_mapping()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ac86f547ca1002aec2ef66b9e64d03f45bbbfbb9 Mon Sep 17 00:00:00 2001
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Date: Sun, 29 Jan 2023 12:09:45 +0800
Subject: [PATCH] mm: memcg: fix NULL pointer in
 mem_cgroup_track_foreign_dirty_slowpath()

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

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d3c8203cab6c..85dc9b88ea37 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1666,10 +1666,13 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
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
 

