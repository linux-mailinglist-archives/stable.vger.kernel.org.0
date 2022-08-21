Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE5059B6C9
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 01:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbiHUXjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 19:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiHUXjU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 19:39:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E9313D61;
        Sun, 21 Aug 2022 16:39:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CB8460DFC;
        Sun, 21 Aug 2022 23:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC63C433D6;
        Sun, 21 Aug 2022 23:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661125156;
        bh=bsjBQ8x53uP4Wlujj47O/Zq5yIu60FEP1VZKHxMxb14=;
        h=Date:To:From:Subject:From;
        b=cOJSo4pbgJ3z0OrdI4mhZMD1EX6DEymaVNAz7E6GXUDMDbDXmOX6LBcECfGrkeh5c
         zz4AOJFmnL+Qm5PEQeZDC+Hcq7ouirZGH6s8azl0IluHRs/ZIZcymgcsaj2cnxSSoF
         aqYO3CxI7tZXl/ctrmB6TcazI+BUrPslxw3u6v/c=
Date:   Sun, 21 Aug 2022 16:39:15 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        badari.pulavarty@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-dbgfs-avoid-duplicate-context-directory-creation.patch added to mm-hotfixes-unstable branch
Message-Id: <20220821233916.8FC63C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: avoid duplicate context directory creation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-dbgfs-avoid-duplicate-context-directory-creation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-dbgfs-avoid-duplicate-context-directory-creation.patch

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
From: Badari Pulavarty <badari.pulavarty@intel.com>
Subject: mm/damon/dbgfs: avoid duplicate context directory creation
Date: Sun, 21 Aug 2022 18:08:53 +0000

When user tries to create a DAMON context via the DAMON debugfs interface
with a name of an already existing context, the context directory creation
fails but a new context is created and added in the internal data
structure, due to absence of the directory creation success check.  As a
result, memory could leak and DAMON cannot be turned on.  An example test
case is as below:

    # cd /sys/kernel/debug/damon/
    # echo "off" >  monitor_on
    # echo paddr > target_ids
    # echo "abc" > mk_context
    # echo "abc" > mk_context
    # echo $$ > abc/target_ids
    # echo "on" > monitor_on  <<< fails

Return value of 'debugfs_create_dir()' is expected to be ignored in
general, but this is an exceptional case as DAMON feature is depending
on the debugfs functionality and it has the potential duplicate name
issue.  This commit therefore fixes the issue by checking the directory
creation failure and immediately return the error in the case.

Link: https://lkml.kernel.org/r/20220821180853.2400-1-sj@kernel.org
Fixes: 75c1c2b53c78 ("mm/damon/dbgfs: support multiple contexts")
Signed-off-by: Badari Pulavarty <badari.pulavarty@intel.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[ 5.15.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-avoid-duplicate-context-directory-creation
+++ a/mm/damon/dbgfs.c
@@ -818,6 +818,9 @@ static int dbgfs_mk_context(char *name)
 		return -ENOENT;
 
 	new_dir = debugfs_create_dir(name, root);
+	/* Below check is required for a potential duplicated name case */
+	if (IS_ERR(new_dir))
+		return PTR_ERR(new_dir);
 	dbgfs_dirs[dbgfs_nr_ctxs] = new_dir;
 
 	new_ctx = dbgfs_new_ctx();
_

Patches currently in -mm which might be from badari.pulavarty@intel.com are

mm-damon-dbgfs-avoid-duplicate-context-directory-creation.patch

