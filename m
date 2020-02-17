Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D522A161B52
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 20:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbgBQTMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 14:12:55 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:33157 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728467AbgBQTMy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 14:12:54 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 103C1210DB;
        Mon, 17 Feb 2020 14:12:54 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 17 Feb 2020 14:12:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=oLZ5KB
        bRECh6qvMFrqrPpITfV/QVfht4Pq8ngt2Rv2U=; b=md08VryaurT0e3QKPXZ6x4
        B4GF9/ZTISNEmAgXA+TYPtzcnnMw91Mp3izgQTFcOE8rkw5sPEAaT/H+3jlk892C
        8PgQK3P5GuPdqpB5Xzrj++moGJ96mnP0kSdsdT8udZC78+AgcAL+ASQL/d4EJP02
        oObPi0TvT4s54tanvREAdviTpJLrAXWgBi9iZrhbfg7ymYefCAg++RQgW/tzZPc3
        Pya7l8GzpEo3QyVUuHsCbOtCYoU3v0GJvd3tNack4SYfCxR+snHtanFOF48BjPvo
        ayWwzfg+Qy8t9tQ0qFBeMY84EAF+na4ENOPj0APRtH5Mm4fG9/T0wJLB2V9V7jqg
        ==
X-ME-Sender: <xms:teVKXoXT3NJFdlDPHLxBtXmXSGYHuGmuOYbVcACmP-9mdYou6BYJ_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:teVKXkzgc1FySQymLIxrVBRIcQe3J47-ejUkjBK1HvdfEo1cjg8CRg>
    <xmx:teVKXjvaM3c1QcbV8bvA-dgcP9kI3u27qQqMS-0FpXZOMKCmA02vGw>
    <xmx:teVKXlATev9hx8cskl2s-o53XSeduxPXQrEQlJ7wiUFg5jXWEqnx-A>
    <xmx:tuVKXoaIybxNafnM31LNcUuJR5C8kFjG5VVKQZEXAEowIaSbkBqWnw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E38BF30606E9;
        Mon, 17 Feb 2020 14:12:52 -0500 (EST)
Subject: FAILED: patch "[PATCH] jbd2: move the clearing of b_modified flag to the" failed to apply to 5.4-stable tree
To:     yi.zhang@huawei.com, jack@suse.cz, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Feb 2020 20:12:51 +0100
Message-ID: <158196677170168@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6a66a7ded12baa6ebbb2e3e82f8cb91382814839 Mon Sep 17 00:00:00 2001
From: "zhangyi (F)" <yi.zhang@huawei.com>
Date: Thu, 13 Feb 2020 14:38:20 +0800
Subject: [PATCH] jbd2: move the clearing of b_modified flag to the
 journal_unmap_buffer()

There is no need to delay the clearing of b_modified flag to the
transaction committing time when unmapping the journalled buffer, so
just move it to the journal_unmap_buffer().

Link: https://lore.kernel.org/r/20200213063821.30455-2-yi.zhang@huawei.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 2494095e0340..6396fe70085b 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -976,34 +976,21 @@ void jbd2_journal_commit_transaction(journal_t *journal)
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
index e77a5a0b4e46..2dd848a743ed 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -2329,14 +2329,16 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh,
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
 		spin_unlock(&journal->j_list_lock);
 		spin_unlock(&jh->b_state_lock);
 		write_unlock(&journal->j_state_lock);

