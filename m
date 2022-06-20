Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5862B551B49
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345381AbiFTN1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345010AbiFTN0K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:26:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18741C103;
        Mon, 20 Jun 2022 06:10:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C6A760C14;
        Mon, 20 Jun 2022 13:09:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A4AC3411B;
        Mon, 20 Jun 2022 13:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730570;
        bh=QWVOvaoQcs9rJFN9ZErPqPmZV92C+J1OsaNkwQKcuwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rIZISMgBPgBhhKwzPHyb5+XxJfpvMUiEyX0T7/q19psL9iawUkwMkEEioA2jwF7XT
         Mp4x1SrrJ4TK1OW6FdiXEFc7bkTkzHNW2H18lywwc5vODb+WEwm9YmCBsKgh6C/qFJ
         KvVZYlDKOvcokzXiT9JhHt/8GP88R4jhPnt+QQ64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.15 095/106] dm mirror log: round up region bitmap size to BITS_PER_LONG
Date:   Mon, 20 Jun 2022 14:51:54 +0200
Message-Id: <20220620124727.203157994@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
References: <20220620124724.380838401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 85e123c27d5cbc22cfdc01de1e2ca1d9003a02d0 upstream.

The code in dm-log rounds up bitset_size to 32 bits. It then uses
find_next_zero_bit_le on the allocated region. find_next_zero_bit_le
accesses the bitmap using unsigned long pointers. So, on 64-bit
architectures, it may access 4 bytes beyond the allocated size.

Fix this bug by rounding up bitset_size to BITS_PER_LONG.

This bug was found by running the lvm2 testsuite with kasan.

Fixes: 29121bd0b00e ("[PATCH] dm mirror log: bitset_size fix")
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-log.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -415,8 +415,7 @@ static int create_log_context(struct dm_
 	/*
 	 * Work out how many "unsigned long"s we need to hold the bitset.
 	 */
-	bitset_size = dm_round_up(region_count,
-				  sizeof(*lc->clean_bits) << BYTE_SHIFT);
+	bitset_size = dm_round_up(region_count, BITS_PER_LONG);
 	bitset_size >>= BYTE_SHIFT;
 
 	lc->bitset_uint32_count = bitset_size / sizeof(*lc->clean_bits);


