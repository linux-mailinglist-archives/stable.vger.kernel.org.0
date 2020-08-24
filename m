Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B69250398
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 18:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbgHXQrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 12:47:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728560AbgHXQjR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:39:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0848222CB1;
        Mon, 24 Aug 2020 16:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598287156;
        bh=snMbzTxAXziI+TGcqqhm4M7hh/cVmzzwrT2pf+fy6PI=;
        h=From:To:Cc:Subject:Date:From;
        b=0rsE++QbPy01fZafXUJVfK1n3LKM4Mt0Hi7jQnzQhmN63K9Y5w8wL8QCz3gJEJxv1
         hY2TbPEd/j5ZaeF8xuiJo2NnrcULzYtObVbxr6Is46a5p38Yjx6eLQ6Iulr4B8/782
         9US4DPOpRARAYYaPat+A1i9TorZK/TBcP52Wsw3A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lukas Czerner <lczerner@redhat.com>, Jan Kara <jack@suse.cz>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 01/11] jbd2: make sure jh have b_transaction set in refile/unfile_buffer
Date:   Mon, 24 Aug 2020 12:39:04 -0400
Message-Id: <20200824163914.607152-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Czerner <lczerner@redhat.com>

[ Upstream commit 24dc9864914eb5813173cfa53313fcd02e4aea7d ]

Callers of __jbd2_journal_unfile_buffer() and
__jbd2_journal_refile_buffer() assume that the b_transaction is set. In
fact if it's not, we can end up with journal_head refcounting errors
leading to crash much later that might be very hard to track down. Add
asserts to make sure that is the case.

We also make sure that b_next_transaction is NULL in
__jbd2_journal_unfile_buffer() since the callers expect that as well and
we should not get into that stage in this state anyway, leading to
problems later on if we do.

Tested with fstests.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20200617092549.6712-1-lczerner@redhat.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/transaction.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index a355ca418e788..b4bde0ae10948 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1914,6 +1914,9 @@ static void __jbd2_journal_temp_unlink_buffer(struct journal_head *jh)
  */
 static void __jbd2_journal_unfile_buffer(struct journal_head *jh)
 {
+	J_ASSERT_JH(jh, jh->b_transaction != NULL);
+	J_ASSERT_JH(jh, jh->b_next_transaction == NULL);
+
 	__jbd2_journal_temp_unlink_buffer(jh);
 	jh->b_transaction = NULL;
 	jbd2_journal_put_journal_head(jh);
@@ -2461,6 +2464,13 @@ void __jbd2_journal_refile_buffer(struct journal_head *jh)
 
 	was_dirty = test_clear_buffer_jbddirty(bh);
 	__jbd2_journal_temp_unlink_buffer(jh);
+
+	/*
+	 * b_transaction must be set, otherwise the new b_transaction won't
+	 * be holding jh reference
+	 */
+	J_ASSERT_JH(jh, jh->b_transaction != NULL);
+
 	/*
 	 * We set b_transaction here because b_next_transaction will inherit
 	 * our jh reference and thus __jbd2_journal_file_buffer() must not
-- 
2.25.1

