Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F685675F9
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 22:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbfGLUgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 16:36:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727118AbfGLUgl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 16:36:41 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB0F7217D4;
        Fri, 12 Jul 2019 20:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562963799;
        bh=iR7dMCSXjJ7LjcyHRfuHBHJMcI0Y/YC1058yuIdMVOE=;
        h=Date:From:To:Subject:From;
        b=M1PsKowrjVTRrha9rBjvNvFs0Zfdt/S+RmuPS7GthLV27kstBWB2Qa+lMz9oUlWWb
         5EdHIjiF7truRipWXaQl9mpvTONT0xiLLit9c/MRAELUaz76YpqVkOgPyQlh5l67eP
         FWmR47sMmZfdT0iPBBo9aMQaBRNscTC0ZUQ8eLis=
Date:   Fri, 12 Jul 2019 13:36:39 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, gregkh@linuxfoundation.org, joe@perches.com,
        konishi.ryusuke@gmail.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, yamada.masahiro@socionext.com
Subject:  [merged]
 nilfs2-do-not-use-unexported-cpu_to_le32-le32_to_cpu-in-uapi-header.patch
 removed from -mm tree
Message-ID: <20190712203639.rqDUzsCwl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: nilfs2: do not use unexported cpu_to_le32()/le32_to_cpu() in uapi header
has been removed from the -mm tree.  Its filename was
     nilfs2-do-not-use-unexported-cpu_to_le32-le32_to_cpu-in-uapi-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: nilfs2: do not use unexported cpu_to_le32()/le32_to_cpu() in uapi header

cpu_to_le32/le32_to_cpu is defined in include/linux/byteorder/generic.h,
which is not exported to user-space.

UAPI headers must use the ones prefixed with double-underscore.

Detected by compile-testing exported headers:

./usr/include/linux/nilfs2_ondisk.h: In function `nilfs_checkpoint_set_snapshot':
./usr/include/linux/nilfs2_ondisk.h:536:17: error: implicit declaration of function `cpu_to_le32' [-Werror=implicit-function-declaration]
  cp->cp_flags = cpu_to_le32(le32_to_cpu(cp->cp_flags) |  \
                 ^
./usr/include/linux/nilfs2_ondisk.h:552:1: note: in expansion of macro `NILFS_CHECKPOINT_FNS'
 NILFS_CHECKPOINT_FNS(SNAPSHOT, snapshot)
 ^~~~~~~~~~~~~~~~~~~~
./usr/include/linux/nilfs2_ondisk.h:536:29: error: implicit declaration of function `le32_to_cpu' [-Werror=implicit-function-declaration]
  cp->cp_flags = cpu_to_le32(le32_to_cpu(cp->cp_flags) |  \
                             ^
./usr/include/linux/nilfs2_ondisk.h:552:1: note: in expansion of macro `NILFS_CHECKPOINT_FNS'
 NILFS_CHECKPOINT_FNS(SNAPSHOT, snapshot)
 ^~~~~~~~~~~~~~~~~~~~
./usr/include/linux/nilfs2_ondisk.h: In function `nilfs_segment_usage_set_clean':
./usr/include/linux/nilfs2_ondisk.h:622:19: error: implicit declaration of function `cpu_to_le64' [-Werror=implicit-function-declaration]
  su->su_lastmod = cpu_to_le64(0);
                   ^~~~~~~~~~~

Link: http://lkml.kernel.org/r/20190605053006.14332-1-yamada.masahiro@socionext.com
Fixes: e63e88bc53ba ("nilfs2: move ioctl interface and disk layout to uapi separately")
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: <stable@vger.kernel.org>	[4.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/nilfs2_ondisk.h |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/include/uapi/linux/nilfs2_ondisk.h~nilfs2-do-not-use-unexported-cpu_to_le32-le32_to_cpu-in-uapi-header
+++ a/include/uapi/linux/nilfs2_ondisk.h
@@ -29,7 +29,7 @@
 
 #include <linux/types.h>
 #include <linux/magic.h>
-
+#include <asm/byteorder.h>
 
 #define NILFS_INODE_BMAP_SIZE	7
 
@@ -533,19 +533,19 @@ enum {
 static inline void							\
 nilfs_checkpoint_set_##name(struct nilfs_checkpoint *cp)		\
 {									\
-	cp->cp_flags = cpu_to_le32(le32_to_cpu(cp->cp_flags) |		\
-				   (1UL << NILFS_CHECKPOINT_##flag));	\
+	cp->cp_flags = __cpu_to_le32(__le32_to_cpu(cp->cp_flags) |	\
+				     (1UL << NILFS_CHECKPOINT_##flag));	\
 }									\
 static inline void							\
 nilfs_checkpoint_clear_##name(struct nilfs_checkpoint *cp)		\
 {									\
-	cp->cp_flags = cpu_to_le32(le32_to_cpu(cp->cp_flags) &		\
+	cp->cp_flags = __cpu_to_le32(__le32_to_cpu(cp->cp_flags) &	\
 				   ~(1UL << NILFS_CHECKPOINT_##flag));	\
 }									\
 static inline int							\
 nilfs_checkpoint_##name(const struct nilfs_checkpoint *cp)		\
 {									\
-	return !!(le32_to_cpu(cp->cp_flags) &				\
+	return !!(__le32_to_cpu(cp->cp_flags) &				\
 		  (1UL << NILFS_CHECKPOINT_##flag));			\
 }
 
@@ -595,20 +595,20 @@ enum {
 static inline void							\
 nilfs_segment_usage_set_##name(struct nilfs_segment_usage *su)		\
 {									\
-	su->su_flags = cpu_to_le32(le32_to_cpu(su->su_flags) |		\
+	su->su_flags = __cpu_to_le32(__le32_to_cpu(su->su_flags) |	\
 				   (1UL << NILFS_SEGMENT_USAGE_##flag));\
 }									\
 static inline void							\
 nilfs_segment_usage_clear_##name(struct nilfs_segment_usage *su)	\
 {									\
 	su->su_flags =							\
-		cpu_to_le32(le32_to_cpu(su->su_flags) &			\
+		__cpu_to_le32(__le32_to_cpu(su->su_flags) &		\
 			    ~(1UL << NILFS_SEGMENT_USAGE_##flag));      \
 }									\
 static inline int							\
 nilfs_segment_usage_##name(const struct nilfs_segment_usage *su)	\
 {									\
-	return !!(le32_to_cpu(su->su_flags) &				\
+	return !!(__le32_to_cpu(su->su_flags) &				\
 		  (1UL << NILFS_SEGMENT_USAGE_##flag));			\
 }
 
@@ -619,15 +619,15 @@ NILFS_SEGMENT_USAGE_FNS(ERROR, error)
 static inline void
 nilfs_segment_usage_set_clean(struct nilfs_segment_usage *su)
 {
-	su->su_lastmod = cpu_to_le64(0);
-	su->su_nblocks = cpu_to_le32(0);
-	su->su_flags = cpu_to_le32(0);
+	su->su_lastmod = __cpu_to_le64(0);
+	su->su_nblocks = __cpu_to_le32(0);
+	su->su_flags = __cpu_to_le32(0);
 }
 
 static inline int
 nilfs_segment_usage_clean(const struct nilfs_segment_usage *su)
 {
-	return !le32_to_cpu(su->su_flags);
+	return !__le32_to_cpu(su->su_flags);
 }
 
 /**
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

linux-bitsh-make-bit-genmask-and-friends-available-in-assembly.patch
arch-replace-_bitul-in-kernel-space-headers-with-bit.patch

