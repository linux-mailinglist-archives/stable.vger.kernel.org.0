Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E81501278
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345354AbiDNNuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344409AbiDNNlQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:41:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9F9120;
        Thu, 14 Apr 2022 06:38:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19E5FB828F4;
        Thu, 14 Apr 2022 13:38:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AFAFC385A1;
        Thu, 14 Apr 2022 13:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943528;
        bh=WY9yt8LLrWOEyI6iKOGxoc5mg8SVxR1RrKoUFTjF1BM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QUZOqzs7ohZMLXtA7R53CJ/KSd5cs2DwUZCLE9BhZbVWfAZT2ojnIXBk+LTWpqJSO
         z5uEYErrQH4IGZOa1ayctH/QeqcGi1lV9ubR6WRniCGxQTPrq6+1NHm7JhItaU3eA3
         +jGLRlBCsILtoss+UUiyfAjR77pf6HM0GyqPlLjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 189/475] ext2: correct max file size computing
Date:   Thu, 14 Apr 2022 15:09:34 +0200
Message-Id: <20220414110900.420211392@linuxfoundation.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 50b3a818991074177a56c87124c7a7bdf5fa4f67 ]

We need to calculate the max file size accurately if the total blocks
that can address by block tree exceed the upper_limit. But this check is
not correct now, it only compute the total data blocks but missing
metadata blocks are needed. So in the case of "data blocks < upper_limit
&& total blocks > upper_limit", we will get wrong result. Fortunately,
this case could not happen in reality, but it's confused and better to
correct the computing.

  bits   data blocks   metadatablocks   upper_limit
  10        16843020            66051    2147483647
  11       134480396           263171    1073741823
  12      1074791436          1050627     536870911 (*)
  13      8594130956          4198403     268435455 (*)
  14     68736258060         16785411     134217727 (*)
  15    549822930956         67125251      67108863 (*)
  16   4398314962956        268468227      33554431 (*)

  [*] Need to calculate in depth.

Fixes: 1c2d14212b15 ("ext2: Fix underflow in ext2_max_size()")
Link: https://lore.kernel.org/r/20220212050532.179055-1-yi.zhang@huawei.com
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext2/super.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 065cd2d1bdc6..db403c01d4d5 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -770,8 +770,12 @@ static loff_t ext2_max_size(int bits)
 	res += 1LL << (bits-2);
 	res += 1LL << (2*(bits-2));
 	res += 1LL << (3*(bits-2));
+	/* Compute how many metadata blocks are needed */
+	meta_blocks = 1;
+	meta_blocks += 1 + ppb;
+	meta_blocks += 1 + ppb + ppb * ppb;
 	/* Does block tree limit file size? */
-	if (res < upper_limit)
+	if (res + meta_blocks <= upper_limit)
 		goto check_lfs;
 
 	res = upper_limit;
-- 
2.34.1



