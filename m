Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021555AB8C2
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 21:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiIBTML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 15:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiIBTMJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 15:12:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FA6FBA4D;
        Fri,  2 Sep 2022 12:12:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50EED6229E;
        Fri,  2 Sep 2022 19:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDE9C433D6;
        Fri,  2 Sep 2022 19:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662145923;
        bh=rJDLXs4RxM5/uTreWGTpem458YPycLhkzqUiqONrjDY=;
        h=From:To:Cc:Subject:Date:From;
        b=aBZGi0RYXJahnjFCnOvAslff2adgx6/RpvP1D3sAHZhvIh2wnbv8h31jmgElsGIkW
         oBAGnyCCnF4EOlcsW1lqqVCUwFB7h5NiSJwfU9Dmi7d3wDLEjo2RNpSsXxOIzLGDeg
         SwD3jk1ueOHubNqwACGDGfCADYqtCIELrC2Ec9h8pr9K0M11otV6lL3Klu5njJ8Gk5
         KC4RS86RroeG/sVkFwv1EHBP3Zf1iYX6vcAWp7sBARNc6aq7VFCpTkb4UCxYfMbqDN
         yOKwMMHl4qM42NW79eShU+czoiEfdsRVXa4VAhP7GAmaV98Ao+sxQAUAUsSeYwAIHE
         BDTPqYtALPA0Q==
From:   SeongJae Park <sj@kernel.org>
To:     akpm@linux-foundation.org
Cc:     sj@kernel.org, gregkh@linuxfoundation.org, damon@lists.linux.dev,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2] mm/damon/dbgfs: fix memory leak when using
Date:   Fri,  2 Sep 2022 19:11:49 +0000
Message-Id: <20220902191149.112434-1-sj@kernel.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

debugfs_lookup()
Date: Fri,  2 Sep 2022 14:56:31 +0200	[thread overview]
Message-ID: <20220902125631.128329-1-gregkh@linuxfoundation.org> (raw)

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  Fix this up by properly
calling dput().

Fixes: 75c1c2b53c78b ("mm/damon/dbgfs: support multiple contexts")
Cc: <stable@vger.kernel.org> # 5.15.x
Cc: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev
Cc: linux-mm@kvack.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from v1
(https://lore.kernel.org/damon/20220902125631.128329-1-gregkh@linuxfoundation.org/)
- Call dput() for failure-return case (Andrew Morton)

 mm/damon/dbgfs.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/mm/damon/dbgfs.c b/mm/damon/dbgfs.c
index 3b55a1b219b5..652a94deafe3 100644
--- a/mm/damon/dbgfs.c
+++ b/mm/damon/dbgfs.c
@@ -884,6 +884,7 @@ static int dbgfs_rm_context(char *name)
 	struct dentry *root, *dir, **new_dirs;
 	struct damon_ctx **new_ctxs;
 	int i, j;
+	int ret = 0;
 
 	if (damon_nr_running_ctxs())
 		return -EBUSY;
@@ -898,14 +899,16 @@ static int dbgfs_rm_context(char *name)
 
 	new_dirs = kmalloc_array(dbgfs_nr_ctxs - 1, sizeof(*dbgfs_dirs),
 			GFP_KERNEL);
-	if (!new_dirs)
-		return -ENOMEM;
+	if (!new_dirs) {
+		ret = -ENOMEM;
+		goto out_dput;
+	}
 
 	new_ctxs = kmalloc_array(dbgfs_nr_ctxs - 1, sizeof(*dbgfs_ctxs),
 			GFP_KERNEL);
 	if (!new_ctxs) {
-		kfree(new_dirs);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_new_dirs;
 	}
 
 	for (i = 0, j = 0; i < dbgfs_nr_ctxs; i++) {
@@ -925,7 +928,13 @@ static int dbgfs_rm_context(char *name)
 	dbgfs_ctxs = new_ctxs;
 	dbgfs_nr_ctxs--;
 
-	return 0;
+	goto out_dput;
+
+out_new_dirs:
+	kfree(new_dirs);
+out_dput:
+	dput(dir);
+	return ret;
 }
 
 static ssize_t dbgfs_rm_context_write(struct file *file,
-- 
2.25.1

