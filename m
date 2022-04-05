Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 929CF4F32A7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237765AbiDEJET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242781AbiDEItc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:49:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17EBD7460C;
        Tue,  5 Apr 2022 01:37:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29F2DB81C6A;
        Tue,  5 Apr 2022 08:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FF6C385A1;
        Tue,  5 Apr 2022 08:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147844;
        bh=lzO+z6AoVIcvFgn8IXdAdIOaIsz6Yqp+xI/H9kDkdZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mVNuNQ2fRbeELBkZihTOHX8dpiMVLe/MMcxf8fcqlEnpzta9bgHt7Xy5TB9KsRmri
         s0eZGlQlrlAywiKW/Z2yQmPyp1SzPIKHd3PzpMwHmQa6ShFJyt1VfWsxsIieLGfZJ6
         Lt9DNaWvJkWdIE8MXoFxVREiikZiXUM6xuLZy4hE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Geetika Moolchandani <Geetika.Moolchandani1@ibm.com>,
        Nageswara R Sastry <rnsastry@linux.ibm.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.16 0141/1017] ext4: make mb_optimize_scan performance mount option work with extents
Date:   Tue,  5 Apr 2022 09:17:34 +0200
Message-Id: <20220405070358.388849007@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Ojaswin Mujoo <ojaswin@linux.ibm.com>

commit 077d0c2c78df6f7260cdd015a991327efa44d8ad upstream.

Currently mb_optimize_scan scan feature which improves filesystem
performance heavily (when FS is fragmented), seems to be not working
with files with extents (ext4 by default has files with extents).

This patch fixes that and makes mb_optimize_scan feature work
for files with extents.

Below are some performance numbers obtained when allocating a 10M and 100M
file with and w/o this patch on a filesytem with no 1M contiguous block.

<perf numbers>
===============
Workload: dd if=/dev/urandom of=test conv=fsync bs=1M count=10/100

Time taken
=====================================================
no.     Size   without-patch     with-patch    Diff(%)
1       10M      0m8.401s         0m5.623s     33.06%
2       100M     1m40.465s        1m14.737s    25.6%

<debug stats>
=============
w/o patch:
  mballoc:
    reqs: 17056
    success: 11407
    groups_scanned: 13643
    cr0_stats:
            hits: 37
            groups_considered: 9472
            useless_loops: 36
            bad_suggestions: 0
    cr1_stats:
            hits: 11418
            groups_considered: 908560
            useless_loops: 1894
            bad_suggestions: 0
    cr2_stats:
            hits: 1873
            groups_considered: 6913
            useless_loops: 21
    cr3_stats:
            hits: 21
            groups_considered: 5040
            useless_loops: 21
    extents_scanned: 417364
            goal_hits: 3707
            2^n_hits: 37
            breaks: 1873
            lost: 0
    buddies_generated: 239/240
    buddies_time_used: 651080
    preallocated: 705
    discarded: 478

with patch:
  mballoc:
    reqs: 12768
    success: 11305
    groups_scanned: 12768
    cr0_stats:
            hits: 1
            groups_considered: 18
            useless_loops: 0
            bad_suggestions: 0
    cr1_stats:
            hits: 5829
            groups_considered: 50626
            useless_loops: 0
            bad_suggestions: 0
    cr2_stats:
            hits: 6938
            groups_considered: 580363
            useless_loops: 0
    cr3_stats:
            hits: 0
            groups_considered: 0
            useless_loops: 0
    extents_scanned: 309059
            goal_hits: 0
            2^n_hits: 1
            breaks: 1463
            lost: 0
    buddies_generated: 239/240
    buddies_time_used: 791392
    preallocated: 673
    discarded: 446

Fixes: 196e402 (ext4: improve cr 0 / cr 1 group scanning)
Cc: stable@kernel.org
Reported-by: Geetika Moolchandani <Geetika.Moolchandani1@ibm.com>
Reported-by: Nageswara R Sastry <rnsastry@linux.ibm.com>
Suggested-by: Ritesh Harjani <riteshh@linux.ibm.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://lore.kernel.org/r/fc9a48f7f8dcfc83891a8b21f6dd8cdf056ed810.1646732698.git.ojaswin@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1000,7 +1000,7 @@ static inline int should_optimize_scan(s
 		return 0;
 	if (ac->ac_criteria >= 2)
 		return 0;
-	if (ext4_test_inode_flag(ac->ac_inode, EXT4_INODE_EXTENTS))
+	if (!ext4_test_inode_flag(ac->ac_inode, EXT4_INODE_EXTENTS))
 		return 0;
 	return 1;
 }


