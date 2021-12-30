Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3DBE481FD6
	for <lists+stable@lfdr.de>; Thu, 30 Dec 2021 20:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241765AbhL3TXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Dec 2021 14:23:31 -0500
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:44142
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240217AbhL3TXa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Dec 2021 14:23:30 -0500
Received: from wittgenstein.fritz.box (ip5f5bd15c.dynamic.kabel-deutschland.de [95.91.209.92])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id C86CF3F12E;
        Thu, 30 Dec 2021 19:23:22 +0000 (UTC)
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH] fs/mount_setattr: always cleanup mount_kattr
Date:   Thu, 30 Dec 2021 20:23:09 +0100
Message-Id: <20211230192309.115524-1-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure that finish_mount_kattr() is called after mount_kattr was
succesfully built in both the success and failure case to prevent
leaking any references we took when we built it. So far we returned
early if path lookup failed thereby risking to leak an additional
reference we took when building mount_kattr when an idmapped mount was
requested.

Cc: linux-fsdevel@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
Hey Linus,

This contains a simple fix to get rid of a pointless refcount bump when
requesting an idmapped mount after we built mount_kattr but in case we
failed too lookup the target path and error out early without calling
finish_mount_kattr().

Would you be ok with applying this fix directly? I'm happy to send a pr
too of course but I wasn't sure if that was worth it as there's not much
explaining to do in the pr message for this one, I think.

This hasn't been in -next but given that it hasn't been updated in about
a week I don't think it makes much sense to delay this. The fix should
hopefully be straightforward.
Fstests and mount_setattr selftests pass without regressions
(showing only relevant tests):

SECTION       -- xfs
RECREATING    -- xfs on /dev/loop4
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 f2-vm 5.16.0-rc7-fs-mount-setattr-fixes-1a24ab33373b #33 SMP PREEMPT Thu Dec 30 15:55:39 UTC 2021
MKFS_OPTIONS  -- -f -f /dev/loop5
MOUNT_OPTIONS -- /dev/loop5 /mnt/scratch

generic/633 5s ...  25s
generic/644 18s ...  14s
generic/645 80s ...  75s
generic/656 3s ...  15s
xfs/152 63s ...  70s
xfs/153 43s ...  46s
Ran: generic/633 generic/644 generic/645 generic/656 xfs/152 xfs/153
Passed all 6 tests

SECTION       -- ext4
RECREATING    -- ext4 on /dev/loop4
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 f2-vm 5.16.0-rc7-fs-mount-setattr-fixes-1a24ab33373b #33 SMP PREEMPT Thu Dec 30 15:55:39 UTC 2021
MKFS_OPTIONS  -- -F -F /dev/loop5
MOUNT_OPTIONS -- -o acl,user_xattr /dev/loop5 /mnt/scratch

generic/633 25s ...  18s
generic/644 14s ...  4s
generic/645 75s ...  59s
generic/656 15s ...  8s
Ran: generic/633 generic/644 generic/645 generic/656
Passed all 4 tests

SECTION       -- btrfs
RECREATING    -- btrfs on /dev/loop4
FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 f2-vm 5.16.0-rc7-fs-mount-setattr-fixes-1a24ab33373b #33 SMP PREEMPT Thu Dec 30 15:55:39 UTC 2021
MKFS_OPTIONS  -- -f /dev/loop5
MOUNT_OPTIONS -- /dev/loop5 /mnt/scratch

btrfs/245 9s ...  10s
generic/633 18s ...  21s
generic/644 4s ...  4s
generic/645 59s ...  62s
generic/656 8s ...  8s
Ran: btrfs/245 generic/633 generic/644 generic/645 generic/656
Passed all 5 tests

SECTION       -- xfs
=========================
Ran: generic/633 generic/644 generic/645 generic/656 xfs/152 xfs/153
Passed all 6 tests

SECTION       -- ext4
=========================
Ran: generic/633 generic/644 generic/645 generic/656
Passed all 4 tests

SECTION       -- btrfs
=========================
Ran: btrfs/245 generic/633 generic/644 generic/645 generic/656
Passed all 5 tests

Thanks!
Christian
---
 fs/namespace.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 659a8f39c61a..b696543adab8 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4263,12 +4263,11 @@ SYSCALL_DEFINE5(mount_setattr, int, dfd, const char __user *, path,
 		return err;
 
 	err = user_path_at(dfd, path, kattr.lookup_flags, &target);
-	if (err)
-		return err;
-
-	err = do_mount_setattr(&target, &kattr);
+	if (!err) {
+		err = do_mount_setattr(&target, &kattr);
+		path_put(&target);
+	}
 	finish_mount_kattr(&kattr);
-	path_put(&target);
 	return err;
 }
 

base-commit: fc74e0a40e4f9fd0468e34045b0c45bba11dcbb2
-- 
2.30.2

