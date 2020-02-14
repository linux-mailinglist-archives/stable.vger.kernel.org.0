Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D170F15E3A4
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406453AbgBNQbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:31:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:36280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406292AbgBNQ0G (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:26:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C990247B1;
        Fri, 14 Feb 2020 16:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697565;
        bh=FMn3dqKXlRf0VWYX1FOgHq9M1KnMQBmA7KSUS80C7sI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WJf496GpW7e0eTtkS9NFJ0cu67/asa9N3IPJK5C7n4OIhmnt7hb3xcT0EU4xEvBln
         Mq43Ix0n0X/U3zD9oZRozW//64vP7EFQeSEl4t3y+dt14t4sgRyI2QPLeU5cwl5gGB
         0M9YkvbKNxCcAYcbxeeQkwwCLpYhSMCUiCYCjnaM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "zhangyi (F)" <yi.zhang@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 081/100] jbd2: switch to use jbd2_journal_abort() when failed to submit the commit record
Date:   Fri, 14 Feb 2020 11:24:05 -0500
Message-Id: <20200214162425.21071-81-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162425.21071-1-sashal@kernel.org>
References: <20200214162425.21071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "zhangyi (F)" <yi.zhang@huawei.com>

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
index ebbd7d054cabd..6710fff0085e0 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -797,7 +797,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		err = journal_submit_commit_record(journal, commit_transaction,
 						 &cbh, crc32_sum);
 		if (err)
-			__jbd2_journal_abort_hard(journal);
+			jbd2_journal_abort(journal, err);
 	}
 
 	blk_finish_plug(&plug);
@@ -890,7 +890,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
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

