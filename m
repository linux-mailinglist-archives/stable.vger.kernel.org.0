Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9DCC6AF4E0
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233973AbjCGTU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233975AbjCGTUg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:20:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA56BE5E0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:04:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33CD2B817C2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF34C433EF;
        Tue,  7 Mar 2023 19:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215857;
        bh=dHmQc+zuI2cga+uOwR51nm2skrSVafvpwfFfFQSDK6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+MmhzEapcepGyFh8OqeGCzoKznrXhX5IcPRPijGXNE/XWIi/rG4pOqA7cG+RFWgc
         Ic/RkJH7IsY77cZdLScAoz3EoCgzVZ+SCvgNcsU+F/GKDnTB4DEwyT4VPONPBgR1kq
         4fhR5EFW5JXGf6flijxwBa2Urqnhg4LTZLAYd9yU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christian Brauner <brauner@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Arnd Bergmann <arnd@arndb.de>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Alexander Potapenko <glider@google.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 395/567] uaccess: Add minimum bounds check on kernel buffer size
Date:   Tue,  7 Mar 2023 18:02:11 +0100
Message-Id: <20230307165922.972909849@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
2.39.2



