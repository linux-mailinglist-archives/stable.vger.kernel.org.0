Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61E015EA532
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238263AbiIZL7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238995AbiIZL5N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:57:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6EA7A76A;
        Mon, 26 Sep 2022 03:51:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5206960C09;
        Mon, 26 Sep 2022 10:51:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560EFC433C1;
        Mon, 26 Sep 2022 10:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189503;
        bh=sHvIIc/WdPsfHk+hAlPh7SHkb11QWX6X4FwEN42rrUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ht6g//m7bQSipsLmYBdqD2zc8YcYenjJ+cOuTzElsamRdvOa3V9F0wda/JKEXkkQZ
         zGwKVmHFUYIixv0JBr6MhWkgnjW0Z0DOTrQmDhSFLp/NIn0FN0+NOGBN90c0qRwMBe
         Vd2qnvYooA3rbjDuhSfZKG7SzaUfL64RSXJ9iHdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH 5.19 203/207] ext4: avoid unnecessary spreading of allocations among groups
Date:   Mon, 26 Sep 2022 12:13:12 +0200
Message-Id: <20220926100815.691863297@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
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
@@ -1077,23 +1077,25 @@ mb_set_largest_free_order(struct super_b
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


