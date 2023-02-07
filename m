Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3E5968D82F
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbjBGNHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbjBGNH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:07:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCE76A45
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:06:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35E2A613E2
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A30AC433EF;
        Tue,  7 Feb 2023 13:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775163;
        bh=LjL0IUvyKFfBRJVVBvhcjv3LNCu44CpAtCOpOOH9yCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JXx9id2WSWOmKPgzcFbC2QH422eTDbN3o1TdllmaqBt27odsZSb5dTj3Ti8TlIE0L
         Dtb//e7HJfCSbnuegUbwiu3bYO2azuak+l3ZCcZ+Yb77S+QNI5qnIv839hYxhRNBdP
         pAKX0OYQmT61mxo3+1W0bzW1Od2y/edjZMmx8OUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kefeng Wang <wangkefeng.wang@huawei.com>,
        Ma Wupeng <mawupeng1@huawei.com>,
        Miko Larsson <mikoxyzzz@gmail.com>,
        Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Shakeel Butt <shakeelb@google.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 158/208] mm: memcg: fix NULL pointer in mem_cgroup_track_foreign_dirty_slowpath()
Date:   Tue,  7 Feb 2023 13:56:52 +0100
Message-Id: <20230207125641.605762237@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

commit ac86f547ca1002aec2ef66b9e64d03f45bbbfbb9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/memcontrol.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1655,10 +1655,13 @@ void mem_cgroup_track_foreign_dirty_slow
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
 


