Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA64D4FABE3
	for <lists+stable@lfdr.de>; Sun, 10 Apr 2022 06:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiDJElP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Apr 2022 00:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbiDJElO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Apr 2022 00:41:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A78266F;
        Sat,  9 Apr 2022 21:39:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6665A60E96;
        Sun, 10 Apr 2022 04:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD33EC385A5;
        Sun, 10 Apr 2022 04:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649565544;
        bh=F7NXCo3BShYwzhu1beSltfpaw3cNYNlX1xGhFYlMMI0=;
        h=Date:To:From:Subject:From;
        b=q5KqZGEdJB90JBPWZIChKDQbpYfU3zI2/5OA5LXIyomstiw00PQnXGUVDdXRZONME
         nzCFF/kyhsqN8rpg4eP7Gqr7EvDF9IIcVW+TNp73R7BTWMcaHW4BwaJLsjKC1fTl2l
         nhfxFA0qrCVyIeGGS6uozwyqfx0sDi6oYb3ph3G8=
Date:   Sat, 09 Apr 2022 21:39:03 -0700
To:     mm-commits@vger.kernel.org, terrelln@fb.com,
        stable@vger.kernel.org, hsiangkao@linux.alibaba.com,
        cy.fan@huawei.com, cyan@fb.com, guoxuenan@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] lz4-fix-lz4_decompress_safe_partial-read-out-of-bound.patch removed from -mm tree
Message-Id: <20220410043904.AD33EC385A5@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: lz4: fix LZ4_decompress_safe_partial read out of bound
has been removed from the -mm tree.  Its filename was
     lz4-fix-lz4_decompress_safe_partial-read-out-of-bound.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guo Xuenan <guoxuenan@huawei.com>
Subject: lz4: fix LZ4_decompress_safe_partial read out of bound

When partialDecoding, it is EOF if we've either filled the output buffer
or can't proceed with reading an offset for following match.

In some extreme corner cases when compressed data is suitably
corrupted, UAF will occur.  As reported by KASAN [1],
LZ4_decompress_safe_partial may lead to read out of bound problem
during decoding.  lz4 upstream has fixed it [2] and this issue has been
disscussed here [3] before.

current decompression routine was ported from lz4 v1.8.3, bumping lib/lz4
to v1.9.+ is certainly a huge work to be done later, so, we'd better fix
it first.

[1] https://lore.kernel.org/all/000000000000830d1205cf7f0477@google.com/
[2] https://github.com/lz4/lz4/commit/c5d6f8a8be3927c0bec91bcc58667a6cfad244ad#
[3] https://lore.kernel.org/all/CC666AE8-4CA4-4951-B6FB-A2EFDE3AC03B@fb.com/

Link: https://lkml.kernel.org/r/20211111105048.2006070-1-guoxuenan@huawei.com
Reported-by: syzbot+63d688f1d899c588fb71@syzkaller.appspotmail.com
Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
Reviewed-by: Nick Terrell <terrelln@fb.com>
Acked-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Yann Collet <cyan@fb.com>
Cc: Chengyang Fan <cy.fan@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lz4/lz4_decompress.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/lib/lz4/lz4_decompress.c~lz4-fix-lz4_decompress_safe_partial-read-out-of-bound
+++ a/lib/lz4/lz4_decompress.c
@@ -271,8 +271,12 @@ static FORCE_INLINE int LZ4_decompress_g
 			ip += length;
 			op += length;
 
-			/* Necessarily EOF, due to parsing restrictions */
-			if (!partialDecoding || (cpy == oend))
+			/* Necessarily EOF when !partialDecoding.
+			 * When partialDecoding, it is EOF if we've either
+			 * filled the output buffer or
+			 * can't proceed with reading an offset for following match.
+			 */
+			if (!partialDecoding || (cpy == oend) || (ip >= (iend - 2)))
 				break;
 		} else {
 			/* may overwrite up to WILDCOPYLENGTH beyond cpy */
_

Patches currently in -mm which might be from guoxuenan@huawei.com are


