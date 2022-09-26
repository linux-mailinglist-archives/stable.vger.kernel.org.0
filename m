Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628E05EA5A0
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239295AbiIZMJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239204AbiIZMIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:08:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDAD7FE50;
        Mon, 26 Sep 2022 03:56:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27DBEB80883;
        Mon, 26 Sep 2022 10:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84946C433C1;
        Mon, 26 Sep 2022 10:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188865;
        bh=N5RpwwG/mgc1T0SA0xNuDXrOOL85qZiKUQRyT1GKHRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dArzhztTfAzgMF+lSL3XM/rX1F2TuGX+5hf6dj5Y3bLI7i6Msk8lhYHmNLnHUe+Rr
         TC8lsSJBwHZ/xyPPnghBrJq7Z6bCmgxT2YQV8zyNhhlz4IjYKUk6QOoYxJvD9NHIzd
         nuvaVsSlrqUg063oDoqFxOA6pdsOp8PdtEzEd+kw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH 5.15 146/148] ext4: avoid unnecessary spreading of allocations among groups
Date:   Mon, 26 Sep 2022 12:13:00 +0200
Message-Id: <20220926100801.706278329@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 1940265ede6683f6317cba0d428ce6505eaca944 upstream.

mb_set_largest_free_order() updates lists containing groups with largest
chunk of free space of given order. The way it updates it leads to
always moving the group to the tail of the list. Thus allocations
looking for free space of given order effectively end up cycling through
all groups (and due to initialization in last to first order). This
spreads allocations among block groups which reduces performance for
rotating disks or low-end flash media. Change
mb_set_largest_free_order() to only update lists if the order of the
largest free chunk in the group changed.

Fixes: 196e402adf2e ("ext4: improve cr 0 / cr 1 group scanning")
CC: stable@kernel.org
Reported-and-tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/all/0d81a7c2-46b7-6010-62a4-3e6cfc1628d6@i2se.com/
Link: https://lore.kernel.org/r/20220908092136.11770-2-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1080,23 +1080,25 @@ mb_set_largest_free_order(struct super_b
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int i;
 
-	if (test_opt2(sb, MB_OPTIMIZE_SCAN) && grp->bb_largest_free_order >= 0) {
+	for (i = MB_NUM_ORDERS(sb) - 1; i >= 0; i--)
+		if (grp->bb_counters[i] > 0)
+			break;
+	/* No need to move between order lists? */
+	if (!test_opt2(sb, MB_OPTIMIZE_SCAN) ||
+	    i == grp->bb_largest_free_order) {
+		grp->bb_largest_free_order = i;
+		return;
+	}
+
+	if (grp->bb_largest_free_order >= 0) {
 		write_lock(&sbi->s_mb_largest_free_orders_locks[
 					      grp->bb_largest_free_order]);
 		list_del_init(&grp->bb_largest_free_order_node);
 		write_unlock(&sbi->s_mb_largest_free_orders_locks[
 					      grp->bb_largest_free_order]);
 	}
-	grp->bb_largest_free_order = -1; /* uninit */
-
-	for (i = MB_NUM_ORDERS(sb) - 1; i >= 0; i--) {
-		if (grp->bb_counters[i] > 0) {
-			grp->bb_largest_free_order = i;
-			break;
-		}
-	}
-	if (test_opt2(sb, MB_OPTIMIZE_SCAN) &&
-	    grp->bb_largest_free_order >= 0 && grp->bb_free) {
+	grp->bb_largest_free_order = i;
+	if (grp->bb_largest_free_order >= 0 && grp->bb_free) {
 		write_lock(&sbi->s_mb_largest_free_orders_locks[
 					      grp->bb_largest_free_order]);
 		list_add_tail(&grp->bb_largest_free_order_node,


