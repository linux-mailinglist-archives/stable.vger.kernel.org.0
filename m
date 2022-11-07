Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194EE61FA74
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 17:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbiKGQuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 11:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbiKGQuG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 11:50:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5893C193DE;
        Mon,  7 Nov 2022 08:50:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D34A3611CC;
        Mon,  7 Nov 2022 16:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7189C43144;
        Mon,  7 Nov 2022 16:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667839805;
        bh=EQ6SCcuU+VCGAwnEUYyTpKsgCpaNR+eNW9wxrdFWY7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hz8K1E5g7QuSU1lPUHBQYPuAvdbZF+hpRkL+DbqzRCKz2uBZYiJpRYKMvKp1FgJ/f
         2bzqOdR6ml/X6jHJlCVl6VpdVeNyNlBs0pQUnargw1LCUyL/DDm5jit+3Cg31BMjBh
         7WKRWz6ng+lWUYPdGld2DEDcMlzEmMozObeFiW2lP65MdaizkIbWMYKyjUyxtT4tot
         7z/V987uJ9UH8z6rX8+5iNmvuWujS1khnS1ZzlsJE8DaUkAOhEpiSaoF/+Bp9a6eaZ
         pHPh5RzQ9eNPwdAYsB6T4VxYxImAddWoltu693R6CIBhDam/Edg71DBJGBso3arWX6
         L3BHXF1+CThhA==
From:   SeongJae Park <sj@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     damon@lists.linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>,
        syzbot+6087eafb76a94c4ac9eb@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: [PATCH v2 1/2] mm/damon/dbgfs: check if rm_contexts input is for a real context
Date:   Mon,  7 Nov 2022 16:50:00 +0000
Message-Id: <20221107165001.5717-2-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221107165001.5717-1-sj@kernel.org>
References: <20221107165001.5717-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A user could write a name of a file under 'damon/' debugfs directory,
which is not a user-created context, to 'rm_contexts' file.  In the
case, 'dbgfs_rm_context()' just assumes it's the valid DAMON context
directory only if a file of the name exist.  As a result, invalid memory
access could happen as below.  Fix the bug by checking if the given
input is for a directory.  This check can filter out non-context inputs
because directories under 'damon/' debugfs directory can be created via
only 'mk_contexts' file.

This bug has found by syzbot[1].

[1] https://lore.kernel.org/damon/000000000000ede3ac05ec4abf8e@google.com/

Reported-by: syzbot+6087eafb76a94c4ac9eb@syzkaller.appspotmail.com
Fixes: 75c1c2b53c78 ("mm/damon/dbgfs: support multiple contexts")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/dbgfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/dbgfs.c b/mm/damon/dbgfs.c
index 6f0ae7d3ae39..b3f454a5c682 100644
--- a/mm/damon/dbgfs.c
+++ b/mm/damon/dbgfs.c
@@ -890,6 +890,7 @@ static ssize_t dbgfs_mk_context_write(struct file *file,
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
-- 
2.25.1

