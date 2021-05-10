Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C47378517
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbhEJK6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:58:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233086AbhEJKyZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:54:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 700476101E;
        Mon, 10 May 2021 10:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643317;
        bh=b+X48dCloFuRbRgUeHgCfH6mM1EbHUpVAf6wPUprbmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s3D/2ej/kbpC47UvC++IzBRmUzHL3vW3rDo93hN3AZwtZf2h+hZoEcrGHEHahppJE
         Ryb6jVRHSQijkgwaNhUKspJ/LwlXQfqDVrznNwgAOqag/SeJ3wLUHmmDjx2cQv1cWj
         zzXNBc9VFy0YLBB42+deTov6jQdAKnn5b4vSQ6Fs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Hao Sun <sunhao.th@gmail.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 265/299] ext4: annotate data race in jbd2_journal_dirty_metadata()
Date:   Mon, 10 May 2021 12:21:02 +0200
Message-Id: <20210510102013.696784393@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 83fe6b18b8d04c6c849379005e1679bac9752466 upstream.

Assertion checks in jbd2_journal_dirty_metadata() are known to be racy
but we don't want to be grabbing locks just for them.  We thus recheck
them under b_state_lock only if it looks like they would fail. Annotate
the checks with data_race().

Cc: stable@kernel.org
Reported-by: Hao Sun <sunhao.th@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20210406161804.20150-2-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/transaction.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1479,8 +1479,8 @@ int jbd2_journal_dirty_metadata(handle_t
 	 * crucial to catch bugs so let's do a reliable check until the
 	 * lockless handling is fully proven.
 	 */
-	if (jh->b_transaction != transaction &&
-	    jh->b_next_transaction != transaction) {
+	if (data_race(jh->b_transaction != transaction &&
+	    jh->b_next_transaction != transaction)) {
 		spin_lock(&jh->b_state_lock);
 		J_ASSERT_JH(jh, jh->b_transaction == transaction ||
 				jh->b_next_transaction == transaction);
@@ -1488,8 +1488,8 @@ int jbd2_journal_dirty_metadata(handle_t
 	}
 	if (jh->b_modified == 1) {
 		/* If it's in our transaction it must be in BJ_Metadata list. */
-		if (jh->b_transaction == transaction &&
-		    jh->b_jlist != BJ_Metadata) {
+		if (data_race(jh->b_transaction == transaction &&
+		    jh->b_jlist != BJ_Metadata)) {
 			spin_lock(&jh->b_state_lock);
 			if (jh->b_transaction == transaction &&
 			    jh->b_jlist != BJ_Metadata)


