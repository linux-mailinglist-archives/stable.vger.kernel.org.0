Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63BCD2B625E
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731806AbgKQN2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:28:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:36134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731287AbgKQN2C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:28:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4932020781;
        Tue, 17 Nov 2020 13:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619681;
        bh=jPuyBa0TFVZn/Vmsf9yYWkhloXgwvGOjxCiFIchbXaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OYOv87oImqYGygMYkSqZFhqlvF4OhBdSxDlBEatNKeIgGEpF8S6M2omrlWC8YgemI
         2WQKmcpdocm9Btijo9GzG8h5vE2xu9S0OeCjJlDvev9COlCgEytLR0oN1qEJFTs9IS
         R4zdPY35kk7CL8/8C43f/sKxHz7z68ikKPO64BwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 121/151] jbd2: fix up sparse warnings in checkpoint code
Date:   Tue, 17 Nov 2020 14:05:51 +0100
Message-Id: <20201117122127.308168306@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit 05d5233df85e9621597c5838e95235107eb624a2 upstream.

Add missing __acquires() and __releases() annotations.  Also, in an
"this should never happen" WARN_ON check, if it *does* actually
happen, we need to release j_state_lock since this function is always
supposed to release that lock.  Otherwise, things will quickly grind
to a halt after the WARN_ON trips.

Fixes: 96f1e0974575 ("jbd2: avoid long hold times of j_state_lock...")
Cc: stable@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jbd2/checkpoint.c  |    2 ++
 fs/jbd2/transaction.c |    4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -106,6 +106,8 @@ static int __try_to_free_cp_buf(struct j
  * for a checkpoint to free up some space in the log.
  */
 void __jbd2_log_wait_for_space(journal_t *journal)
+__acquires(&journal->j_state_lock)
+__releases(&journal->j_state_lock)
 {
 	int nblocks, space_left;
 	/* assert_spin_locked(&journal->j_state_lock); */
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -171,8 +171,10 @@ static void wait_transaction_switching(j
 	DEFINE_WAIT(wait);
 
 	if (WARN_ON(!journal->j_running_transaction ||
-		    journal->j_running_transaction->t_state != T_SWITCH))
+		    journal->j_running_transaction->t_state != T_SWITCH)) {
+		read_unlock(&journal->j_state_lock);
 		return;
+	}
 	prepare_to_wait(&journal->j_wait_transaction_locked, &wait,
 			TASK_UNINTERRUPTIBLE);
 	read_unlock(&journal->j_state_lock);


