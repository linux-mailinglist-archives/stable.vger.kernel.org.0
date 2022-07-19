Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD553579A1F
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238691AbiGSMK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239095AbiGSMKK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:10:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB24651A30;
        Tue, 19 Jul 2022 05:03:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63ED7B81B25;
        Tue, 19 Jul 2022 12:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B734BC341C6;
        Tue, 19 Jul 2022 12:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232193;
        bh=ooT52oZsc7rbGbyKNG1QdXiXbev9DbiopPUeTRbdqKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yAwvAFoJGvLAqqbLY4Y2Lu/ZSKiv3wIm8zzcCQkfA4JFqbx2pIDehMhKFfCiILF5l
         u24tcbawkcT2YjKIPzrZmSmA7yswFk787YF8GN4dAUKZEnDTSkEd6Kk2PR2sdOmrYN
         NpgeDj8eMZHJCS7Pd0i8oTsKTKfBis6QQeI9C760=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Michal Hocko <mhocko@suse.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 44/71] mm: sysctl: fix missing numa_stat when !CONFIG_HUGETLB_PAGE
Date:   Tue, 19 Jul 2022 13:54:07 +0200
Message-Id: <20220719114556.573182494@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114552.477018590@linuxfoundation.org>
References: <20220719114552.477018590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

[ Upstream commit 43b5240ca6b33108998810593248186b1e3ae34a ]

"numa_stat" should not be included in the scope of CONFIG_HUGETLB_PAGE, if
CONFIG_HUGETLB_PAGE is not configured even if CONFIG_NUMA is configured,
"numa_stat" is missed form /proc. Move it out of CONFIG_HUGETLB_PAGE to
fix it.

Fixes: 4518085e127d ("mm, sysctl: make NUMA stats configurable")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sysctl.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 0457d36540e3..6f971807bf79 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1443,6 +1443,17 @@ static struct ctl_table vm_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &one_hundred,
 	},
+#ifdef CONFIG_NUMA
+	{
+		.procname	= "numa_stat",
+		.data		= &sysctl_vm_numa_stat,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= sysctl_vm_numa_stat_handler,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif
 #ifdef CONFIG_HUGETLB_PAGE
 	{
 		.procname	= "nr_hugepages",
@@ -1459,15 +1470,6 @@ static struct ctl_table vm_table[] = {
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
2.35.1



