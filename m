Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0372A4FDA4F
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353599AbiDLHd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353711AbiDLHZw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1791275F5;
        Tue, 12 Apr 2022 00:03:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B4B6B81B4E;
        Tue, 12 Apr 2022 07:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B60DC385A1;
        Tue, 12 Apr 2022 07:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747036;
        bh=r7zwxBmSBYLoVuMUOCzhurkmYQox+oscdpkyavZfQGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KXyx+lqSZM7NibE6DSK3FpaEjfYFJV1d/9fBtn1X/Uih7Kduk73YojrlGYZgcVScA
         x0QxyN/G7txZCC8+1bjTrJJDPYJTUR+cNrEBzH/gq9bkDo/0MqZDu+jcc4iVn3s5Js
         1CcJknzfK7ZkbQ00kbzI/eXVOnCJy1o2UH+F3hS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+63d688f1d899c588fb71@syzkaller.appspotmail.com,
        Guo Xuenan <guoxuenan@huawei.com>,
        Nick Terrell <terrelln@fb.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Yann Collet <cyan@fb.com>, Chengyang Fan <cy.fan@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.16 220/285] lz4: fix LZ4_decompress_safe_partial read out of bound
Date:   Tue, 12 Apr 2022 08:31:17 +0200
Message-Id: <20220412062950.006962534@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Guo Xuenan <guoxuenan@huawei.com>

commit eafc0a02391b7b36617b36c97c4b5d6832cf5e24 upstream.

When partialDecoding, it is EOF if we've either filled the output buffer
or can't proceed with reading an offset for following match.

In some extreme corner cases when compressed data is suitably corrupted,
UAF will occur.  As reported by KASAN [1], LZ4_decompress_safe_partial
may lead to read out of bound problem during decoding.  lz4 upstream has
fixed it [2] and this issue has been disscussed here [3] before.

current decompression routine was ported from lz4 v1.8.3, bumping
lib/lz4 to v1.9.+ is certainly a huge work to be done later, so, we'd
better fix it first.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/lz4/lz4_decompress.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/lib/lz4/lz4_decompress.c
+++ b/lib/lz4/lz4_decompress.c
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


