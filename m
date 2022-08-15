Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8C55939EE
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245674AbiHOT3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344036AbiHOT0V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:26:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6D3B3B;
        Mon, 15 Aug 2022 11:42:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8674360FB8;
        Mon, 15 Aug 2022 18:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E09C433D6;
        Mon, 15 Aug 2022 18:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588923;
        bh=h5IQ40lJ1q8klEjO8xL8OheZJmsYS5JNjLAwAZF7Yxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ou4kCyJMimLR6cXU+Ytm3vrOjHLugCvfTNn5UuuCAqVUZwRgVbIZq67D/aD+4QtH4
         sU70DD6LAUSQHFo6YcexSRHvN+in753CMZ6NWJJijjFncUC9URwtLXaui/5D5oe0nj
         HOi7anxvxTpyKQXiEnIjgvqPpY+ASCylK7PZtnHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 556/779] jbd2: fix outstanding credits assert in jbd2_journal_commit_transaction()
Date:   Mon, 15 Aug 2022 20:03:20 +0200
Message-Id: <20220815180401.094593943@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit a89573ce4ad32f19f43ec669771726817e185be0 ]

We catch an assert problem in jbd2_journal_commit_transaction() when
doing fsstress and request falut injection tests. The problem is
happened in a race condition between jbd2_journal_commit_transaction()
and ext4_end_io_end(). Firstly, ext4_writepages() writeback dirty pages
and start reserved handle, and then the journal was aborted due to some
previous metadata IO error, jbd2_journal_abort() start to commit current
running transaction, the committing procedure could be raced by
ext4_end_io_end() and lead to subtract j_reserved_credits twice from
commit_transaction->t_outstanding_credits, finally the
t_outstanding_credits is mistakenly smaller than t_nr_buffers and
trigger assert.

kjournald2           kworker

jbd2_journal_commit_transaction()
 write_unlock(&journal->j_state_lock);
 atomic_sub(j_reserved_credits, t_outstanding_credits); //sub once

     	             jbd2_journal_start_reserved()
     	              start_this_handle()  //detect aborted journal
     	              jbd2_journal_free_reserved()  //get running transaction
                       read_lock(&journal->j_state_lock)
     	                __jbd2_journal_unreserve_handle()
     	               atomic_sub(j_reserved_credits, t_outstanding_credits);
                       //sub again
                       read_unlock(&journal->j_state_lock);

 journal->j_running_transaction = NULL;
 J_ASSERT(t_nr_buffers <= t_outstanding_credits) //bomb!!!

Fix this issue by using journal->j_state_lock to protect the subtraction
in jbd2_journal_commit_transaction().

Fixes: 96f1e0974575 ("jbd2: avoid long hold times of j_state_lock while committing a transaction")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220611130426.2013258-1-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/commit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 34b1406c06fd..69538061c551 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -564,13 +564,13 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	 */
 	jbd2_journal_switch_revoke_table(journal);
 
+	write_lock(&journal->j_state_lock);
 	/*
 	 * Reserved credits cannot be claimed anymore, free them
 	 */
 	atomic_sub(atomic_read(&journal->j_reserved_credits),
 		   &commit_transaction->t_outstanding_credits);
 
-	write_lock(&journal->j_state_lock);
 	trace_jbd2_commit_flushing(journal, commit_transaction);
 	stats.run.rs_flushing = jiffies;
 	stats.run.rs_locked = jbd2_time_diff(stats.run.rs_locked,
-- 
2.35.1



