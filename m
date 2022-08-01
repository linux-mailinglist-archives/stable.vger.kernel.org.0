Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 514355862C6
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 04:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239369AbiHACmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jul 2022 22:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239316AbiHACms (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jul 2022 22:42:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E565A13D2D;
        Sun, 31 Jul 2022 19:42:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 791E6B80DCC;
        Mon,  1 Aug 2022 02:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03BBC433D7;
        Mon,  1 Aug 2022 02:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659321764;
        bh=Jgmay4Wp8fySBQ0xkLEHDoGHR4fdNJxu7+B9UiG4oaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nfyTwg3NjIeYyCPXBgJ5BwOJ5/w+uUN/llI5m0HgbVwuWNr1MzKRo0kZipx5dyZLx
         eNq55CIfq8YrntsPldAaV8InUntvko66Dhmw61capP2X97kliqUX2/FW/PhUwEbj9j
         J6RtUqPHYLaM7gfgkNCvHes6ADZjJRW1jwVkjD8gxlATnQ9cQDwNyPS1KeO6PB9V8j
         1CnLXZad1p+KyY2ui5vqtoNq39Jst/Scx28h9nnv7LbRtRD8/OaKJKAZhNCiizSwqr
         koDRr6OK0z9+6HhAxaVJD5D0Lnk1yAJBE6DjES/MOmvhTHyFVfWj80YOlSuiyOXW5u
         0+xzgKXT1BvgA==
From:   guoren@kernel.org
To:     guoren@kernel.org, arnd@arndb.de
Cc:     linux-csky@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] csky: abiv1: Fixup compile error
Date:   Sun, 31 Jul 2022 22:42:29 -0400
Message-Id: <20220801024229.567397-3-guoren@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220801024229.567397-1-guoren@kernel.org>
References: <20220801024229.567397-1-guoren@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

  LD      vmlinux.o
arch/csky/lib/string.o: In function `memmove':
string.c:(.text+0x108): multiple definition of `memmove'
lib/string.o:string.c:(.text+0x7e8): first defined here
arch/csky/lib/string.o: In function `memset':
string.c:(.text+0x148): multiple definition of `memset'
lib/string.o:string.c:(.text+0x2ac): first defined here
scripts/Makefile.vmlinux_o:68: recipe for target 'vmlinux.o' failed
make[4]: *** [vmlinux.o] Error 1

Fixes: e4df2d5e852a ("csky: Add C based string functions")
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Cc: <stable@vger.kernel.org>
---
 arch/csky/abiv1/inc/abi/string.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/csky/abiv1/inc/abi/string.h b/arch/csky/abiv1/inc/abi/string.h
index 9d95594b0feb..de50117b904d 100644
--- a/arch/csky/abiv1/inc/abi/string.h
+++ b/arch/csky/abiv1/inc/abi/string.h
@@ -6,4 +6,10 @@
 #define __HAVE_ARCH_MEMCPY
 extern void *memcpy(void *, const void *, __kernel_size_t);
 
+#define __HAVE_ARCH_MEMMOVE
+extern void *memmove(void *, const void *, __kernel_size_t);
+
+#define __HAVE_ARCH_MEMSET
+extern void *memset(void *, int,  __kernel_size_t);
+
 #endif /* __ABI_CSKY_STRING_H */
-- 
2.36.1

