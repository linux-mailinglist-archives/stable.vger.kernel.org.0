Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 103A468D82E
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbjBGNH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbjBGNH2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:07:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A495FF7
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:06:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 820406141D
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D309C433EF;
        Tue,  7 Feb 2023 13:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775157;
        bh=49eVP3VvglhYDyZ+MybjCp1gHpBrluq4dXb3TC50YQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kUnqZYsLiBItl3Yg0d57KTdUdybS+AGOLe461aSoqAWEIMRkHYTj8VcRboRoLwzz4
         jizKV0FeKcqUOWTPz6q7mPejfvIyqJwFlIs3e5/7Isv+hvvcZ5QO/Rd8kLjGfFvJ+B
         0KedBIzvr5nM3RAeVzSgy5rTFwc5jPPOLEmtEp90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yu Zhao <yuzhao@google.com>,
        msizanoen <msizanoen@qtmlabs.xyz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 156/208] mm: multi-gen LRU: fix crash during cgroup migration
Date:   Tue,  7 Feb 2023 13:56:50 +0100
Message-Id: <20230207125641.519933289@linuxfoundation.org>
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

From: Yu Zhao <yuzhao@google.com>

commit de08eaa6156405f2e9369f06ba5afae0e4ab3b62 upstream.

lru_gen_migrate_mm() assumes lru_gen_add_mm() runs prior to itself.  This
isn't true for the following scenario:

    CPU 1                         CPU 2

  clone()
    cgroup_can_fork()
                                cgroup_procs_write()
    cgroup_post_fork()
                                  task_lock()
                                  lru_gen_migrate_mm()
                                  task_unlock()
    task_lock()
    lru_gen_add_mm()
    task_unlock()

And when the above happens, kernel crashes because of linked list
corruption (mm_struct->lru_gen.list).

Link: https://lore.kernel.org/r/20230115134651.30028-1-msizanoen@qtmlabs.xyz/
Link: https://lkml.kernel.org/r/20230116034405.2960276-1-yuzhao@google.com
Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: msizanoen <msizanoen@qtmlabs.xyz>
Tested-by: msizanoen <msizanoen@qtmlabs.xyz>
Cc: <stable@vger.kernel.org>	[6.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmscan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3290,13 +3290,16 @@ void lru_gen_migrate_mm(struct mm_struct
 	if (mem_cgroup_disabled())
 		return;
 
+	/* migration can happen before addition */
+	if (!mm->lru_gen.memcg)
+		return;
+
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(task);
 	rcu_read_unlock();
 	if (memcg == mm->lru_gen.memcg)
 		return;
 
-	VM_WARN_ON_ONCE(!mm->lru_gen.memcg);
 	VM_WARN_ON_ONCE(list_empty(&mm->lru_gen.list));
 
 	lru_gen_del_mm(mm);


