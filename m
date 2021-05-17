Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C983830D4
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238464AbhEQObs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:31:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239939AbhEQO3j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:29:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D00861209;
        Mon, 17 May 2021 14:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260887;
        bh=xckrPE9ijmGqOHYuY5VzT7zgppInrLit0dYh3Mn99bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NtoSzoS8iHeaRopTUZzMjmTzhAqwZrGnL+kcCkHLuNsx4jwgomoU8vbwTIivMjNMR
         FnWJv6POmLHE4mC7kaYJNh0Z8o1h9EaFWjyFCuAjZq+HQYuHEKX1xJzNr06bL0CV7t
         emKJbMIEwzncyou9rN4xbk4hMwfC33Lxtv6+TX3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Dan Schatzberg <dschatzberg@fb.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.12 260/363] blk-iocost: fix weight updates of inner active iocgs
Date:   Mon, 17 May 2021 16:02:06 +0200
Message-Id: <20210517140311.392371588@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit e9f4eee9a0023ba22db9560d4cc6ee63f933dae8 upstream.

When the weight of an active iocg is updated, weight_updated() is called
which in turn calls __propagate_weights() to update the active and inuse
weights so that the effective hierarchical weights are update accordingly.

The current implementation is incorrect for inner active nodes. For an
active leaf iocg, inuse can be any value between 1 and active and the
difference represents how much the iocg is donating. When weight is updated,
as long as inuse is clamped between 1 and the new weight, we're alright and
this is what __propagate_weights() currently implements.

However, that's not how an active inner node's inuse is set. An inner node's
inuse is solely determined by the ratio between the sums of inuse's and
active's of its children - ie. they're results of propagating the leaves'
active and inuse weights upwards. __propagate_weights() incorrectly applies
the same clamping as for a leaf when an active inner node's weight is
updated. Consider a hierarchy which looks like the following with saturating
workloads in AA and BB.

     R
   /   \
  A     B
  |     |
 AA     BB

1. For both A and B, active=100, inuse=100, hwa=0.5, hwi=0.5.

2. echo 200 > A/io.weight

3. __propagate_weights() update A's active to 200 and leave inuse at 100 as
   it's already between 1 and the new active, making A:active=200,
   A:inuse=100. As R's active_sum is updated along with A's active,
   A:hwa=2/3, B:hwa=1/3. However, because the inuses didn't change, the
   hwi's remain unchanged at 0.5.

4. The weight of A is now twice that of B but AA and BB still have the same
   hwi of 0.5 and thus are doing the same amount of IOs.

Fix it by making __propgate_weights() always calculate the inuse of an
active inner iocg based on the ratio of child_inuse_sum to child_active_sum.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Dan Schatzberg <dschatzberg@fb.com>
Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Cc: stable@vger.kernel.org # v5.4+
Link: https://lore.kernel.org/r/YJsxnLZV1MnBcqjj@slm.duckdns.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-iocost.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1073,7 +1073,17 @@ static void __propagate_weights(struct i
 
 	lockdep_assert_held(&ioc->lock);
 
-	inuse = clamp_t(u32, inuse, 1, active);
+	/*
+	 * For an active leaf node, its inuse shouldn't be zero or exceed
+	 * @active. An active internal node's inuse is solely determined by the
+	 * inuse to active ratio of its children regardless of @inuse.
+	 */
+	if (list_empty(&iocg->active_list) && iocg->child_active_sum) {
+		inuse = DIV64_U64_ROUND_UP(active * iocg->child_inuse_sum,
+					   iocg->child_active_sum);
+	} else {
+		inuse = clamp_t(u32, inuse, 1, active);
+	}
 
 	iocg->last_inuse = iocg->inuse;
 	if (save)
@@ -1090,7 +1100,7 @@ static void __propagate_weights(struct i
 		/* update the level sums */
 		parent->child_active_sum += (s32)(active - child->active);
 		parent->child_inuse_sum += (s32)(inuse - child->inuse);
-		/* apply the udpates */
+		/* apply the updates */
 		child->active = active;
 		child->inuse = inuse;
 


