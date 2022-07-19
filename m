Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61BB5579E52
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242618AbiGSNBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242806AbiGSM7i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:59:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBB363CD;
        Tue, 19 Jul 2022 05:25:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C60F0B81B21;
        Tue, 19 Jul 2022 12:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B822C341D8;
        Tue, 19 Jul 2022 12:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233506;
        bh=8eWx/eELbvZZCIShRKaxQ1ohRxKtl/umDcePQo0ppBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z2yRs+lok2gKHp6N5s02bP4UyOa8f7vDuAGlRQ/TXyxqelZm2r6llllPJW0UGZe0A
         UmaW0KpfcH68JfUxWYXhN8ttVk6Lnb5iDkDaZ1n1al4OvJpK9un4aUz313S7ojmNWQ
         h3jy5+zbiPBALYpibYasyungjrcZwYKk2peiqWHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Michal Hocko <mhocko@suse.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 144/231] mm: sysctl: fix missing numa_stat when !CONFIG_HUGETLB_PAGE
Date:   Tue, 19 Jul 2022 13:53:49 +0200
Message-Id: <20220719114726.478705779@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
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
index f165ea67dd33..c42ba2d669dc 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2466,6 +2466,17 @@ static struct ctl_table vm_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_TWO_HUNDRED,
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
@@ -2482,15 +2493,6 @@ static struct ctl_table vm_table[] = {
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



