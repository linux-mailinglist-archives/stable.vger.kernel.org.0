Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB7865BBB4
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236967AbjACIPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236972AbjACIPC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:15:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2CFD2F6
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:15:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00841B80E4B
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36126C433F1;
        Tue,  3 Jan 2023 08:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733697;
        bh=KEGkIuB+UZS0fxxkPzh833jdqcuRurlCLjQiMLhFDjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pxpGMxGcYOMPr1tMHobX6lly1ud0hrTLWnYAM+j7Di9rGyS/yy6jQ+1IDbZmc6r5B
         Cs7Zmy2QvkodEAQjS9ciDUzYdpAx69C1+J2f6UvA0waodhUxnF8k3wdUUw6WirzOMO
         QB9ZNzuTG+ukGkRyp4YLa9pOHdHbfZXPD8/iwJVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.10 03/63] saner calling conventions for unlazy_child()
Date:   Tue,  3 Jan 2023 09:13:33 +0100
Message-Id: <20230103081308.760421375@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit ae66db45fd309fd1c6d4e846dfc8414dfec7d6ad ]

same as for the previous commit - instead of 0/-ECHILD make
it return true/false, rename to try_to_unlazy_child().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namei.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -705,19 +705,19 @@ out:
 }
 
 /**
- * unlazy_child - try to switch to ref-walk mode.
+ * try_to_unlazy_next - try to switch to ref-walk mode.
  * @nd: nameidata pathwalk data
- * @dentry: child of nd->path.dentry
- * @seq: seq number to check dentry against
- * Returns: 0 on success, -ECHILD on failure
- *
- * unlazy_child attempts to legitimize the current nd->path, nd->root and dentry
- * for ref-walk mode.  @dentry must be a path found by a do_lookup call on
- * @nd.  Must be called from rcu-walk context.
- * Nothing should touch nameidata between unlazy_child() failure and
+ * @dentry: next dentry to step into
+ * @seq: seq number to check @dentry against
+ * Returns: true on success, false on failure
+ *
+ * Similar to to try_to_unlazy(), but here we have the next dentry already
+ * picked by rcu-walk and want to legitimize that in addition to the current
+ * nd->path and nd->root for ref-walk mode.  Must be called from rcu-walk context.
+ * Nothing should touch nameidata between try_to_unlazy_next() failure and
  * terminate_walk().
  */
-static int unlazy_child(struct nameidata *nd, struct dentry *dentry, unsigned seq)
+static bool try_to_unlazy_next(struct nameidata *nd, struct dentry *dentry, unsigned seq)
 {
 	BUG_ON(!(nd->flags & LOOKUP_RCU));
 
@@ -747,7 +747,7 @@ static int unlazy_child(struct nameidata
 	if (unlikely(!legitimize_root(nd)))
 		goto out_dput;
 	rcu_read_unlock();
-	return 0;
+	return true;
 
 out2:
 	nd->path.mnt = NULL;
@@ -755,11 +755,11 @@ out1:
 	nd->path.dentry = NULL;
 out:
 	rcu_read_unlock();
-	return -ECHILD;
+	return false;
 out_dput:
 	rcu_read_unlock();
 	dput(dentry);
-	return -ECHILD;
+	return false;
 }
 
 static inline int d_revalidate(struct dentry *dentry, unsigned int flags)
@@ -1374,7 +1374,7 @@ static inline int handle_mounts(struct n
 			return -ENOENT;
 		if (likely(__follow_mount_rcu(nd, path, inode, seqp)))
 			return 0;
-		if (unlazy_child(nd, dentry, seq))
+		if (!try_to_unlazy_next(nd, dentry, seq))
 			return -ECHILD;
 		// *path might've been clobbered by __follow_mount_rcu()
 		path->mnt = nd->path.mnt;
@@ -1495,7 +1495,7 @@ static struct dentry *lookup_fast(struct
 		status = d_revalidate(dentry, nd->flags);
 		if (likely(status > 0))
 			return dentry;
-		if (unlazy_child(nd, dentry, seq))
+		if (!try_to_unlazy_next(nd, dentry, seq))
 			return ERR_PTR(-ECHILD);
 		if (unlikely(status == -ECHILD))
 			/* we'd been told to redo it in non-rcu mode */


