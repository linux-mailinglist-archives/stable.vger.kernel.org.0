Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E842B59A3CB
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354862AbiHSRt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 13:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351958AbiHSRtR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 13:49:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C2832D80;
        Fri, 19 Aug 2022 10:19:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A90D761709;
        Fri, 19 Aug 2022 17:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85184C433C1;
        Fri, 19 Aug 2022 17:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660929576;
        bh=3Sdln9qJKHLzw3ch7twkCCMwF2dg/LGZE0fJeB2Pqds=;
        h=From:To:Cc:Subject:Date:From;
        b=WDXGks4O7BdiqUE7X0ObnfF1Zyc1+QRtTDQWZKrcu/dYHW20fJbBaY5zTopwpzRcr
         iT1CheRg5d9nG1nbiK+07tKfvbRrMPPAzYs5xdQS9G94QOx6JiQ+CZqnjz5bLfoTQM
         8GizFsATxnYxbVf0njAQVdq4u3/+gJxXl8HMgOFRfzNYQuZFqeZm2bQA2iehreJcJr
         MsgssHY7b9NDzkvL3zvPSqZdzev4Zl7VTNxdSDSPb4x7IYajtOS5mXMkGX9sEwD/g5
         YzO+4CjEDdZnIOJknjJdGpijVe7LNFh8j3wLUZmLKeBi2YCJXcIkfdlNSLufGy6I/p
         rjfnuFJRi3Ofg==
From:   SeongJae Park <sj@kernel.org>
To:     akpm@linux-foundation.org
Cc:     sj@kernel.org, badari.pulavarty@intel.com, damon@lists.linux.dev,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2] mm/damon/dbgfs: avoid duplicate context directory creation
Date:   Fri, 19 Aug 2022 17:19:30 +0000
Message-Id: <20220819171930.16166-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Badari Pulavarty <badari.pulavarty@intel.com>

When user tries to create a DAMON context via the DAMON debugfs
interface with a name of an already existing context, the context
directory creation silently fails but the context is added in the
internal data structure.  As a result, memory could leak and DAMON
cannot be turned on.  An example test case is as below:

    # cd /sys/kernel/debug/damon/
    # echo "off" >  monitor_on
    # echo paddr > target_ids
    # echo "abc" > mk_context
    # echo "abc" > mk_context
    # echo $$ > abc/target_ids
    # echo "on" > monitor_on  <<< fails

This commit fixes the issue by checking if the name already exist and
immediately returning '-EEXIST' in the case.

Fixes: 75c1c2b53c78 ("mm/damon/dbgfs: support multiple contexts")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Badari Pulavarty <badari.pulavarty@intel.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from v1
(https://lore.kernel.org/damon/DM6PR11MB3978994F75A4104D714437379C679@DM6PR11MB3978.namprd11.prod.outlook.com/)
- Manually check duplicate entry instead of checking
  'debugfs_create_dir()' return value
- Reword commit message and the test case

Seems Badari have some email client issue, so I (SJ) am making this
second version of the patch based on Badari's final proposal and repost
on behalf of Badari.

 mm/damon/dbgfs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/damon/dbgfs.c b/mm/damon/dbgfs.c
index 51d67c8050dd..364b44063c2f 100644
--- a/mm/damon/dbgfs.c
+++ b/mm/damon/dbgfs.c
@@ -795,7 +795,7 @@ static void dbgfs_destroy_ctx(struct damon_ctx *ctx)
  */
 static int dbgfs_mk_context(char *name)
 {
-	struct dentry *root, **new_dirs, *new_dir;
+	struct dentry *root, **new_dirs, *new_dir, *dir;
 	struct damon_ctx **new_ctxs, *new_ctx;
 
 	if (damon_nr_running_ctxs())
@@ -817,6 +817,12 @@ static int dbgfs_mk_context(char *name)
 	if (!root)
 		return -ENOENT;
 
+	dir = debugfs_lookup(name, root);
+	if (dir) {
+		dput(dir);
+		return -EEXIST;
+	}
+
 	new_dir = debugfs_create_dir(name, root);
 	dbgfs_dirs[dbgfs_nr_ctxs] = new_dir;
 
-- 
2.25.1

