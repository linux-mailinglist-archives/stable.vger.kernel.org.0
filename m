Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56F4566DAD
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236707AbiGEMZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237534AbiGEMXf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:23:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7977A1EEF7;
        Tue,  5 Jul 2022 05:16:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E2A0B817DA;
        Tue,  5 Jul 2022 12:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820A5C341D1;
        Tue,  5 Jul 2022 12:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023410;
        bh=ICUZyGma+X7+jGSiAsMOlb0dnDWDzQNJLswDdDApJ9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zz4duE5XmPPSwz1F2tltlVArNQV5DsrNR7vvbz7XAACiCNj4eECd27O4RjInYpWEb
         ZKsziEmGy34BPJwk/FL2X7zo8xILJLt0kXEH3/vOSc3E/Ms+rJVpMUMXU/d/3YbKsN
         Emwz8XWRkCANR56fpljZSjK9Izop9l1ffEUN+ahw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, wuchi <wuchi.zero@gmail.com>,
        Martin Wilck <mwilck@suse.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.18 051/102] lib/sbitmap: Fix invalid loop in __sbitmap_queue_get_batch()
Date:   Tue,  5 Jul 2022 13:58:17 +0200
Message-Id: <20220705115619.855451894@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wuchi <wuchi.zero@gmail.com>

commit fbb564a557809466c171b95f8d593a0972450ff2 upstream.

1. Getting next index before continue branch.
2. Checking free bits when setting the target bits. Otherwise,
it may reuse the busying bits.

Signed-off-by: wuchi <wuchi.zero@gmail.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Link: https://lore.kernel.org/r/20220605145835.26916-1-wuchi.zero@gmail.com
Fixes: 9672b0d43782 ("sbitmap: add __sbitmap_queue_get_batch()")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/sbitmap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/sbitmap.c b/lib/sbitmap.c
index ae4fd4de9ebe..29eb0484215a 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -528,7 +528,7 @@ unsigned long __sbitmap_queue_get_batch(struct sbitmap_queue *sbq, int nr_tags,
 
 		sbitmap_deferred_clear(map);
 		if (map->word == (1UL << (map_depth - 1)) - 1)
-			continue;
+			goto next;
 
 		nr = find_first_zero_bit(&map->word, map_depth);
 		if (nr + nr_tags <= map_depth) {
@@ -539,6 +539,8 @@ unsigned long __sbitmap_queue_get_batch(struct sbitmap_queue *sbq, int nr_tags,
 			get_mask = ((1UL << map_tags) - 1) << nr;
 			do {
 				val = READ_ONCE(map->word);
+				if ((val & ~get_mask) != val)
+					goto next;
 				ret = atomic_long_cmpxchg(ptr, val, get_mask | val);
 			} while (ret != val);
 			get_mask = (get_mask & ~ret) >> nr;
@@ -549,6 +551,7 @@ unsigned long __sbitmap_queue_get_batch(struct sbitmap_queue *sbq, int nr_tags,
 				return get_mask;
 			}
 		}
+next:
 		/* Jump to next index. */
 		if (++index >= sb->map_nr)
 			index = 0;
-- 
2.37.0



