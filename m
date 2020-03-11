Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0333181646
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 11:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbgCKKxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 06:53:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51306 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728255AbgCKKxS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 06:53:18 -0400
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jByzB-0004xv-RE; Wed, 11 Mar 2020 10:53:13 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     naresh.kamboju@linaro.org
Cc:     ard.biesheuvel@linaro.org, ardb@kernel.org,
        christian.brauner@ubuntu.com, gregkh@linuxfoundation.org,
        john.stultz@linaro.org, keescook@chromium.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        lkft-triage@lists.linaro.org, shuah@kernel.org, tkjos@google.com,
        stable@vger.kernel.org
Subject: [PATCH] binderfs: use refcount for binder control devices too
Date:   Wed, 11 Mar 2020 11:53:09 +0100
Message-Id: <20200311105309.1742827-1-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CA+G9fYusdfg7PMfC9Xce-xLT7NiyKSbgojpK35GOm=Pf9jXXrA@mail.gmail.com>
References: <CA+G9fYusdfg7PMfC9Xce-xLT7NiyKSbgojpK35GOm=Pf9jXXrA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Binderfs binder-control devices are cleaned up via binderfs_evict_inode
too() which will use refcount_dec_and_test(). However, we missed to set
the refcount for binderfs binder-control devices and so we underflowed
when the binderfs instance got unmounted. Pretty obvious oversight and
should have been part of the more general UAF fix. The good news is that
having test cases (suprisingly) helps.

Technically, we could detect that we're about to cleanup the
binder-control dentry in binderfs_evict_inode() and then simply clean it
up. But that makes the assumption that the binder driver itself will
never make use of a binderfs binder-control device after the binderfs
instance it belongs to has been unmounted and the superblock for it been
destroyed. While it is unlikely to ever come to this let's be on the
safe side. Performance-wise this also really doesn't matter since the
binder-control device is only every really when creating the binderfs
filesystem or creating additional binder devices. Both operations are
pretty rare.

Fixes: f0fe2c0f050d ("binder: prevent UAF for binderfs devices II")
Link: https://lore.kernel.org/r/CA+G9fYusdfg7PMfC9Xce-xLT7NiyKSbgojpK35GOm=Pf9jXXrA@mail.gmail.com
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org
Cc: Todd Kjos <tkjos@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 drivers/android/binderfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/android/binderfs.c b/drivers/android/binderfs.c
index 110e41f920c2..f303106b3362 100644
--- a/drivers/android/binderfs.c
+++ b/drivers/android/binderfs.c
@@ -448,6 +448,7 @@ static int binderfs_binder_ctl_create(struct super_block *sb)
 	inode->i_uid = info->root_uid;
 	inode->i_gid = info->root_gid;
 
+	refcount_set(&device->ref, 1);
 	device->binderfs_inode = inode;
 	device->miscdev.minor = minor;
 

base-commit: 2c523b344dfa65a3738e7039832044aa133c75fb
-- 
2.25.1

