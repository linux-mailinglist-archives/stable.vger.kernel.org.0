Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F653283F9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbhCAQ2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:28:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:59990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232265AbhCAQXr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:23:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B10F64F21;
        Mon,  1 Mar 2021 16:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615605;
        bh=c9x7jJ/jkE0eQyPmD/xFAEebSaSjyas7bVp1Vxv1+gY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ADlIIDi56WNxOOstmaHK+T5+EutkzoSRV0NCd4hDiO2VhgwJONvkH8cIEDJaSiBfl
         uUYW0YQFmfbe2XK7TA3HdchSLt0+2nKR4VyPHB/Bx4FcP+pQA8jjyMdsyW4of2Dl/K
         sK/dURF+W3BM7bbWWXikygyppgYkLwpE0D1P2O4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <smuchun@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 59/93] mm/hugetlb: fix potential double free in hugetlb_register_node() error path
Date:   Mon,  1 Mar 2021 17:13:11 +0100
Message-Id: <20210301161009.788832901@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161006.881950696@linuxfoundation.org>
References: <20210301161006.881950696@linuxfoundation.org>
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
index dc877712ef1f3..7c3ecac8aeb3f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2485,8 +2485,10 @@ static int hugetlb_sysfs_add_hstate(struct hstate *h, struct kobject *parent,
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



