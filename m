Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 615F411B824
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730609AbfLKQMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:12:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:57036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730523AbfLKPJK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:09:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FBE120663;
        Wed, 11 Dec 2019 15:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576076950;
        bh=OEoWho0qK/Js65s9rU9H2dD3E/7WPEb2NOcmXsGOPCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FbPdjoS1ZCm3ONoC2e3blmLUNwrFwcDYxIHcpknSzwlcvfhsdLBjM+luXYkjvgK79
         iz1g636R0Q9YoE2sXQWxDuYqSX1MMTt46piqsy86+P0mMv50nAi1slFz1w2qW9XJPA
         yTetxGVAZQ7mEoZTzmKxrT6J6JfJmPvrjUGH5Mew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5.4 53/92] jbd2: Fix possible overflow in jbd2_log_space_left()
Date:   Wed, 11 Dec 2019 16:05:44 +0100
Message-Id: <20191211150244.716220711@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit add3efdd78b8a0478ce423bb9d4df6bd95e8b335 upstream.

When number of free space in the journal is very low, the arithmetic in
jbd2_log_space_left() could underflow resulting in very high number of
free blocks and thus triggering assertion failure in transaction commit
code complaining there's not enough space in the journal:

J_ASSERT(journal->j_free > 1);

Properly check for the low number of free blocks.

CC: stable@vger.kernel.org
Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20191105164437.32602-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/jbd2.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1582,7 +1582,7 @@ static inline int jbd2_space_needed(jour
 static inline unsigned long jbd2_log_space_left(journal_t *journal)
 {
 	/* Allow for rounding errors */
-	unsigned long free = journal->j_free - 32;
+	long free = journal->j_free - 32;
 
 	if (journal->j_committing_transaction) {
 		unsigned long committing = atomic_read(&journal->
@@ -1591,7 +1591,7 @@ static inline unsigned long jbd2_log_spa
 		/* Transaction + control blocks */
 		free -= committing + (committing >> JBD2_CONTROL_BLOCKS_SHIFT);
 	}
-	return free;
+	return max_t(long, free, 0);
 }
 
 /*


