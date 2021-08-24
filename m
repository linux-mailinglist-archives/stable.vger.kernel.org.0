Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5A53F6792
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241278AbhHXRgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:36:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239950AbhHXRcE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:32:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F03860F25;
        Tue, 24 Aug 2021 17:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824757;
        bh=P8FvGe47cLW7/4/a/mpqzMvKNVWHbfrET0h8Erm1VUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UeXt+/Dss1jquM8f2Ww8uVQPpdpHLBSMxHUMf020TuEuyn+/TQhQ1RLVuosT3+lP1
         Dh+/MA2ockqIy1S1qejb336/+YL/oCgl/lOpmi8zYMGK3D5+A1MiVJYmFrHczRUqP0
         dhiIiUAdFX4oqhIZ1IQn+aMgssNBjtA2Y00aSwwMYG4lkxPdqo/e3EBDCn/sbuhIQj
         BGRUwGnB4j+mFU25tHrO7Z4dtc7rZcipC7zmaatMnVf3bAwVOHOK1fN1x9TFpS0cih
         D2s+C2o2i+hvFo3cwScBSPi5YBv6rrDMyKSGV/rIU24e0dCi43P2ZbhLchRe5WDM8r
         6VxR0VdE3SK0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 61/64] locks: print a warning when mount fails due to lack of "mand" support
Date:   Tue, 24 Aug 2021 13:04:54 -0400
Message-Id: <20210824170457.710623-62-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit df2474a22c42ce419b67067c52d71da06c385501 ]

Since 9e8925b67a ("locks: Allow disabling mandatory locking at compile
time"), attempts to mount filesystems with "-o mand" will fail.
Unfortunately, there is no other indiciation of the reason for the
failure.

Change how the function is defined for better readability. When
CONFIG_MANDATORY_FILE_LOCKING is disabled, printk a warning when
someone attempts to mount with -o mand.

Also, add a blurb to the mandatory-locking.txt file to explain about
the "mand" option, and the behavior one should expect when it is
disabled.

Reported-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/mandatory-locking.txt | 10 ++++++++++
 fs/namespace.c                                  | 11 ++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/mandatory-locking.txt b/Documentation/filesystems/mandatory-locking.txt
index 0979d1d2ca8b..a251ca33164a 100644
--- a/Documentation/filesystems/mandatory-locking.txt
+++ b/Documentation/filesystems/mandatory-locking.txt
@@ -169,3 +169,13 @@ havoc if they lock crucial files. The way around it is to change the file
 permissions (remove the setgid bit) before trying to read or write to it.
 Of course, that might be a bit tricky if the system is hung :-(
 
+7. The "mand" mount option
+--------------------------
+Mandatory locking is disabled on all filesystems by default, and must be
+administratively enabled by mounting with "-o mand". That mount option
+is only allowed if the mounting task has the CAP_SYS_ADMIN capability.
+
+Since kernel v4.5, it is possible to disable mandatory locking
+altogether by setting CONFIG_MANDATORY_FILE_LOCKING to "n". A kernel
+with this disabled will reject attempts to mount filesystems with the
+"mand" mount option with the error status EPERM.
diff --git a/fs/namespace.c b/fs/namespace.c
index 473446ae9e9b..11def59b0d50 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1695,13 +1695,18 @@ static inline bool may_mount(void)
 	return ns_capable(current->nsproxy->mnt_ns->user_ns, CAP_SYS_ADMIN);
 }
 
+#ifdef	CONFIG_MANDATORY_FILE_LOCKING
 static inline bool may_mandlock(void)
 {
-#ifndef	CONFIG_MANDATORY_FILE_LOCKING
-	return false;
-#endif
 	return capable(CAP_SYS_ADMIN);
 }
+#else
+static inline bool may_mandlock(void)
+{
+	pr_warn("VFS: \"mand\" mount option not supported");
+	return false;
+}
+#endif
 
 /*
  * Now umount can handle mount points as well as block devices.
-- 
2.30.2

