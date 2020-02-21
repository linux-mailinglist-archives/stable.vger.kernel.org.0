Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05E501676D5
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730459AbgBUH6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:58:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:58080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730749AbgBUH6R (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:58:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E71AB20801;
        Fri, 21 Feb 2020 07:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271897;
        bh=cEQMdcc8WTOTem/Ek9qVt8CLr46UoNPH3C+4E/CD0ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ok/g9YTN6JARWN9h8nUKLgPk+ut3VGO9UakRf6rHLIJxxE4zDHzDURFgFT4eGFyWQ
         HSYX4+XPYEslRghHFZWJOAI6vbD1+BaOrh+Uyz+Y1hWjd27EYinOhumm2TuPnN489p
         20mTv/xqUFtrcab0NWrh0q+1SBSGHxFQePxX/ReE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "zhangyi (F)" <yi.zhang@huawei.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 339/399] jbd2: switch to use jbd2_journal_abort() when failed to submit the commit record
Date:   Fri, 21 Feb 2020 08:41:04 +0100
Message-Id: <20200221072433.869843546@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhangyi (F) <yi.zhang@huawei.com>

[ Upstream commit d0a186e0d3e7ac05cc77da7c157dae5aa59f95d9 ]

We invoke jbd2_journal_abort() to abort the journal and record errno
in the jbd2 superblock when committing journal transaction besides the
failure on submitting the commit record. But there is no need for the
case and we can also invoke jbd2_journal_abort() instead of
__jbd2_journal_abort_hard().

Fixes: 818d276ceb83a ("ext4: Add the journal checksum feature")
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20191204124614.45424-2-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/commit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 3845750f70ec8..27373f5792a4f 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -782,7 +782,7 @@ start_journal_io:
 		err = journal_submit_commit_record(journal, commit_transaction,
 						 &cbh, crc32_sum);
 		if (err)
-			__jbd2_journal_abort_hard(journal);
+			jbd2_journal_abort(journal, err);
 	}
 
 	blk_finish_plug(&plug);
@@ -875,7 +875,7 @@ start_journal_io:
 		err = journal_submit_commit_record(journal, commit_transaction,
 						&cbh, crc32_sum);
 		if (err)
-			__jbd2_journal_abort_hard(journal);
+			jbd2_journal_abort(journal, err);
 	}
 	if (cbh)
 		err = journal_wait_on_commit_record(journal, cbh);
-- 
2.20.1



