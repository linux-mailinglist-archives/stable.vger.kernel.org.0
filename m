Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F116DA4E2
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 23:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjDFVvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 17:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDFVve (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 17:51:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B65983CE;
        Thu,  6 Apr 2023 14:51:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B93CA646AF;
        Thu,  6 Apr 2023 21:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B089C433D2;
        Thu,  6 Apr 2023 21:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680817892;
        bh=xMOu0S3bHsnx6eC9qEJCvbZ48iotkfc840hrx9FBaQA=;
        h=From:To:Cc:Subject:Date:From;
        b=F6x1ZylpNx5fIKcouBxWHAu5rvRX/0evzMsCdEJIcBgTt0s07WTbT8U7knUQcsSAL
         juS7r3HHb5EbRq7hZUzMA4dMQtfQ+UjKhlzjYvzFSTuqFMeoLhxww9sS7ccBUhDyR0
         ppsl7/tqvckteDkWNykBUoDgsuo0bSFCILeNTYOW53QXtwXKLCwFCQaLcTowdX2luo
         HhsMNvuLHGao4w+faGBmEYbfvXyku4TMbIu35y4eT7JMya85xjp6TnClEh5PCxZXAS
         EZozZEXWA5Njoui50lRe7gGHJUOaF2aNxDTWdBDk2NEJIypTlgvM8mQezo0de1gpES
         Sy2x/7yUtTn7Q==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fsverity@lists.linux.dev
Cc:     linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+51177e4144d764827c45@syzkaller.appspotmail.com
Subject: [PATCH] fsverity: reject FS_IOC_ENABLE_VERITY on mode 3 fds
Date:   Thu,  6 Apr 2023 14:51:06 -0700
Message-Id: <20230406215106.235829-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Commit 56124d6c87fd ("fsverity: support enabling with tree block size <
PAGE_SIZE") changed FS_IOC_ENABLE_VERITY to use __kernel_read() to read
the file's data, instead of direct pagecache accesses.

An unintended consequence of this is that the
'WARN_ON_ONCE(!(file->f_mode & FMODE_READ))' in __kernel_read() became
reachable by fuzz tests.  This happens if FS_IOC_ENABLE_VERITY is called
on a fd opened with access mode 3, which means "ioctl access only".

Arguably, FS_IOC_ENABLE_VERITY should work on ioctl-only fds.  But
ioctl-only fds are a weird Linux extension that is rarely used and that
few people even know about.  (The documentation for FS_IOC_ENABLE_VERITY
even specifically says it requires O_RDONLY.)  It's probably not
worthwhile to make the ioctl internally open a new fd just to handle
this case.  Thus, just reject the ioctl on such fds for now.

Fixes: 56124d6c87fd ("fsverity: support enabling with tree block size < PAGE_SIZE")
Reported-by: syzbot+51177e4144d764827c45@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=2281afcbbfa8fdb92f9887479cc0e4180f1c6b28
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/verity/enable.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index bbec6f93172cf..fc4c50e5219dc 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -357,6 +357,13 @@ int fsverity_ioctl_enable(struct file *filp, const void __user *uarg)
 	err = file_permission(filp, MAY_WRITE);
 	if (err)
 		return err;
+	/*
+	 * __kernel_read() is used while building the Merkle tree.  So, we can't
+	 * allow file descriptors that were opened for ioctl access only, using
+	 * the special nonstandard access mode 3.  O_RDONLY only, please!
+	 */
+	if (!(filp->f_mode & FMODE_READ))
+		return -EBADF;
 
 	if (IS_APPEND(inode))
 		return -EPERM;

base-commit: dbd91ed3b5acb7acba2cac2d38e7aec57a5f1e96
-- 
2.40.0

