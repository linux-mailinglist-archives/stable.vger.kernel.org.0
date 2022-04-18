Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3515450505B
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbiDRMY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238407AbiDRMXV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:23:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1E81AD8B;
        Mon, 18 Apr 2022 05:18:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CBEE60F61;
        Mon, 18 Apr 2022 12:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76B9C385A1;
        Mon, 18 Apr 2022 12:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284334;
        bh=wSl0RSmMP5FG7F0lSP+jyXCPimrudFUp31FNYCu0rYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pKvl+n86lAfIWNKKhMNLQxQYlYONm+YO6j5tVBcZQuN98ZZp93VczLsLjDtN87BNi
         +jWTYVpUdkbBUuGmkCDpNx6GnEmyiNU6w0lbCmWm4zX3DodstJ9YFvkMW+mNyZI6tB
         b2cBNyunb7l8sW22LN/3msh1g8lRAEEypMukdI94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gao Xiang <hsiangkao@linux.alibaba.com>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        David Howells <dhowells@redhat.com>, linux-cachefs@redhat.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 078/219] cachefiles: unmark inode in use in error path
Date:   Mon, 18 Apr 2022 14:10:47 +0200
Message-Id: <20220418121208.315766551@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffle Xu <jefflexu@linux.alibaba.com>

[ Upstream commit ea5dc046127e857a7873ae55fd57c866e9e86fb2 ]

Unmark inode in use if error encountered. If the in-use flag leakage
occurs in cachefiles_open_file(), Cachefiles will complain "Inode
already in use" when later another cookie with the same index key is
looked up.

If the in-use flag leakage occurs in cachefiles_create_tmpfile(), though
the "Inode already in use" warning won't be triggered, fix the leakage
anyway.

Reported-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Fixes: 1f08c925e7a3 ("cachefiles: Implement backing file wrangling")
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-cachefs@redhat.com
Link: https://listman.redhat.com/archives/linux-cachefs/2022-March/006615.html # v1
Link: https://listman.redhat.com/archives/linux-cachefs/2022-March/006618.html # v2
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/namei.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index f256c8aff7bb..ca9f3e4ec4b3 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -57,6 +57,16 @@ static void __cachefiles_unmark_inode_in_use(struct cachefiles_object *object,
 	trace_cachefiles_mark_inactive(object, inode);
 }
 
+static void cachefiles_do_unmark_inode_in_use(struct cachefiles_object *object,
+					      struct dentry *dentry)
+{
+	struct inode *inode = d_backing_inode(dentry);
+
+	inode_lock(inode);
+	__cachefiles_unmark_inode_in_use(object, dentry);
+	inode_unlock(inode);
+}
+
 /*
  * Unmark a backing inode and tell cachefilesd that there's something that can
  * be culled.
@@ -68,9 +78,7 @@ void cachefiles_unmark_inode_in_use(struct cachefiles_object *object,
 	struct inode *inode = file_inode(file);
 
 	if (inode) {
-		inode_lock(inode);
-		__cachefiles_unmark_inode_in_use(object, file->f_path.dentry);
-		inode_unlock(inode);
+		cachefiles_do_unmark_inode_in_use(object, file->f_path.dentry);
 
 		if (!test_bit(CACHEFILES_OBJECT_USING_TMPFILE, &object->flags)) {
 			atomic_long_add(inode->i_blocks, &cache->b_released);
@@ -484,7 +492,7 @@ struct file *cachefiles_create_tmpfile(struct cachefiles_object *object)
 				object, d_backing_inode(path.dentry), ret,
 				cachefiles_trace_trunc_error);
 			file = ERR_PTR(ret);
-			goto out_dput;
+			goto out_unuse;
 		}
 	}
 
@@ -494,15 +502,20 @@ struct file *cachefiles_create_tmpfile(struct cachefiles_object *object)
 		trace_cachefiles_vfs_error(object, d_backing_inode(path.dentry),
 					   PTR_ERR(file),
 					   cachefiles_trace_open_error);
-		goto out_dput;
+		goto out_unuse;
 	}
 	if (unlikely(!file->f_op->read_iter) ||
 	    unlikely(!file->f_op->write_iter)) {
 		fput(file);
 		pr_notice("Cache does not support read_iter and write_iter\n");
 		file = ERR_PTR(-EINVAL);
+		goto out_unuse;
 	}
 
+	goto out_dput;
+
+out_unuse:
+	cachefiles_do_unmark_inode_in_use(object, path.dentry);
 out_dput:
 	dput(path.dentry);
 out:
@@ -590,14 +603,16 @@ static bool cachefiles_open_file(struct cachefiles_object *object,
 check_failed:
 	fscache_cookie_lookup_negative(object->cookie);
 	cachefiles_unmark_inode_in_use(object, file);
-	if (ret == -ESTALE) {
-		fput(file);
-		dput(dentry);
+	fput(file);
+	dput(dentry);
+	if (ret == -ESTALE)
 		return cachefiles_create_file(object);
-	}
+	return false;
+
 error_fput:
 	fput(file);
 error:
+	cachefiles_do_unmark_inode_in_use(object, dentry);
 	dput(dentry);
 	return false;
 }
-- 
2.35.1



