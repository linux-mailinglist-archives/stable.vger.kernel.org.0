Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C92BD15EB8A
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391453AbgBNQKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:10:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:35768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391451AbgBNQKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:10:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB22624697;
        Fri, 14 Feb 2020 16:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696617;
        bh=QTJ9Kg3VYZ3zWPWj0Uv6WNsojZ4uA4pahx8vI4MGYX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E8W5f88TXTbhfm8CU8O97cqGShRCamjv8OiB784co4s3TznPnY8Nu+qEEkIIRpdso
         iwWpRmjJ8YT8rKcA3rAfWHQhjLCLE3q3Up4epGkuCFtrzAkebQvKREHG10bJnA56wA
         nhWqAHBAKygF4OWXSgOJOalsjd8qzopwfCrxgJiU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "zhangyi (F)" <yi.zhang@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 399/459] jbd2: make sure ESHUTDOWN to be recorded in the journal superblock
Date:   Fri, 14 Feb 2020 11:00:49 -0500
Message-Id: <20200214160149.11681-399-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "zhangyi (F)" <yi.zhang@huawei.com>

[ Upstream commit 0e98c084a21177ef136149c6a293b3d1eb33ff92 ]

Commit fb7c02445c49 ("ext4: pass -ESHUTDOWN code to jbd2 layer") want
to allow jbd2 layer to distinguish shutdown journal abort from other
error cases. So the ESHUTDOWN should be taken precedence over any other
errno which has already been recoded after EXT4_FLAGS_SHUTDOWN is set,
but it only update errno in the journal suoerblock now if the old errno
is 0.

Fixes: fb7c02445c49 ("ext4: pass -ESHUTDOWN code to jbd2 layer")
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20191204124614.45424-4-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/journal.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 65e78d3a2f64c..c1ce2805c5639 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2114,8 +2114,7 @@ static void __journal_abort_soft (journal_t *journal, int errno)
 
 	if (journal->j_flags & JBD2_ABORT) {
 		write_unlock(&journal->j_state_lock);
-		if (!old_errno && old_errno != -ESHUTDOWN &&
-		    errno == -ESHUTDOWN)
+		if (old_errno != -ESHUTDOWN && errno == -ESHUTDOWN)
 			jbd2_journal_update_sb_errno(journal);
 		return;
 	}
-- 
2.20.1

