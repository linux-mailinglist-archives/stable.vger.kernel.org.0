Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D73063DFFD
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbiK3Swt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbiK3SwX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:52:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A952FA3225
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:52:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CE93B81CA9
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA109C433D6;
        Wed, 30 Nov 2022 18:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834340;
        bh=YDrjMdH5rSQYcDqKtDE6mnnLUWZkTUoWFVA7oM54EwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SRGXWsI+5hugFAr12zk8MnZwuoMqCBgffZLophUSn+qX2oHqchfJHk19JuSEEqzB2
         Oy3BVcju7z0oRfyhMJibPmTrqBJmDBg/Q1qXatdJAvEAEDxz3gfo5A4re8lCXcqiW8
         jpjqleC2HGqvf/g7ZZXX/1M/5AT0k7dSorpQwYSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Liguang <liliguang@baidu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Michal Hocko <mhocko@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 217/289] mm: correctly charge compressed memory to its memcg
Date:   Wed, 30 Nov 2022 19:23:22 +0100
Message-Id: <20221130180549.038053487@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Liguang <liliguang@baidu.com>

commit cd08d80ecdac577bad2e8d6805c7a3859fdefb8d upstream.

Kswapd will reclaim memory when memory pressure is high, the annonymous
memory will be compressed and stored in the zpool if zswap is enabled.
The memcg_kmem_bypass() in get_obj_cgroup_from_page() will bypass the
kernel thread and cause the compressed memory not be charged to its memory
cgroup.

Remove the memcg_kmem_bypass() call and properly charge compressed memory
to its corresponding memory cgroup.

Link: https://lore.kernel.org/linux-mm/CALvZod4nnn8BHYqAM4xtcR0Ddo2-Wr8uKm9h_CHWUaXw7g_DCg@mail.gmail.com/
Link: https://lkml.kernel.org/r/20221114194828.100822-1-hannes@cmpxchg.org
Fixes: f4840ccfca25 ("zswap: memcg accounting")
Signed-off-by: Li Liguang <liliguang@baidu.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>	[5.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2971,7 +2971,7 @@ struct obj_cgroup *get_obj_cgroup_from_p
 {
 	struct obj_cgroup *objcg;
 
-	if (!memcg_kmem_enabled() || memcg_kmem_bypass())
+	if (!memcg_kmem_enabled())
 		return NULL;
 
 	if (PageMemcgKmem(page)) {


