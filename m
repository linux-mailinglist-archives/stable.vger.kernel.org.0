Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 834A06AEDE7
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjCGSIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:08:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbjCGSH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:07:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF82B9FE7F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:01:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FA2CB819BB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:01:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827AAC4339C;
        Tue,  7 Mar 2023 18:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212095;
        bh=zCp4yVHcUJWjnl3rMWsjcDHkcNBQVVnUVp71qhKfnok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H2KPTA4/mWj063/Llgh+rN+yeouBEc5b0dcqmmbLHFNXjcfKrR4uu6B0tRbnBlCV+
         lHwoCBKAu5Xa4/09u/rp59m3airjIEZB3oYdHCo4T6kgBiHMLCN8K98yfXw0jYT7eY
         wkZ+zi+xKx0MRvBObOz3t8PGzIh3YOP5h1rEpIRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/885] sbitmap: remove redundant check in __sbitmap_queue_get_batch
Date:   Tue,  7 Mar 2023 17:50:08 +0100
Message-Id: <20230307170005.002766342@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 903e86f3a64d9573352bbab2f211fdbbaa5772b7 ]

Commit fbb564a557809 ("lib/sbitmap: Fix invalid loop in
__sbitmap_queue_get_batch()") mentioned that "Checking free bits when
setting the target bits. Otherwise, it may reuse the busying bits."
This commit add check to make sure all masked bits in word before
cmpxchg is zero. Then the existing check after cmpxchg to check any
zero bit is existing in masked bits in word is redundant.

Actually, old value of word before cmpxchg is stored in val and we
will filter out busy bits in val by "(get_mask & ~val)" after cmpxchg.
So we will not reuse busy bits methioned in commit fbb564a557809
("lib/sbitmap: Fix invalid loop in __sbitmap_queue_get_batch()"). Revert
new-added check to remove redundant check.

Fixes: fbb564a55780 ("lib/sbitmap: Fix invalid loop in __sbitmap_queue_get_batch()")
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Link: https://lore.kernel.org/r/20230116205059.3821738-3-shikemeng@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/sbitmap.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/lib/sbitmap.c b/lib/sbitmap.c
index 7280ae8ca88c7..ca099fbc6f3c9 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -537,11 +537,9 @@ unsigned long __sbitmap_queue_get_batch(struct sbitmap_queue *sbq, int nr_tags,
 
 			get_mask = ((1UL << nr_tags) - 1) << nr;
 			val = READ_ONCE(map->word);
-			do {
-				if ((val & ~get_mask) != val)
-					goto next;
-			} while (!atomic_long_try_cmpxchg(ptr, &val,
-							  get_mask | val));
+			while (!atomic_long_try_cmpxchg(ptr, &val,
+							  get_mask | val))
+				;
 			get_mask = (get_mask & ~val) >> nr;
 			if (get_mask) {
 				*offset = nr + (index << sb->shift);
-- 
2.39.2



