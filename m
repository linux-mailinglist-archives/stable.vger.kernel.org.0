Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2DF9544670
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 10:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbiFIIuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 04:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242176AbiFIIuI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 04:50:08 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31AD427B984;
        Thu,  9 Jun 2022 01:45:59 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 9AFD2218B0;
        Thu,  9 Jun 2022 08:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654764357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FvavTNx1f/0HsDobph2sXPyYgU5o7YbYGNlwn/kaUwk=;
        b=fD5Fv6UEhOehsMLElIPAGFa9Y8wFPPOucJgXizP2FtZqJT90k/SgyoBqzfdDsSG2m3H8oZ
        PrjRPp9zwLE7Hq22Skw4TDnOKbNaX/SQmy3OEB3gcqiT5UB9Md1SeKfDor35St3W1JTT67
        fm3AS7I0f6Ba1JoGwfWmPey6MJ7CPbY=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 395B22C141;
        Thu,  9 Jun 2022 08:45:56 +0000 (UTC)
Date:   Thu, 9 Jun 2022 10:45:56 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     mcgrof@kernel.org, keescook@chromium.org, yzaikin@google.com,
        akpm@linux-foundation.org, vbabka@suse.cz,
        mgorman@techsingularity.net, peterz@infradead.org,
        dhowells@redhat.com, willy@infradead.org, Liam.Howlett@oracle.com,
        kemi.wang@intel.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm: sysctl: fix missing numa_stat when
 !CONFIG_HUGETLB_PAGE
Message-ID: <YqGzRNnkZIHgx/OM@dhcp22.suse.cz>
References: <20220609040342.2703-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220609040342.2703-1-songmuchun@bytedance.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 09-06-22 12:03:42, Muchun Song wrote:
> "numa_stat" should not be included in the scope of CONFIG_HUGETLB_PAGE,
> if CONFIG_HUGETLB_PAGE is not configured even if CONFIG_NUMA is configured,
> "numa_stat" is missed form /proc.  Remove it out of CONFIG_HUGETLB_PAGE
> and move numa_stat sysctl handling to mm/vmstat.c.
> 
> Fixes: 4518085e127d ("mm, sysctl: make NUMA stats configurable")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Cc: <stable@vger.kernel.org>

It really looks like numa_stat is misplaced but I am wondering why the
fix cannot be as simple as

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 830aaf8ca08e..b9c2cd9ed3a2 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2463,6 +2463,17 @@ static struct ctl_table vm_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_TWO_HUNDRED,
 	},
+#ifdef CONFIG_NUMA
+	{
+		.procname		= "numa_stat",
+		.data			= &sysctl_vm_numa_stat,
+		.maxlen			= sizeof(int),
+		.mode			= 0644,
+		.proc_handler	= sysctl_vm_numa_stat_handler,
+		.extra1			= SYSCTL_ZERO,
+		.extra2			= SYSCTL_ONE,
+	},
+#endif
 #ifdef CONFIG_HUGETLB_PAGE
 	{
 		.procname	= "nr_hugepages",
@@ -2479,15 +2490,6 @@ static struct ctl_table vm_table[] = {
 		.mode           = 0644,
 		.proc_handler   = &hugetlb_mempolicy_sysctl_handler,
 	},
-	{
-		.procname		= "numa_stat",
-		.data			= &sysctl_vm_numa_stat,
-		.maxlen			= sizeof(int),
-		.mode			= 0644,
-		.proc_handler	= sysctl_vm_numa_stat_handler,
-		.extra1			= SYSCTL_ZERO,
-		.extra2			= SYSCTL_ONE,
-	},
 #endif
 	 {
 		.procname	= "hugetlb_shm_group",
-- 
Michal Hocko
SUSE Labs
