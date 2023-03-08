Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF78D6AFBBA
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 02:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbjCHBFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 20:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjCHBFk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 20:05:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB82298DD;
        Tue,  7 Mar 2023 17:05:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0EFF615F7;
        Wed,  8 Mar 2023 01:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55886C433D2;
        Wed,  8 Mar 2023 01:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678237536;
        bh=cFYwCkckI+B4WquIIgOkBqV9ynJxIGoQ71q+3c1PCi4=;
        h=Date:To:From:Subject:From;
        b=whzWSYOcItLq/trQXbR/IuQRYWOT+DxOEgfL4pI9fRdb2WzxDmS5c9e1Cf/Kxu3OA
         ZVq1+0EnIUAPtGAFaCkYNZ9jThj9RGuY/QztwnNiMvPZal22SO0v4YtmZm54ELKoYo
         ItY/iFLFCCMvIwSZwncFqg+PAgKeB+HaBrXmxDPs=
Date:   Tue, 07 Mar 2023 17:05:35 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        piaojun@huawei.com, mark@fasheh.com, junxiao.bi@oracle.com,
        joseph.qi@linux.alibaba.com, jlbec@evilplan.org, jack@suse.cz,
        ghe@suse.com, gechangwei@live.cn, ocfs2-devel@oss.oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-fix-data-corruption-after-failed-write.patch removed from -mm tree
Message-Id: <20230308010536.55886C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: fix data corruption after failed write
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-data-corruption-after-failed-write.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: fix data corruption after failed write
Date: Thu, 2 Mar 2023 16:38:43 +0100

When buffered write fails to copy data into underlying page cache page,
ocfs2_write_end_nolock() just zeroes out and dirties the page.  This can
leave dirty page beyond EOF and if page writeback tries to write this page
before write succeeds and expands i_size, page gets into inconsistent
state where page dirty bit is clear but buffer dirty bits stay set
resulting in page data never getting written and so data copied to the
page is lost.  Fix the problem by invalidating page beyond EOF after
failed write.

Link: https://lkml.kernel.org/r/20230302153843.18499-1-jack@suse.cz
Fixes: 6dbf7bb55598 ("fs: Don't invalidate page buffers in block_write_full_page()")
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/ocfs2/aops.c~ocfs2-fix-data-corruption-after-failed-write
+++ a/fs/ocfs2/aops.c
@@ -1977,11 +1977,26 @@ int ocfs2_write_end_nolock(struct addres
 	}
 
 	if (unlikely(copied < len) && wc->w_target_page) {
+		loff_t new_isize;
+
 		if (!PageUptodate(wc->w_target_page))
 			copied = 0;
 
-		ocfs2_zero_new_buffers(wc->w_target_page, start+copied,
-				       start+len);
+		new_isize = max_t(loff_t, i_size_read(inode), pos + copied);
+		if (new_isize > page_offset(wc->w_target_page))
+			ocfs2_zero_new_buffers(wc->w_target_page, start+copied,
+					       start+len);
+		else {
+			/*
+			 * When page is fully beyond new isize (data copy
+			 * failed), do not bother zeroing the page. Invalidate
+			 * it instead so that writeback does not get confused
+			 * put page & buffer dirty bits into inconsistent
+			 * state.
+			 */
+			block_invalidate_folio(page_folio(wc->w_target_page),
+						0, PAGE_SIZE);
+		}
 	}
 	if (wc->w_target_page)
 		flush_dcache_page(wc->w_target_page);
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are


