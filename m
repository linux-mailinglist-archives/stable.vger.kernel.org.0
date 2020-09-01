Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB0525948B
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgIAPky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:40:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728288AbgIAPku (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:40:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25487206EB;
        Tue,  1 Sep 2020 15:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974849;
        bh=XZw2Mlz7clUPSSCEXpb7Y2AwpJwYwJVDgr46KS1U0dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r6dr2JNj3jg1FdNkjr8UAmW50436tK2YcZMscOCFXJD/8zYn/G322BrfLwXPgCXn6
         B51FQ61DaDBf0JVgwAY7GT+yvFMKGMMimPU+1TVBAs3sCILU/xJEuDDBNEF+1nLKYt
         k4OqUB+hHIsg9lq0/ZyjustZLlwWH0sVIkDsRdCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "zhangyi (F)" <yi.zhang@huawei.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 113/255] jbd2: abort journal if free a async write error metadata buffer
Date:   Tue,  1 Sep 2020 17:09:29 +0200
Message-Id: <20200901151006.135699656@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhangyi (F) <yi.zhang@huawei.com>

[ Upstream commit c044f3d8360d2ecf831ba2cc9f08cf9fb2c699fb ]

If we free a metadata buffer which has been failed to async write out
in the background, the jbd2 checkpoint procedure will not detect this
failure in jbd2_log_do_checkpoint(), so it may lead to filesystem
inconsistency after cleanup journal tail. This patch abort the journal
if free a buffer has write_io_error flag to prevent potential further
inconsistency.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Link: https://lore.kernel.org/r/20200620025427.1756360-5-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/transaction.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index e65e0aca28261..6250c9faa4cbe 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -2120,6 +2120,7 @@ int jbd2_journal_try_to_free_buffers(journal_t *journal,
 {
 	struct buffer_head *head;
 	struct buffer_head *bh;
+	bool has_write_io_error = false;
 	int ret = 0;
 
 	J_ASSERT(PageLocked(page));
@@ -2144,11 +2145,26 @@ int jbd2_journal_try_to_free_buffers(journal_t *journal,
 		jbd2_journal_put_journal_head(jh);
 		if (buffer_jbd(bh))
 			goto busy;
+
+		/*
+		 * If we free a metadata buffer which has been failed to
+		 * write out, the jbd2 checkpoint procedure will not detect
+		 * this failure and may lead to filesystem inconsistency
+		 * after cleanup journal tail.
+		 */
+		if (buffer_write_io_error(bh)) {
+			pr_err("JBD2: Error while async write back metadata bh %llu.",
+			       (unsigned long long)bh->b_blocknr);
+			has_write_io_error = true;
+		}
 	} while ((bh = bh->b_this_page) != head);
 
 	ret = try_to_free_buffers(page);
 
 busy:
+	if (has_write_io_error)
+		jbd2_journal_abort(journal, -EIO);
+
 	return ret;
 }
 
-- 
2.25.1



