Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59634594D39
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238741AbiHPAw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244612AbiHPAuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:50:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A841B5160;
        Mon, 15 Aug 2022 13:46:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9A32B80EB1;
        Mon, 15 Aug 2022 20:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A11C433D6;
        Mon, 15 Aug 2022 20:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596357;
        bh=V2/mh1k9Uk+itrV3o3kw5XDjTceOvOUITZxxSgSKmPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZeLVLzIAa9Zs2hlVgrYXZdeTmzTRt6qbuw+QW6MySEfuY4rle2O9M3GFKYKJSpLiZ
         b+5p84Z69ihN7ZCDg3eIv3jyB7Nk2h6SBuHk7nqYkyWHfTxjroIv7zhS+uNLC7vnbD
         M2FM4dJ+qNiojf/0ihRly++iUUkO76C531s4LwfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>,
        Guo Ren <guoren@kernel.org>
Subject: [PATCH 5.19 1055/1157] csky: abiv1: Fixup compile error
Date:   Mon, 15 Aug 2022 20:06:51 +0200
Message-Id: <20220815180522.260637041@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

commit 45fef4c4b9c94e86d9c13f0b2e7e71bb32254509 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
2.37.2



