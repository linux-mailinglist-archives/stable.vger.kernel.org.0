Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98DA5F2958
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiJCHRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiJCHRJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:17:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7A546872;
        Mon,  3 Oct 2022 00:14:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C3A1B80E69;
        Mon,  3 Oct 2022 07:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A945EC433D6;
        Mon,  3 Oct 2022 07:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781243;
        bh=+Rg7jiz/BdLa2YuHZAziCH9S3XwBEVJjdLlinQYrA/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lijNi25JxUHd3a1WO4yOo+JlgdiG9ZQkdbcfiybQyvs3m8eiN/CCjP5sBwGRm2UPj
         J1AHrbhpUAyrHg3tsO/Tyd0sS2XU01VSqFbQ2TBRCW1OBMwBPyj+RbnlmidTjWlu4s
         41oOp2tm2ZR2/zexgzbawsz0ZXL0AV1027PRslwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, SeongJae Park <sj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.19 022/101] mm/damon/dbgfs: fix memory leak when using debugfs_lookup()
Date:   Mon,  3 Oct 2022 09:10:18 +0200
Message-Id: <20221003070725.042551819@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 1552fd3ef7dbe07208b8ae84a0a6566adf7dfc9d upstream.

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  Fix this up by properly calling
dput().

Link: https://lkml.kernel.org/r/20220902191149.112434-1-sj@kernel.org
Fixes: 75c1c2b53c78b ("mm/damon/dbgfs: support multiple contexts")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/dbgfs.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/mm/damon/dbgfs.c
+++ b/mm/damon/dbgfs.c
@@ -853,6 +853,7 @@ static int dbgfs_rm_context(char *name)
 	struct dentry *root, *dir, **new_dirs;
 	struct damon_ctx **new_ctxs;
 	int i, j;
+	int ret = 0;
 
 	if (damon_nr_running_ctxs())
 		return -EBUSY;
@@ -867,14 +868,16 @@ static int dbgfs_rm_context(char *name)
 
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
@@ -894,7 +897,13 @@ static int dbgfs_rm_context(char *name)
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


