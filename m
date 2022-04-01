Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C57274EEAC2
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 11:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344797AbiDAJz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 05:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344787AbiDAJz4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 05:55:56 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33EFF105AAE;
        Fri,  1 Apr 2022 02:54:03 -0700 (PDT)
Received: from kwepemi500017.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KVFqT2nVqzdZLt;
        Fri,  1 Apr 2022 17:53:41 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi500017.china.huawei.com (7.221.188.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 1 Apr 2022 17:54:01 +0800
Received: from localhost.localdomain (10.175.112.125) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 1 Apr 2022 17:54:00 +0800
From:   Peng Liu <liupeng256@huawei.com>
To:     <mike.kravetz@oracle.com>, <akpm@linux-foundation.org>,
        <yaozhenguo1@gmail.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
CC:     <liupeng256@huawei.com>
Subject: [PATCH v2 2/2] hugetlb: Fix return value of __setup handlers
Date:   Fri, 1 Apr 2022 10:12:32 +0000
Message-ID: <20220401101232.2790280-3-liupeng256@huawei.com>
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

When __setup() return '0', using invalid option values causes the
entire kernel boot option string to be reported as Unknown. Hugetlb
calls __setup() and will return '0' when set invalid parameter
string.

The following phenomenon is observed:
 cmdline:
  hugepagesz=1Y hugepages=1
 dmesg:
  HugeTLB: unsupported hugepagesz=1Y
  HugeTLB: hugepages=1 does not follow a valid hugepagesz, ignoring
  Unknown kernel command line parameters "hugepagesz=1Y hugepages=1"

Since hugetlb will print warn or error information before return for
invalid parameter string, just use return '1' to avoid print again.

Signed-off-by: Peng Liu <liupeng256@huawei.com>
---
 mm/hugetlb.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 9cd746432ca9..6dde34c115c9 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4131,12 +4131,11 @@ static int __init hugepages_setup(char *s)
 	int count;
 	unsigned long tmp;
 	char *p = s;
-	int ret = 1;
 
 	if (!parsed_valid_hugepagesz) {
 		pr_warn("HugeTLB: hugepages=%s does not follow a valid hugepagesz, ignoring\n", s);
 		parsed_valid_hugepagesz = true;
-		return 0;
+		return 1;
 	}
 
 	/*
@@ -4152,7 +4151,7 @@ static int __init hugepages_setup(char *s)
 
 	if (mhp == last_mhp) {
 		pr_warn("HugeTLB: hugepages= specified twice without interleaving hugepagesz=, ignoring hugepages=%s\n", s);
-		return 0;
+		return 1;
 	}
 
 	while (*p) {
@@ -4163,7 +4162,7 @@ static int __init hugepages_setup(char *s)
 		if (p[count] == ':') {
 			if (!hugetlb_node_alloc_supported()) {
 				pr_warn("HugeTLB: architecture can't support node specific alloc, ignoring!\n");
-				return 0;
+				return 1;
 			}
 			if (tmp >= nr_online_nodes)
 				goto invalid;
@@ -4201,11 +4200,10 @@ static int __init hugepages_setup(char *s)
 
 	last_mhp = mhp;
 
-	return ret;
+	return 1;
 
 invalid:
 	pr_warn("HugeTLB: Invalid hugepages parameter %s\n", p);
-	ret = 0;
 	goto out;
 }
 __setup("hugepages=", hugepages_setup);
@@ -4227,7 +4225,7 @@ static int __init hugepagesz_setup(char *s)
 
 	if (!arch_hugetlb_valid_size(size)) {
 		pr_err("HugeTLB: unsupported hugepagesz=%s\n", s);
-		return 0;
+		return 1;
 	}
 
 	h = size_to_hstate(size);
@@ -4242,7 +4240,7 @@ static int __init hugepagesz_setup(char *s)
 		if (!parsed_default_hugepagesz ||  h != &default_hstate ||
 		    default_hstate.max_huge_pages) {
 			pr_warn("HugeTLB: hugepagesz=%s specified twice, ignoring\n", s);
-			return 0;
+			return 1;
 		}
 
 		/*
@@ -4273,14 +4271,14 @@ static int __init default_hugepagesz_setup(char *s)
 	parsed_valid_hugepagesz = false;
 	if (parsed_default_hugepagesz) {
 		pr_err("HugeTLB: default_hugepagesz previously specified, ignoring %s\n", s);
-		return 0;
+		return 1;
 	}
 
 	size = (unsigned long)memparse(s, NULL);
 
 	if (!arch_hugetlb_valid_size(size)) {
 		pr_err("HugeTLB: unsupported default_hugepagesz=%s\n", s);
-		return 0;
+		return 1;
 	}
 
 	hugetlb_add_hstate(ilog2(size) - PAGE_SHIFT);
-- 
2.18.0.huawei.25

