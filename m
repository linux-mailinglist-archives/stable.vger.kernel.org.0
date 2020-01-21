Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C81FB144665
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 22:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgAUV11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 16:27:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:32930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728776AbgAUV11 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jan 2020 16:27:27 -0500
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDF6D217F4;
        Tue, 21 Jan 2020 21:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579642047;
        bh=ViYwl+4l/3pPOK43J0/nbegJ1CbPkzVa+D6Qofqh4ec=;
        h=Date:From:To:Subject:From;
        b=SDYz4SCGO3jyHSAKYAGFNeZodhiDXWy7Q3GPc2QUkcpVGJyjSObu2f/EU3G3MSGda
         yXsoCE+LQlqGS+cc8uJLPpHe9RfuWh54nEc9r4ogsPtzIlbatESc4JtBgsTxQLWVA4
         24Rekk+E5qcRGM1LKg7JEXPn+0t5GLsbpvkY12OE=
Date:   Tue, 21 Jan 2020 13:27:26 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        richardw.yang@linux.intel.com, mhocko@suse.com,
        yang.shi@linux.alibaba.com
Subject:  [nacked]
 mm-move_pages-fix-the-return-value-if-there-are-not-migrated-pages.patch
 removed from -mm tree
Message-ID: <20200121212726.WdBeK%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/migrate.c: move_pages: fix the return value if there are not-migrated pages
has been removed from the -mm tree.  Its filename was
     mm-move_pages-fix-the-return-value-if-there-are-not-migrated-pages.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm/migrate.c: move_pages: fix the return value if there are not-migrated pages

do_move_pages_to_node() might return > 0 value, the number of pages that
are not migrated, then the value will be returned to userspace directly. 
But, move_pages() syscall would just return 0 or errno.  So, we need reset
the return value to 0 for such case as pre-v4.17 did.

Link: http://lkml.kernel.org/r/1579325203-16405-1-git-send-email-yang.shi@linux.alibaba.com
Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: <stable@vger.kernel.org>    [4.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-move_pages-fix-the-return-value-if-there-are-not-migrated-pages
+++ a/mm/migrate.c
@@ -1659,8 +1659,11 @@ static int do_pages_move(struct mm_struc
 			goto out_flush;
 
 		err = do_move_pages_to_node(mm, &pagelist, current_node);
-		if (err)
+		if (err) {
+			if (err > 0)
+				err = 0;
 			goto out;
+		}
 		if (i > start) {
 			err = store_status(status, start, current_node, i - start);
 			if (err)
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are


