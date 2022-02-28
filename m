Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C845F4C75B0
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239190AbiB1R4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:56:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240783AbiB1Ryp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE5952E72;
        Mon, 28 Feb 2022 09:43:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA075B815B3;
        Mon, 28 Feb 2022 17:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5C6C340E7;
        Mon, 28 Feb 2022 17:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070199;
        bh=LooQy0wNydj8kHhRYE5mtQl6DAH/C3OhSN4ERmFREeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KUrWy9kIB70MvQA+1IiCdCBYwKHBPsCJ04wJqZLDl2S/5Ib2T1llGH6BvVnvVDhLz
         37WTBdnMAdZ5NsWehc6aHCFy6Ik9WrqNxrdeJjJsszsWGC/kOSAQ5SBiV2D3YzSCYo
         d/jCwDtLBkzKQ2NmwAKy3lVdAOHEmAxo3MCxLMWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Daniel Micay <danielmicay@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Nathan Chancellor <nathan@kernel.org>, linux-mm@kvack.org,
        llvm@lists.linux.dev, David Rientjes <rientjes@google.com>
Subject: [PATCH 5.16 006/164] slab: remove __alloc_size attribute from __kmalloc_track_caller
Date:   Mon, 28 Feb 2022 18:22:48 +0100
Message-Id: <20220228172400.279076305@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 93dd04ab0b2b32ae6e70284afc764c577156658e upstream.

Commit c37495d6254c ("slab: add __alloc_size attributes for better
bounds checking") added __alloc_size attributes to a bunch of kmalloc
function prototypes.  Unfortunately the change to __kmalloc_track_caller
seems to cause clang to generate broken code and the first time this is
called when booting, the box will crash.

While the compiler problems are being reworked and attempted to be
solved [1], let's just drop the attribute to solve the issue now.  Once
it is resolved it can be added back.

[1] https://github.com/ClangBuiltLinux/linux/issues/1599

Fixes: c37495d6254c ("slab: add __alloc_size attributes for better bounds checking")
Cc: stable <stable@vger.kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Link: https://lore.kernel.org/r/20220218131358.3032912-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/slab.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -669,8 +669,7 @@ static inline __alloc_size(1, 2) void *k
  * allocator where we care about the real place the memory allocation
  * request comes from.
  */
-extern void *__kmalloc_track_caller(size_t size, gfp_t flags, unsigned long caller)
-				   __alloc_size(1);
+extern void *__kmalloc_track_caller(size_t size, gfp_t flags, unsigned long caller);
 #define kmalloc_track_caller(size, flags) \
 	__kmalloc_track_caller(size, flags, _RET_IP_)
 


