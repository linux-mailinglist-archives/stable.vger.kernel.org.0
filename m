Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5547B172184
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729415AbgB0Nkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:40:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:35252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729411AbgB0Nkv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:40:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 699D920726;
        Thu, 27 Feb 2020 13:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582810849;
        bh=bIsDn9IpMhwpBc5Jn8jbIXIVTDU9V1t/LXgrXYFrgv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ezq4+szEwksghMCTWgZl9zqGt2o42Il8PPpti0Fl6Pat3qF7xA/ayWC//wzLnb0y/
         NbMxAoZMDGZWj8OC+lz4EC/qo5AQ64HMp+CpN/dI3GCN6tWtT2QzFXq/S7L3KbW06M
         3dfS21WYhH/GCw/iBdnQQx/8zBS3Cf1wGzY5lUOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        "zhangyi (F)" <yi.zhang@huawei.com>, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 014/113] jbd2: move the clearing of b_modified flag to the journal_unmap_buffer()
Date:   Thu, 27 Feb 2020 14:35:30 +0100
Message-Id: <20200227132214.017840601@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132211.791484803@linuxfoundation.org>
References: <20200227132211.791484803@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhangyi (F) <yi.zhang@huawei.com>

[ Upstream commit 6a66a7ded12baa6ebbb2e3e82f8cb91382814839 ]

There is no need to delay the clearing of b_modified flag to the
transaction committing time when unmapping the journalled buffer, so
just move it to the journal_unmap_buffer().

Link: https://lore.kernel.org/r/20200213063821.30455-2-yi.zhang@huawei.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/commit.c      | 43 +++++++++++++++----------------------------
 fs/jbd2/transaction.c | 10 ++++++----
 2 files changed, 21 insertions(+), 32 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index ebbd7d054cabd..3bf86d912b76f 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -987,34 +987,21 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		 * it. */
 
 		/*
-		* A buffer which has been freed while still being journaled by
-		* a previous transaction.
-		*/
-		if (buffer_freed(bh)) {
-			/*
-			 * If the running transaction is the one containing
-			 * "add to orphan" operation (b_next_transaction !=
-			 * NULL), we have to wait for that transaction to
-			 * commit before we can really get rid of the buffer.
-			 * So just clear b_modified to not confuse transaction
-			 * credit accounting and refile the buffer to
-			 * BJ_Forget of the running transaction. If the just
-			 * committed transaction contains "add to orphan"
-			 * operation, we can completely invalidate the buffer
-			 * now. We are rather through in that since the
-			 * buffer may be still accessible when blocksize <
-			 * pagesize and it is attached to the last partial
-			 * page.
-			 */
-			jh->b_modified = 0;
-			if (!jh->b_next_transaction) {
-				clear_buffer_freed(bh);
-				clear_buffer_jbddirty(bh);
-				clear_buffer_mapped(bh);
-				clear_buffer_new(bh);
-				clear_buffer_req(bh);
-				bh->b_bdev = NULL;
-			}
+		 * A buffer which has been freed while still being journaled
+		 * by a previous transaction, refile the buffer to BJ_Forget of
+		 * the running transaction. If the just committed transaction
+		 * contains "add to orphan" operation, we can completely
+		 * invalidate the buffer now. We are rather through in that
+		 * since the buffer may be still accessible when blocksize <
+		 * pagesize and it is attached to the last partial page.
+		 */
+		if (buffer_freed(bh) && !jh->b_next_transaction) {
+			clear_buffer_freed(bh);
+			clear_buffer_jbddirty(bh);
+			clear_buffer_mapped(bh);
+			clear_buffer_new(bh);
+			clear_buffer_req(bh);
+			bh->b_bdev = NULL;
 		}
 
 		if (buffer_jbddirty(bh)) {
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index c34433432d471..6457023d8fac1 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -2223,14 +2223,16 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh,
 			return -EBUSY;
 		}
 		/*
-		 * OK, buffer won't be reachable after truncate. We just set
-		 * j_next_transaction to the running transaction (if there is
-		 * one) and mark buffer as freed so that commit code knows it
-		 * should clear dirty bits when it is done with the buffer.
+		 * OK, buffer won't be reachable after truncate. We just clear
+		 * b_modified to not confuse transaction credit accounting, and
+		 * set j_next_transaction to the running transaction (if there
+		 * is one) and mark buffer as freed so that commit code knows
+		 * it should clear dirty bits when it is done with the buffer.
 		 */
 		set_buffer_freed(bh);
 		if (journal->j_running_transaction && buffer_jbddirty(bh))
 			jh->b_next_transaction = journal->j_running_transaction;
+		jh->b_modified = 0;
 		jbd2_journal_put_journal_head(jh);
 		spin_unlock(&journal->j_list_lock);
 		jbd_unlock_bh_state(bh);
-- 
2.20.1



