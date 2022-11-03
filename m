Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2F1561859C
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 18:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbiKCRCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 13:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbiKCRCV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 13:02:21 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D3F630A
        for <stable@vger.kernel.org>; Thu,  3 Nov 2022 10:02:19 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id t4so1539238wmj.5
        for <stable@vger.kernel.org>; Thu, 03 Nov 2022 10:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=F2qRvwVUVIRjIeHt35WXksU2jyggEsNFCmKZPYDREH0=;
        b=Pmd1ZWzYe+9SBpCupib/Vm+0gUhLu8QSGX/WqY3HSwPPcz/YftVTkl2CwTIsYVb2Hx
         iRxgZBzpaLdzKE/udwF49ml/0ZOmV8GOKe5cRb3RCVRE301p8jITcfGm9WjywIF2g8Xe
         MS6trBTW1PmNZdD0n+5BgFXLdJi4vJOhUJewZepcExh858lg/tAnC5mZ/FzGESnoAx39
         SJc5IQEC3TBkHm8T93+qRVKTEUQfZyr2TcS0Afxpukqt78dlah6VmkALLMAJ724Whi8k
         z9gRB5ylFALOFIvbVwditPZkNd+WnVAr9vAP+gQP40+vcngbYtGlIDsrQz2dI7qnkGTw
         A4FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F2qRvwVUVIRjIeHt35WXksU2jyggEsNFCmKZPYDREH0=;
        b=2xP1kXl4qcvtAHmSZCXKEUuj8EZMvos+j5o+pKUvjYx4gcFPEhIXyq90x8tD1UjXQB
         y5lsM26Zel4HwFWwB3eYz0nqx4BtPpTv4QhY+2Zanb5nggKtIBm9I3YDYi30A78q9Hgs
         TZnIkGL5NhQXsGjZnIaPXXotf313m4rzsE1uOOoOj09KMr5Owlc691Noq0887LayKtKd
         xXX9ijTIZUQaG0F0S9T9aiR5BLMODMXYT7p2H9Jpg0nGfYuC/GaV9gIkK3PURwtXa4Xj
         /0caN4Nxa1jfjNZTCTkYQmtcCYE1cIkGQEPwWSZCp81e7pLEg3NTItGb7KjuRysYrmuK
         jiTA==
X-Gm-Message-State: ACrzQf2bxuSPqcWGoPKFWVmIC6B+9GEqvJmAXPBgvIGAVYLPZKA/+lwa
        bdlEfjfvRgZuylZ/A0S6oXvuLg==
X-Google-Smtp-Source: AMsMyM4+lDbFeMavFHov8ficnEgR3S1GzKaz2JGhFH/Khbt/MtSp6mpNbtemn0R9Nx3Ih2ByL4LE9g==
X-Received: by 2002:a1c:440b:0:b0:3cf:4db1:d741 with SMTP id r11-20020a1c440b000000b003cf4db1d741mr20754947wma.197.1667494934967;
        Thu, 03 Nov 2022 10:02:14 -0700 (PDT)
Received: from ryzen.lan (79-73-69-252.dynamic.dsl.as9105.com. [79.73.69.252])
        by smtp.gmail.com with ESMTPSA id i15-20020adfa50f000000b002366c3eefccsm1286342wrb.109.2022.11.03.10.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 10:02:14 -0700 (PDT)
From:   Peter Griffin <peter.griffin@linaro.org>
Cc:     Peter Griffin <peter.griffin@linaro.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <mszeredi@redhat.com>, stable@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will McVicker <willmcvicker@google.com>,
        Peter Griffin <gpeter@google.com>
Subject: [PATCH] vfs: vfs_tmpfile: ensure O_EXCL flag is enforced
Date:   Thu,  3 Nov 2022 17:02:10 +0000
Message-Id: <20221103170210.464155-1-peter.griffin@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If O_EXCL is *not* specified, then linkat() can be
used to link the temporary file into the filesystem.
If O_EXCL is specified then linkat() should fail (-1).

After commit 863f144f12ad ("vfs: open inside ->tmpfile()")
the O_EXCL flag is no longer honored by the vfs layer for
tmpfile, which means the file can be linked even if O_EXCL
flag is specified, which is a change in behaviour for
userspace!

The open flags was previously passed as a parameter, so it
was uneffected by the changes to file->f_flags caused by
finish_open(). This patch fixes the issue by storing
file->f_flags in a local variable so the O_EXCL test
logic is restored.

This regression was detected by Android CTS Bionic fcntl()
tests running on android-mainline [1].

[1] https://android.googlesource.com/platform/bionic/+/
    refs/heads/master/tests/fcntl_test.cpp#352

Fixes: 863f144f12ad ("vfs: open inside ->tmpfile()")
To: lkml <linux-kernel@vger.kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: stable@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Will McVicker <willmcvicker@google.com>
Cc: Peter Griffin <gpeter@google.com>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 fs/namei.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index 578c2110df02..9155ecb547ce 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3591,6 +3591,7 @@ static int vfs_tmpfile(struct user_namespace *mnt_userns,
 	struct inode *dir = d_inode(parentpath->dentry);
 	struct inode *inode;
 	int error;
+	int open_flag = file->f_flags;
 
 	/* we want directory to be writable */
 	error = inode_permission(mnt_userns, dir, MAY_WRITE | MAY_EXEC);
@@ -3613,7 +3614,7 @@ static int vfs_tmpfile(struct user_namespace *mnt_userns,
 	if (error)
 		return error;
 	inode = file_inode(file);
-	if (!(file->f_flags & O_EXCL)) {
+	if (!(open_flag & O_EXCL)) {
 		spin_lock(&inode->i_lock);
 		inode->i_state |= I_LINKABLE;
 		spin_unlock(&inode->i_lock);
-- 
2.34.1

