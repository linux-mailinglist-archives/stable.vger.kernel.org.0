Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F3F61FF2A
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 21:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbiKGUII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 15:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232706AbiKGUIE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 15:08:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAA12AC6C;
        Mon,  7 Nov 2022 12:08:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B96B6B815E9;
        Mon,  7 Nov 2022 20:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFAAC433C1;
        Mon,  7 Nov 2022 20:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667851678;
        bh=lRVwPbiW9Ke3lUP7cnc9X5B7hikZ/+lOO4v31Zn6Gxw=;
        h=Date:To:From:Subject:From;
        b=exSwZ97j0PPo0ccjrPsDcbuL9Y5d64QbRD83N7gQLTcLxTue9U2W3LtWmfR7raZtH
         wcWOqi65Gf1Mhlhzl0LgxNR+frdy7RqPZA4ZPWDVdr8ThTBoH3Kxiax11g8fjeWKlX
         4QIlFKzjROZLAAQm2wRF2JuCMOyRPeDX+uoTUkeg=
Date:   Mon, 07 Nov 2022 12:07:57 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-dbgfs-check-if-rm_contexts-input-is-for-a-real-context.patch added to mm-hotfixes-unstable branch
Message-Id: <20221107200758.4CFAAC433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: check if rm_contexts input is for a real context
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-dbgfs-check-if-rm_contexts-input-is-for-a-real-context.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-dbgfs-check-if-rm_contexts-input-is-for-a-real-context.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs: check if rm_contexts input is for a real context
Date: Mon, 7 Nov 2022 16:50:00 +0000

A user could write a name of a file under 'damon/' debugfs directory,
which is not a user-created context, to 'rm_contexts' file.  In the case,
'dbgfs_rm_context()' just assumes it's the valid DAMON context directory
only if a file of the name exist.  As a result, invalid memory access
could happen as below.  Fix the bug by checking if the given input is for
a directory.  This check can filter out non-context inputs because
directories under 'damon/' debugfs directory can be created via only
'mk_contexts' file.

This bug has found by syzbot[1].

[1] https://lore.kernel.org/damon/000000000000ede3ac05ec4abf8e@google.com/

Link: https://lkml.kernel.org/r/20221107165001.5717-2-sj@kernel.org
Fixes: 75c1c2b53c78 ("mm/damon/dbgfs: support multiple contexts")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: syzbot+6087eafb76a94c4ac9eb@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>	[5.15.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-check-if-rm_contexts-input-is-for-a-real-context
+++ a/mm/damon/dbgfs.c
@@ -890,6 +890,7 @@ out:
 static int dbgfs_rm_context(char *name)
 {
 	struct dentry *root, *dir, **new_dirs;
+	struct inode *inode;
 	struct damon_ctx **new_ctxs;
 	int i, j;
 	int ret = 0;
@@ -905,6 +906,12 @@ static int dbgfs_rm_context(char *name)
 	if (!dir)
 		return -ENOENT;
 
+	inode = d_inode(dir);
+	if (!S_ISDIR(inode->i_mode)) {
+		ret = -EINVAL;
+		goto out_dput;
+	}
+
 	new_dirs = kmalloc_array(dbgfs_nr_ctxs - 1, sizeof(*dbgfs_dirs),
 			GFP_KERNEL);
 	if (!new_dirs) {
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-dbgfs-check-if-rm_contexts-input-is-for-a-real-context.patch
mm-damon-core-split-out-damos-charged-region-skip-logic-into-a-new-function.patch
mm-damon-core-split-damos-application-logic-into-a-new-function.patch
mm-damon-core-split-out-scheme-stat-update-logic-into-a-new-function.patch
mm-damon-core-split-out-scheme-quota-adjustment-logic-into-a-new-function.patch
mm-damon-sysfs-use-damon_addr_range-for-regions-start-and-end-values.patch
mm-damon-sysfs-remove-parameters-of-damon_sysfs_region_alloc.patch
mm-damon-sysfs-move-sysfs_lock-to-common-module.patch
mm-damon-sysfs-move-unsigned-long-range-directory-to-common-module.patch
mm-damon-sysfs-split-out-kdamond-independent-schemes-stats-update-logic-into-a-new-function.patch
mm-damon-sysfs-split-out-schemes-directory-implementation-to-separate-file.patch
mm-damon-modules-deduplicate-init-steps-for-damon-context-setup.patch
mm-damon-reclaimlru_sort-remove-unnecessarily-included-headers.patch
mm-damon-reclaim-enable-and-disable-synchronously.patch
selftests-damon-add-tests-for-damon_reclaims-enabled-parameter.patch
mm-damon-lru_sort-enable-and-disable-synchronously.patch
selftests-damon-add-tests-for-damon_lru_sorts-enabled-parameter.patch
docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch
docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch
mm-damon-core-add-a-callback-for-scheme-target-regions-check.patch
mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory.patch
mm-damon-sysfs-schemes-implement-scheme-region-directory.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch
tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch
docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch
docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory.patch
selftests-damon-test-non-context-inputs-to-rm_contexts-file.patch

