Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4488A658463
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235215AbiL1Q5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:57:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235266AbiL1Q4U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:56:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFD1186D4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:51:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 26B8ACE1376
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDE9C433D2;
        Wed, 28 Dec 2022 16:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246301;
        bh=L4T6co3qEhFUImBGVuk1Cgsr93LNnaOLn11IL9Q4Eqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZW6jPlPyDwySLQzVciEXLCNSuV9KOKxvou+BzwbWGJi1dUtOO57tUQNrfLS+5BQ+u
         gpDgzokmiu2EyTg13qbnifERTOPh7MBeWeQZ4OGh4hG8guZmcdFJY3AsQGUCGckG6A
         M768a2j1swfsgrssozG8/c1mMDdp+8Kk/9Yl/1AA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff Mahoney <jeffm@suse.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.0 1046/1073] reiserfs: Add missing calls to reiserfs_security_free()
Date:   Wed, 28 Dec 2022 15:43:54 +0100
Message-Id: <20221228144356.613381339@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 572302af1258459e124437b8f3369357447afac7 upstream.

Commit 57fe60df6241 ("reiserfs: add atomic addition of selinux attributes
during inode creation") defined reiserfs_security_free() to free the name
and value of a security xattr allocated by the active LSM through
security_old_inode_init_security(). However, this function is not called
in the reiserfs code.

Thus, add a call to reiserfs_security_free() whenever
reiserfs_security_init() is called, and initialize value to NULL, to avoid
to call kfree() on an uninitialized pointer.

Finally, remove the kfree() for the xattr name, as it is not allocated
anymore.

Fixes: 57fe60df6241 ("reiserfs: add atomic addition of selinux attributes during inode creation")
Cc: stable@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: Mimi Zohar <zohar@linux.ibm.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/reiserfs/namei.c          |    4 ++++
 fs/reiserfs/xattr_security.c |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -696,6 +696,7 @@ static int reiserfs_create(struct user_n
 
 out_failed:
 	reiserfs_write_unlock(dir->i_sb);
+	reiserfs_security_free(&security);
 	return retval;
 }
 
@@ -779,6 +780,7 @@ static int reiserfs_mknod(struct user_na
 
 out_failed:
 	reiserfs_write_unlock(dir->i_sb);
+	reiserfs_security_free(&security);
 	return retval;
 }
 
@@ -878,6 +880,7 @@ static int reiserfs_mkdir(struct user_na
 	retval = journal_end(&th);
 out_failed:
 	reiserfs_write_unlock(dir->i_sb);
+	reiserfs_security_free(&security);
 	return retval;
 }
 
@@ -1194,6 +1197,7 @@ static int reiserfs_symlink(struct user_
 	retval = journal_end(&th);
 out_failed:
 	reiserfs_write_unlock(parent_dir->i_sb);
+	reiserfs_security_free(&security);
 	return retval;
 }
 
--- a/fs/reiserfs/xattr_security.c
+++ b/fs/reiserfs/xattr_security.c
@@ -50,6 +50,7 @@ int reiserfs_security_init(struct inode
 	int error;
 
 	sec->name = NULL;
+	sec->value = NULL;
 
 	/* Don't add selinux attributes on xattrs - they'll never get used */
 	if (IS_PRIVATE(dir))
@@ -95,7 +96,6 @@ int reiserfs_security_write(struct reise
 
 void reiserfs_security_free(struct reiserfs_security_handle *sec)
 {
-	kfree(sec->name);
 	kfree(sec->value);
 	sec->name = NULL;
 	sec->value = NULL;


