Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD00E4EEAC4
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 11:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344794AbiDAJz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 05:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244173AbiDAJz4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 05:55:56 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DA4146B57;
        Fri,  1 Apr 2022 02:54:02 -0700 (PDT)
Received: from kwepemi500014.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KVFnw6vckzgY8Z;
        Fri,  1 Apr 2022 17:52:20 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi500014.china.huawei.com (7.221.188.232) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 1 Apr 2022 17:54:00 +0800
Received: from localhost.localdomain (10.175.112.125) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 1 Apr 2022 17:54:00 +0800
From:   Peng Liu <liupeng256@huawei.com>
To:     <mike.kravetz@oracle.com>, <akpm@linux-foundation.org>,
        <yaozhenguo1@gmail.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
CC:     <liupeng256@huawei.com>
Subject: [PATCH v2 1/2] hugetlb: Fix hugepages_setup when deal with pernode
Date:   Fri, 1 Apr 2022 10:12:31 +0000
Message-ID: <20220401101232.2790280-2-liupeng256@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
In-Reply-To: <20220401101232.2790280-1-liupeng256@huawei.com>
References: <20220401101232.2790280-1-liupeng256@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hugepages can be specified to pernode since "hugetlbfs: extend
the definition of hugepages parameter to support node allocation",
but the following problem is observed.

Confusing behavior is observed when both 1G and 2M hugepage is set
after "numa=off".
 cmdline hugepage settings:
  hugepagesz=1G hugepages=0:3,1:3
  hugepagesz=2M hugepages=0:1024,1:1024
 results:
  HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
  HugeTLB registered 2.00 MiB page size, pre-allocated 1024 pages

Furthermore, confusing behavior can be also observed when invalid
node behind valid node.

To fix this, hugetlb_hstate_alloc_pages should be called even when
hugepages_setup going to invalid.

Cc: <stable@vger.kernel.org>
Fixes: b5389086ad7b ("hugetlbfs: extend the definition of hugepages parameter to support node allocation")
Signed-off-by: Peng Liu <liupeng256@huawei.com>
---
 mm/hugetlb.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b34f50156f7e..9cd746432ca9 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4131,6 +4131,7 @@ static int __init hugepages_setup(char *s)
 	int count;
 	unsigned long tmp;
 	char *p = s;
+	int ret = 1;
 
 	if (!parsed_valid_hugepagesz) {
 		pr_warn("HugeTLB: hugepages=%s does not follow a valid hugepagesz, ignoring\n", s);
@@ -4189,6 +4190,7 @@ static int __init hugepages_setup(char *s)
 		}
 	}
 
+out:
 	/*
 	 * Global state is always initialized later in hugetlb_init.
 	 * But we need to allocate gigantic hstates here early to still
@@ -4199,11 +4201,12 @@ static int __init hugepages_setup(char *s)
 
 	last_mhp = mhp;
 
-	return 1;
+	return ret;
 
 invalid:
 	pr_warn("HugeTLB: Invalid hugepages parameter %s\n", p);
-	return 0;
+	ret = 0;
+	goto out;
 }
 __setup("hugepages=", hugepages_setup);
 
-- 
2.18.0.huawei.25

