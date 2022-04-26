Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E015F50F4FA
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345399AbiDZIkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345543AbiDZIjN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:39:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A674642F;
        Tue, 26 Apr 2022 01:30:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA4CCB81D02;
        Tue, 26 Apr 2022 08:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3883CC385A0;
        Tue, 26 Apr 2022 08:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961806;
        bh=P4wHU4paOkXJSzIawgcr2zWj4eVddDDxzhzoHnGO/ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=orwfdJF7WAbHyz4wWCp4x7QV6CLujq5lfeyttOEf4OznXEc83MNWn12DtTzDwQgWF
         Jx1VyIdsrpD+uR7AmY8Iy1grndNXHgHKNLDLEEIkq180cQBFG9SirSAQTNR/heAlox
         bPUIBveAhUD+uO6mgHY96JkO2iZPx+wRZiTRRpdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 35/62] stat: fix inconsistency between struct stat and struct compat_stat
Date:   Tue, 26 Apr 2022 10:21:15 +0200
Message-Id: <20220426081738.230895289@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081737.209637816@linuxfoundation.org>
References: <20220426081737.209637816@linuxfoundation.org>
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
index 22c4dfe65992..b4dd6ab0fdfc 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -31,15 +31,13 @@ typedef s64 __attribute__((aligned(4))) compat_s64;
 typedef u64 __attribute__((aligned(4))) compat_u64;
 
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
index c38e4c2e1221..268c9eb89656 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -290,9 +290,6 @@ SYSCALL_DEFINE2(fstat, unsigned int, fd, struct __old_kernel_stat __user *, stat
 #  define choose_32_64(a,b) b
 #endif
 
-#define valid_dev(x)  choose_32_64(old_valid_dev(x),true)
-#define encode_dev(x) choose_32_64(old_encode_dev,new_encode_dev)(x)
-
 #ifndef INIT_STRUCT_STAT_PADDING
 #  define INIT_STRUCT_STAT_PADDING(st) memset(&st, 0, sizeof(st))
 #endif
@@ -301,7 +298,9 @@ static int cp_new_stat(struct kstat *stat, struct stat __user *statbuf)
 {
 	struct stat tmp;
 
-	if (!valid_dev(stat->dev) || !valid_dev(stat->rdev))
+	if (sizeof(tmp.st_dev) < 4 && !old_valid_dev(stat->dev))
+		return -EOVERFLOW;
+	if (sizeof(tmp.st_rdev) < 4 && !old_valid_dev(stat->rdev))
 		return -EOVERFLOW;
 #if BITS_PER_LONG == 32
 	if (stat->size > MAX_NON_LFS)
@@ -309,7 +308,7 @@ static int cp_new_stat(struct kstat *stat, struct stat __user *statbuf)
 #endif
 
 	INIT_STRUCT_STAT_PADDING(tmp);
-	tmp.st_dev = encode_dev(stat->dev);
+	tmp.st_dev = new_encode_dev(stat->dev);
 	tmp.st_ino = stat->ino;
 	if (sizeof(tmp.st_ino) < sizeof(stat->ino) && tmp.st_ino != stat->ino)
 		return -EOVERFLOW;
@@ -319,7 +318,7 @@ static int cp_new_stat(struct kstat *stat, struct stat __user *statbuf)
 		return -EOVERFLOW;
 	SET_UID(tmp.st_uid, from_kuid_munged(current_user_ns(), stat->uid));
 	SET_GID(tmp.st_gid, from_kgid_munged(current_user_ns(), stat->gid));
-	tmp.st_rdev = encode_dev(stat->rdev);
+	tmp.st_rdev = new_encode_dev(stat->rdev);
 	tmp.st_size = stat->size;
 	tmp.st_atime = stat->atime.tv_sec;
 	tmp.st_mtime = stat->mtime.tv_sec;
@@ -593,11 +592,13 @@ static int cp_compat_stat(struct kstat *stat, struct compat_stat __user *ubuf)
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
@@ -607,7 +608,7 @@ static int cp_compat_stat(struct kstat *stat, struct compat_stat __user *ubuf)
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



