Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63AD9501554
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344173AbiDNONg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347643AbiDNN7Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:59:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63A546154;
        Thu, 14 Apr 2022 06:50:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0FB961D29;
        Thu, 14 Apr 2022 13:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9913C385A1;
        Thu, 14 Apr 2022 13:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944246;
        bh=u2eSWplhryUg880omtp8DMLc1eKdaByhY5LAUhuhCZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YQGFlLyDHcx3WMZgcWjGtFRWZVyhsGxtihgYUGEM4JMgtnqThSfh1zC4y5IqxFe80
         Vy+cT8O5U6b1oVrufM/W8Y09OmIOcfCF0slgyhwt8Jwsrc3iqiXLEyGEtJnpGtzZY+
         rVgQFHeZ52CJj+B2MUsIaQzAR70byOCAmdUgqxA0=
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
Subject: [PATCH 5.4 447/475] lz4: fix LZ4_decompress_safe_partial read out of bound
Date:   Thu, 14 Apr 2022 15:13:52 +0200
Message-Id: <20220414110907.568465674@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
@@ -268,8 +268,12 @@ static FORCE_INLINE int LZ4_decompress_g
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


