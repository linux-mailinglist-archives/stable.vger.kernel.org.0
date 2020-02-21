Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83FDF1675B5
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733077AbgBUIPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:15:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:52444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732657AbgBUIPg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:15:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00B9C24670;
        Fri, 21 Feb 2020 08:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272935;
        bh=tHzSWHCdyVFWI5DrEYz+/oYVT8reW7bX7g380mK4cOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AKo/AbW+GZdcOKzFC8KoJC6wznCJg+c/KbsCtRvMxE9ZqT0z/3nCsp7PZd0uqVTkH
         RdqV/QIUn//4WV0EoFmwuTdL3Z40dI4mRfmGFP6i9y2gavFU6EMjWQJE+XPz0dAPHl
         z9q9+9PVXK+95bUR1fL2dBsE335IZFN19rSJP99g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "zhangyi (F)" <yi.zhang@huawei.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 294/344] jbd2: make sure ESHUTDOWN to be recorded in the journal superblock
Date:   Fri, 21 Feb 2020 08:41:33 +0100
Message-Id: <20200221072416.569187874@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
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



