Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DE93290E5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242920AbhCAURJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:17:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:38520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239854AbhCAUGB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:06:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE44964F37;
        Mon,  1 Mar 2021 17:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621529;
        bh=LjUTsX59O1s/ZDN159yuDIsQoV8n/88k03Ixw8g+xZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xtXrdQK4NG0pcyj0YtSOq9UOP2cHvp5xAzM88qMjGGRD2Jerr/0hOZ2/Spc4YVf+y
         BugNKZiIEuy8GhqZvRFEgeQi1E/sev2qo6ZV2GMwr12FIuC5g9pC5HdUmoIIVttm60
         tkXQds67bI0pa/Z+2wbMdUaHNRxT4Rs1IhDnRxgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <smuchun@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 549/775] mm/hugetlb: fix potential double free in hugetlb_register_node() error path
Date:   Mon,  1 Mar 2021 17:11:57 +0100
Message-Id: <20210301161228.618957041@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit cc2205a67dec5a700227a693fc113441e73e4641 ]

In hugetlb_sysfs_add_hstate(), we would do kobject_put() on hstate_kobjs
when failed to create sysfs group but forget to set hstate_kobjs to NULL.
Then in hugetlb_register_node() error path, we may free it again via
hugetlb_unregister_node().

Link: https://lkml.kernel.org/r/20210107123249.36964-1-linmiaohe@huawei.com
Fixes: a3437870160c ("hugetlb: new sysfs interface")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <smuchun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4bdb58ab14cbb..bc61eea60e07e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2988,8 +2988,10 @@ static int hugetlb_sysfs_add_hstate(struct hstate *h, struct kobject *parent,
 		return -ENOMEM;
 
 	retval = sysfs_create_group(hstate_kobjs[hi], hstate_attr_group);
-	if (retval)
+	if (retval) {
 		kobject_put(hstate_kobjs[hi]);
+		hstate_kobjs[hi] = NULL;
+	}
 
 	return retval;
 }
-- 
2.27.0



