Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1430259BAE
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbgIARFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:05:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729261AbgIAPT3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:19:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9F3920FC3;
        Tue,  1 Sep 2020 15:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973557;
        bh=snMbzTxAXziI+TGcqqhm4M7hh/cVmzzwrT2pf+fy6PI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fmyX8zi2mN3Appgnd8odcyidh/hIUjRHh0iM5pEuYkhM+EXXtKYnmV9ymF3gx/7va
         GsTZ+Cwx9hPInRGZPuUbw2jYpaZ2PbSYxpu06+xo2ysGQ/Oe7HKcmEKYFXGdC5hhSP
         A953XvpyONEN8YfvrjZmTlhW1LbLxNa4HwRHcwqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 47/91] jbd2: make sure jh have b_transaction set in refile/unfile_buffer
Date:   Tue,  1 Sep 2020 17:10:21 +0200
Message-Id: <20200901150930.472300180@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150928.096174795@linuxfoundation.org>
References: <20200901150928.096174795@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



