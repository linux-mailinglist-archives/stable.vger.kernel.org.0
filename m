Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB6F616751F
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388526AbgBUIXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:23:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:35862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388520AbgBUIXl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:23:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A865524697;
        Fri, 21 Feb 2020 08:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273421;
        bh=IyLLtVHl5dqCwlj4ZeFJHDfJHrnChzzGasCQVGen4fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LjW3zNs8ZPeoqv2Zu/OStVEPaY3VPjW9WAUBmeDpX0IvPwGZFHWF5/sQQDdR4AfXu
         UJwszIR0re5G9uyTrQ5HNzsB1cQwle1WaCjOLpEYFHdi0BSQ+ZnNFOsWkDb7knGiW0
         6fW2LR6jlrN3VLaC3dtZaJg75qbqRXUnqWFI2zSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "zhangyi (F)" <yi.zhang@huawei.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 163/191] jbd2: make sure ESHUTDOWN to be recorded in the journal superblock
Date:   Fri, 21 Feb 2020 08:42:16 +0100
Message-Id: <20200221072310.345726702@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhangyi (F) <yi.zhang@huawei.com>

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
index 1a96287f92647..a15a22d209090 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2133,8 +2133,7 @@ static void __journal_abort_soft (journal_t *journal, int errno)
 
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



