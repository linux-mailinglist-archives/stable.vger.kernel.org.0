Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5B3328943
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239067AbhCARxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:53:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:40900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238618AbhCARrL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:47:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F8F164F56;
        Mon,  1 Mar 2021 16:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617953;
        bh=cFue32MRHtHmH/XOI+4ZbaEMHssDtG6VtwQndobrvLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ErTdJRHLIVrcrP9LB4yw/H4X2JvZmYzCMf5ScWgyxBEQXXubGjkHaHqcS1oeYlmzE
         NbBmFY5u/1eiHJl9HLm1tM4UY+PmW3i3EBdVz962+HUpchUULsjfospGj+sb5LDDGf
         ccqZ8B0np3GhT+whLvHVVLEbMyYep5e8cDMiIov8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <smuchun@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 228/340] mm/hugetlb: fix potential double free in hugetlb_register_node() error path
Date:   Mon,  1 Mar 2021 17:12:52 +0100
Message-Id: <20210301161059.522897968@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index d5b03b9262d4f..2e2527c9f9a21 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2812,8 +2812,10 @@ static int hugetlb_sysfs_add_hstate(struct hstate *h, struct kobject *parent,
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



