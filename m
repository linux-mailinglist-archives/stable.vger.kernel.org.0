Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31DFF66C95B
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbjAPQtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:49:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233839AbjAPQsU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:48:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F894345C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:35:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E09861089
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE38C433D2;
        Mon, 16 Jan 2023 16:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886942;
        bh=6IqYSJ9PUPBz3rqoM9PaKfR/5UykSsWr3IYZVBWYfPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IKVZ/blXhpfpiQ4x/nCGwZQzYnv8Ib1+Ui40tFYtfC2YFo9THGbs75bq89RRSK7hi
         smOv985CBFodQhiHgzLbIxZv3w1urwx2pZ9qNTZo4fVgPVXozO4vO3wIp+Rqpw7UGh
         9qHDqDANr95a3PoOO24pbzh7fP6+gUsCcm+pbg2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Theodore Tso <tytso@mit.edu>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 621/658] jbd2: Drop pointless wakeup from jbd2_journal_stop()
Date:   Mon, 16 Jan 2023 16:51:49 +0100
Message-Id: <20230116154937.916918384@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 5559b2d81b51de75cb7864bb1fbb82982f7e8fff ]

When we drop last handle from a transaction and journal->j_barrier_count
> 0, jbd2_journal_stop() wakes up journal->j_wait_transaction_locked
wait queue. This looks pointless - wait for outstanding handles always
happens on journal->j_wait_updates waitqueue.
journal->j_wait_transaction_locked is used to wait for transaction state
changes and by start_this_handle() for waiting until
journal->j_barrier_count drops to 0. The first case is clearly
irrelevant here since only jbd2 thread changes transaction state. The
second case looks related but jbd2_journal_unlock_updates() is
responsible for the wakeup in this case. So just drop the wakeup.

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20191105164437.32602-16-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: d87a7b4c77a9 ("jbd2: use the correct print format")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/transaction.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index ce66dbbf0f90..6d78648392f0 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1850,11 +1850,8 @@ int jbd2_journal_stop(handle_t *handle)
 	 * once we do this, we must not dereference transaction
 	 * pointer again.
 	 */
-	if (atomic_dec_and_test(&transaction->t_updates)) {
+	if (atomic_dec_and_test(&transaction->t_updates))
 		wake_up(&journal->j_wait_updates);
-		if (journal->j_barrier_count)
-			wake_up(&journal->j_wait_transaction_locked);
-	}
 
 	rwsem_release(&journal->j_trans_commit_map, 1, _THIS_IP_);
 
-- 
2.35.1



