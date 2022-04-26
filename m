Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB61450F47F
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241749AbiDZIgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345163AbiDZIfT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:35:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AFC8118A;
        Tue, 26 Apr 2022 01:28:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E9D1617EB;
        Tue, 26 Apr 2022 08:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231E2C385A4;
        Tue, 26 Apr 2022 08:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961719;
        bh=9lkgGUSywJBVA/Yy+yRWSnkX0eORQBfLy/DH2DANk5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B7j2frs4ARHu5HcU2HnTfDwLn6TiD48Il6iYv71dOoCvHb6RAb9uklaEQTabK75M7
         nJ8xVZ5n+JcTra/A2oCbOttlNnsb0P8777qg1mAujymeS+BZ2BbYNMQlY9Rh+3G+S9
         z44N8Jnbhaa5x69uPV7kOLmxQsa1FrRccvqK8V5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 28/53] stat: fix inconsistency between struct stat and struct compat_stat
Date:   Tue, 26 Apr 2022 10:21:08 +0200
Message-Id: <20220426081736.473888708@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081735.651926456@linuxfoundation.org>
References: <20220426081735.651926456@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 932aba1e169090357a77af18850a10c256b50819 ]

struct stat (defined in arch/x86/include/uapi/asm/stat.h) has 32-bit
st_dev and st_rdev; struct compat_stat (defined in
arch/x86/include/asm/compat.h) has 16-bit st_dev and st_rdev followed by
a 16-bit padding.

This patch fixes struct compat_stat to match struct stat.

[ Historical note: the old x86 'struct stat' did have that 16-bit field
  that the compat layer had kept around, but it was changes back in 2003
  by "struct stat - support larger dev_t":

    https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git/commit/?id=e95b2065677fe32512a597a79db94b77b90c968d

  and back in those days, the x86_64 port was still new, and separate
  from the i386 code, and had already picked up the old version with a
  16-bit st_dev field ]

Note that we can't change compat_dev_t because it is used by
compat_loop_info.

Also, if the st_dev and st_rdev values are 32-bit, we don't have to use
old_valid_dev to test if the value fits into them.  This fixes
-EOVERFLOW on filesystems that are on NVMe because NVMe uses the major
number 259.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/compat.h |  6 ++----
 fs/stat.c                     | 19 ++++++++++---------
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index fb97cf7c4137..1def972b6ca3 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -46,15 +46,13 @@ typedef u64 __attribute__((aligned(4))) compat_u64;
 typedef u32		compat_uptr_t;
 
 struct compat_stat {
-	compat_dev_t	st_dev;
-	u16		__pad1;
+	u32		st_dev;
 	compat_ino_t	st_ino;
 	compat_mode_t	st_mode;
 	compat_nlink_t	st_nlink;
 	__compat_uid_t	st_uid;
 	__compat_gid_t	st_gid;
-	compat_dev_t	st_rdev;
-	u16		__pad2;
+	u32		st_rdev;
 	u32		st_size;
 	u32		st_blksize;
 	u32		st_blocks;
diff --git a/fs/stat.c b/fs/stat.c
index f8e6fb2c3657..376543199b5a 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -286,9 +286,6 @@ SYSCALL_DEFINE2(fstat, unsigned int, fd, struct __old_kernel_stat __user *, stat
 #  define choose_32_64(a,b) b
 #endif
 
-#define valid_dev(x)  choose_32_64(old_valid_dev(x),true)
-#define encode_dev(x) choose_32_64(old_encode_dev,new_encode_dev)(x)
-
 #ifndef INIT_STRUCT_STAT_PADDING
 #  define INIT_STRUCT_STAT_PADDING(st) memset(&st, 0, sizeof(st))
 #endif
@@ -297,7 +294,9 @@ static int cp_new_stat(struct kstat *stat, struct stat __user *statbuf)
 {
 	struct stat tmp;
 
-	if (!valid_dev(stat->dev) || !valid_dev(stat->rdev))
+	if (sizeof(tmp.st_dev) < 4 && !old_valid_dev(stat->dev))
+		return -EOVERFLOW;
+	if (sizeof(tmp.st_rdev) < 4 && !old_valid_dev(stat->rdev))
 		return -EOVERFLOW;
 #if BITS_PER_LONG == 32
 	if (stat->size > MAX_NON_LFS)
@@ -305,7 +304,7 @@ static int cp_new_stat(struct kstat *stat, struct stat __user *statbuf)
 #endif
 
 	INIT_STRUCT_STAT_PADDING(tmp);
-	tmp.st_dev = encode_dev(stat->dev);
+	tmp.st_dev = new_encode_dev(stat->dev);
 	tmp.st_ino = stat->ino;
 	if (sizeof(tmp.st_ino) < sizeof(stat->ino) && tmp.st_ino != stat->ino)
 		return -EOVERFLOW;
@@ -315,7 +314,7 @@ static int cp_new_stat(struct kstat *stat, struct stat __user *statbuf)
 		return -EOVERFLOW;
 	SET_UID(tmp.st_uid, from_kuid_munged(current_user_ns(), stat->uid));
 	SET_GID(tmp.st_gid, from_kgid_munged(current_user_ns(), stat->gid));
-	tmp.st_rdev = encode_dev(stat->rdev);
+	tmp.st_rdev = new_encode_dev(stat->rdev);
 	tmp.st_size = stat->size;
 	tmp.st_atime = stat->atime.tv_sec;
 	tmp.st_mtime = stat->mtime.tv_sec;
@@ -588,11 +587,13 @@ static int cp_compat_stat(struct kstat *stat, struct compat_stat __user *ubuf)
 {
 	struct compat_stat tmp;
 
-	if (!old_valid_dev(stat->dev) || !old_valid_dev(stat->rdev))
+	if (sizeof(tmp.st_dev) < 4 && !old_valid_dev(stat->dev))
+		return -EOVERFLOW;
+	if (sizeof(tmp.st_rdev) < 4 && !old_valid_dev(stat->rdev))
 		return -EOVERFLOW;
 
 	memset(&tmp, 0, sizeof(tmp));
-	tmp.st_dev = old_encode_dev(stat->dev);
+	tmp.st_dev = new_encode_dev(stat->dev);
 	tmp.st_ino = stat->ino;
 	if (sizeof(tmp.st_ino) < sizeof(stat->ino) && tmp.st_ino != stat->ino)
 		return -EOVERFLOW;
@@ -602,7 +603,7 @@ static int cp_compat_stat(struct kstat *stat, struct compat_stat __user *ubuf)
 		return -EOVERFLOW;
 	SET_UID(tmp.st_uid, from_kuid_munged(current_user_ns(), stat->uid));
 	SET_GID(tmp.st_gid, from_kgid_munged(current_user_ns(), stat->gid));
-	tmp.st_rdev = old_encode_dev(stat->rdev);
+	tmp.st_rdev = new_encode_dev(stat->rdev);
 	if ((u64) stat->size > MAX_NON_LFS)
 		return -EOVERFLOW;
 	tmp.st_size = stat->size;
-- 
2.35.1



