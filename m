Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 777314BB9EA
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 14:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbiBRNO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 08:14:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbiBRNO0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 08:14:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860F41B446D;
        Fri, 18 Feb 2022 05:14:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 209B261687;
        Fri, 18 Feb 2022 13:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B61C340E9;
        Fri, 18 Feb 2022 13:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645190048;
        bh=tYfeunHQUCJoMBW4KCGOeDi3CMtMJKFVuq09f4Qy3/c=;
        h=From:To:Cc:Subject:Date:From;
        b=vBbXWXZfhyx61GlN+4nIkKHAofV3Tmyr7SoPL/JEr5O8aDuGGFkaqtwjsuHp/aWJd
         NyVHxUGohJ8znulkcU6/mgN478hdbs6CnYqpPVU4HyjCX7mZdBjeSEtJOQLoG+JX8i
         tfgZ0yR1aFtzmkQnXpRV3CxMiyI7vkizA2SIxd24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Daniel Micay <danielmicay@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Nathan Chancellor <nathan@kernel.org>, linux-mm@kvack.org,
        llvm@lists.linux.dev
Subject: [PATCH] slab: remove __alloc_size attribute from __kmalloc_track_caller
Date:   Fri, 18 Feb 2022 14:13:58 +0100
Message-Id: <20220218131358.3032912-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1953; h=from:subject; bh=tYfeunHQUCJoMBW4KCGOeDi3CMtMJKFVuq09f4Qy3/c=; b=owGbwMvMwCRo6H6F97bub03G02pJDEn8s6c4O30y6vORX/ORQXjx0QO+yZ+7OfqrVN2bJEW4TmtN 7uPpiGVhEGRikBVTZPmyjefo/opDil6Gtqdh5rAygQxh4OIUgIlYJDIsaL/7pkRd/rig6sTwLMFXHx PEKo9OYpifbbZwheqTPMfejscylVHLrm1gNdQFAA==
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit c37495d6254c ("slab: add __alloc_size attributes for better
bounds checking") added __alloc_size attributes to a bunch of kmalloc
function prototypes.  Unfortunately the change to __kmalloc_track_caller
seems to cause clang to generate broken code and the first time this is
called when booting, the box will crash.

While the compiler problems are being reworked and attempted to be
solved, let's just drop the attribute to solve the issue now.  Once it
is resolved it can be added back.

Fixes: c37495d6254c ("slab: add __alloc_size attributes for better bounds checking")
Cc: stable <stable@vger.kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/slab.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 37bde99b74af..5b6193fd8bd9 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -660,8 +660,7 @@ static inline __alloc_size(1, 2) void *kcalloc(size_t n, size_t size, gfp_t flag
  * allocator where we care about the real place the memory allocation
  * request comes from.
  */
-extern void *__kmalloc_track_caller(size_t size, gfp_t flags, unsigned long caller)
-				   __alloc_size(1);
+extern void *__kmalloc_track_caller(size_t size, gfp_t flags, unsigned long caller);
 #define kmalloc_track_caller(size, flags) \
 	__kmalloc_track_caller(size, flags, _RET_IP_)
 
-- 
2.35.1

