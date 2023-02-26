Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6E86A31E1
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 16:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjBZPJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 10:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231791AbjBZPIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 10:08:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E72722791;
        Sun, 26 Feb 2023 06:59:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 736B560C7C;
        Sun, 26 Feb 2023 14:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5FDC433A0;
        Sun, 26 Feb 2023 14:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422994;
        bh=TA+Tz1v7hXIMLtsleefusQBWDuSOjj4AUYxaP/0UQJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qEkHBSFmzfFPwzLQvR2SCIJD9XSn6evYFE9jtJd91Sh+V/P675LSz5lY7ZiLVXpu5
         20R2xp5nBrrj5+3mWe921rMgusU+qaYFgSe7f6HwWzMROFoVv4ttU52PmolZfEyTqu
         fspAk2TfsFrucia/iWw5lnRZVBEOt2DfOCPNdclvwm+8qLyPgPMb9lq1I7+tZt2nWl
         M8bvjkGlbG9ODUkoll+f+lxtEWZqujkybRmblXgM9Ee0xYJbxri82Tu0SxEuB0x76c
         CuEYHhvAwWoz3AumCSz7HdQKOkAyX7NiSrXdP/+up9Cn5gR4GXYyXXVZ3tmxeq471j
         PfZJh32oCSIEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Christian Brauner <brauner@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Arnd Bergmann <arnd@arndb.de>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Alexander Potapenko <glider@google.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Sasha Levin <sashal@kernel.org>, linmiaohe@huawei.com,
        viro@zeniv.linux.org.uk, christophe.leroy@csgroup.eu
Subject: [PATCH AUTOSEL 5.15 28/36] uaccess: Add minimum bounds check on kernel buffer size
Date:   Sun, 26 Feb 2023 09:48:36 -0500
Message-Id: <20230226144845.827893-28-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144845.827893-1-sashal@kernel.org>
References: <20230226144845.827893-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 04ffde1319a715bd0550ded3580d4ea3bc003776 ]

While there is logic about the difference between ksize and usize,
copy_struct_from_user() didn't check the size of the destination buffer
(when it was known) against ksize. Add this check so there is an upper
bounds check on the possible memset() call, otherwise lower bounds
checks made by callers will trigger bounds warnings under -Warray-bounds.
Seen under GCC 13:

In function 'copy_struct_from_user',
    inlined from 'iommufd_fops_ioctl' at
../drivers/iommu/iommufd/main.c:333:8:
../include/linux/fortify-string.h:59:33: warning: '__builtin_memset' offset [57, 4294967294] is out of the bounds [0, 56] of object 'buf' with type 'union ucmd_buffer' [-Warray-bounds=]
   59 | #define __underlying_memset     __builtin_memset
      |                                 ^
../include/linux/fortify-string.h:453:9: note: in expansion of macro '__underlying_memset'
  453 |         __underlying_memset(p, c, __fortify_size); \
      |         ^~~~~~~~~~~~~~~~~~~
../include/linux/fortify-string.h:461:25: note: in expansion of macro '__fortify_memset_chk'
  461 | #define memset(p, c, s) __fortify_memset_chk(p, c, s, \
      |                         ^~~~~~~~~~~~~~~~~~~~
../include/linux/uaccess.h:334:17: note: in expansion of macro 'memset'
  334 |                 memset(dst + size, 0, rest);
      |                 ^~~~~~
../drivers/iommu/iommufd/main.c: In function 'iommufd_fops_ioctl':
../drivers/iommu/iommufd/main.c:311:27: note: 'buf' declared here
  311 |         union ucmd_buffer buf;
      |                           ^~~

Cc: Christian Brauner <brauner@kernel.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alexander Potapenko <glider@google.com>
Acked-by: Aleksa Sarai <cyphar@cyphar.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/lkml/20230203193523.never.667-kees@kernel.org/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/uaccess.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index ac0394087f7d4..e1d59ca6530da 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -338,6 +338,10 @@ copy_struct_from_user(void *dst, size_t ksize, const void __user *src,
 	size_t size = min(ksize, usize);
 	size_t rest = max(ksize, usize) - size;
 
+	/* Double check if ksize is larger than a known object size. */
+	if (WARN_ON_ONCE(ksize > __builtin_object_size(dst, 1)))
+		return -E2BIG;
+
 	/* Deal with trailing bytes. */
 	if (usize < ksize) {
 		memset(dst + size, 0, rest);
-- 
2.39.0

