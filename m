Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970722B63A2
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgKQNkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:40:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:51956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732592AbgKQNkG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:40:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 431C120870;
        Tue, 17 Nov 2020 13:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620405;
        bh=3XWmxn9U1xhRWFyf9fS5ZKgz6mrzoLAAH9/EoQzrKbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JWy+DRX2Yw0lkZ3K8QOQgFpLW6qmb86lIX6OjfgWwZFIDEU3s1sthUcCb1F0NZ4JB
         d9m9MCErCztJrlGN/K75MKR/rMUyzTfHJPCoKLorjJsJg6JuHQXzmwle/7/fLsYa4l
         WcY29b11HJJhs9XVOTZt/5M3mvQq5v/CfuCjLnHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.9 207/255] jbd2: fix up sparse warnings in checkpoint code
Date:   Tue, 17 Nov 2020 14:05:47 +0100
Message-Id: <20201117122149.006290360@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
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
@@ -195,8 +195,10 @@ static void wait_transaction_switching(j
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


