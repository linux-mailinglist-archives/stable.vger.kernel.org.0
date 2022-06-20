Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F86551E5D
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347744AbiFTOBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344205AbiFTN4o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:56:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8C3BB1;
        Mon, 20 Jun 2022 06:22:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F461B81157;
        Mon, 20 Jun 2022 13:22:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C073C3411B;
        Mon, 20 Jun 2022 13:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731342;
        bh=QWVOvaoQcs9rJFN9ZErPqPmZV92C+J1OsaNkwQKcuwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XLU/MT6uRgIBYmQ2QCs0uRUiIgtf3FrUQE2uOPd350J5/I6P0/E11/jt7a3OaMaxf
         F/Ct9y5bWauuxthwJu9eOWHqp+uqUUUHqzvCLhL84y3qx+GwleedskXzZYD8MxEaNY
         91NZ1Kq6bZH/7KcMv/Gv+VpomWO/xyCgN4WHA3Jk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.4 227/240] dm mirror log: round up region bitmap size to BITS_PER_LONG
Date:   Mon, 20 Jun 2022 14:52:08 +0200
Message-Id: <20220620124745.536925135@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
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


