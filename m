Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9FC378906
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236873AbhEJLZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:25:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237554AbhEJLPa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:15:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 131E1613C9;
        Mon, 10 May 2021 11:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645065;
        bh=Z0wYcN899ocdNzLotbRtqJ4W0IGmBtUATHKOr3zkWxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMAsjMI7U22yFOgPL4WHgpPEKiWnGWk3GvGwZfM24xeOlj2ek3fe8P2U8bEnkj4W2
         6oC3LXFxz09NvgQSZqE+RFuB34EKpu7FPQZqxbOqoP8KCi4HGdNZ5nBquyVOoy55i5
         nELfs1cQKaWydJIJ+g9yirDYacqiQBzfQg7sBGXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        syzbot+30774a6acf6a2cf6d535@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.12 336/384] ext4: annotate data race in start_this_handle()
Date:   Mon, 10 May 2021 12:22:05 +0200
Message-Id: <20210510102025.862364827@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 3b1833e92baba135923af4a07e73fe6e54be5a2f upstream.

Access to journal->j_running_transaction is not protected by appropriate
lock and thus is racy. We are well aware of that and the code handles
the race properly. Just add a comment and data_race() annotation.

Cc: stable@kernel.org
Reported-by: syzbot+30774a6acf6a2cf6d535@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20210406161804.20150-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/transaction.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -349,7 +349,12 @@ static int start_this_handle(journal_t *
 	}
 
 alloc_transaction:
-	if (!journal->j_running_transaction) {
+	/*
+	 * This check is racy but it is just an optimization of allocating new
+	 * transaction early if there are high chances we'll need it. If we
+	 * guess wrong, we'll retry or free unused transaction.
+	 */
+	if (!data_race(journal->j_running_transaction)) {
 		/*
 		 * If __GFP_FS is not present, then we may be being called from
 		 * inside the fs writeback layer, so we MUST NOT fail.


