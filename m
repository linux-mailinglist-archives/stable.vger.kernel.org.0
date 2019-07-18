Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8686C7B6
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389263AbfGRDDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:03:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389252AbfGRDDV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:03:21 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62E932173B;
        Thu, 18 Jul 2019 03:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419000;
        bh=EOqjTyZARP8Mz1ivHyEMBzL8+5UqiihTHldWS5cAR2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2HR06FedZxaz7DJY0pBnjLjfnXIL+pSXL/k/Wg0iEkJqzBBha2aWgygD1hyHDB3Vf
         BPzKYmy5Kpqz20Sd25KagtOdZCDGdv6knRN82EoO5AZy55UUhQzCf/PEVopwr16DuW
         cW5CqChZW5C951D0Midxt+2YucTBrR/ZLbnwFRgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.2 04/21] nilfs2: do not use unexported cpu_to_le32()/le32_to_cpu() in uapi header
Date:   Thu, 18 Jul 2019 12:01:22 +0900
Message-Id: <20190718030031.251273422@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030030.456918453@linuxfoundation.org>
References: <20190718030030.456918453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

commit c32cc30c0544f13982ee0185d55f4910319b1a79 upstream.

cpu_to_le32/le32_to_cpu is defined in include/linux/byteorder/generic.h,
which is not exported to user-space.

UAPI headers must use the ones prefixed with double-underscore.

Detected by compile-testing exported headers:

  include/linux/nilfs2_ondisk.h: In function `nilfs_checkpoint_set_snapshot':
  include/linux/nilfs2_ondisk.h:536:17: error: implicit declaration of function `cpu_to_le32' [-Werror=implicit-function-declaration]
    cp->cp_flags = cpu_to_le32(le32_to_cpu(cp->cp_flags) |  \
                   ^
  include/linux/nilfs2_ondisk.h:552:1: note: in expansion of macro `NILFS_CHECKPOINT_FNS'
   NILFS_CHECKPOINT_FNS(SNAPSHOT, snapshot)
   ^~~~~~~~~~~~~~~~~~~~
  include/linux/nilfs2_ondisk.h:536:29: error: implicit declaration of function `le32_to_cpu' [-Werror=implicit-function-declaration]
    cp->cp_flags = cpu_to_le32(le32_to_cpu(cp->cp_flags) |  \
                               ^
  include/linux/nilfs2_ondisk.h:552:1: note: in expansion of macro `NILFS_CHECKPOINT_FNS'
   NILFS_CHECKPOINT_FNS(SNAPSHOT, snapshot)
   ^~~~~~~~~~~~~~~~~~~~
  include/linux/nilfs2_ondisk.h: In function `nilfs_segment_usage_set_clean':
  include/linux/nilfs2_ondisk.h:622:19: error: implicit declaration of function `cpu_to_le64' [-Werror=implicit-function-declaration]
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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/nilfs2_ondisk.h |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/include/uapi/linux/nilfs2_ondisk.h
+++ b/include/uapi/linux/nilfs2_ondisk.h
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


