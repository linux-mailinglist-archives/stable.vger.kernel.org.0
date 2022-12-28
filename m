Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7343657F4F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbiL1QDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234344AbiL1QDX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:03:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6702819293
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:03:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E8F9B81710
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864A8C433EF;
        Wed, 28 Dec 2022 16:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243399;
        bh=L4T6co3qEhFUImBGVuk1Cgsr93LNnaOLn11IL9Q4Eqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rjnatgJveGORGPVfkyZOlFtfQCQcVggGfJIIBHkCc69bq3MRbsWa6tl3spOuyckAV
         djcQjuhh6sROlOwM0Y6j4lGf0aTDcfw1b0Nj7/TGabJXu4IEt2gq+QQ2HsgvwgqtDA
         y81FxfGxIGBwJ30G9XhtOXlWv3+SVxwkDI4UPsaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff Mahoney <jeffm@suse.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.15 717/731] reiserfs: Add missing calls to reiserfs_security_free()
Date:   Wed, 28 Dec 2022 15:43:44 +0100
Message-Id: <20221228144317.226604351@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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


