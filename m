Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9659137DB5
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729221AbgAKKA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:00:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:56590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729185AbgAKKA0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:00:26 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C58662082E;
        Sat, 11 Jan 2020 10:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736825;
        bh=ymVgdOoEAFWU4jK0LXVfQteJ4Fzw/vFX8zfX+147bdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FANfavlqjckXgxNpukAy2A0NiAXaE38M6uNG8EQC+Rl269HicBV9p9sWVVvhl43My
         2xuTfLBrbXVth1pI13MUTlYcWRL/WJmaOI2oiP3UTGAHQZVjHE1RQ6XZWqrEDkaWfm
         fDKwjAfJAVDS3OcmqRQ/BcE9sHVUVTv3S+ilI3pE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c732f8644185de340492@syzkaller.appspotmail.com,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 15/91] xfs: fix mount failure crash on invalid iclog memory access
Date:   Sat, 11 Jan 2020 10:49:08 +0100
Message-Id: <20200111094848.660860249@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094844.748507863@linuxfoundation.org>
References: <20200111094844.748507863@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 798a9cada4694ca8d970259f216cec47e675bfd5 ]

syzbot (via KASAN) reports a use-after-free in the error path of
xlog_alloc_log(). Specifically, the iclog freeing loop doesn't
handle the case of a fully initialized ->l_iclog linked list.
Instead, it assumes that the list is partially constructed and NULL
terminated.

This bug manifested because there was no possible error scenario
after iclog list setup when the original code was added.  Subsequent
code and associated error conditions were added some time later,
while the original error handling code was never updated. Fix up the
error loop to terminate either on a NULL iclog or reaching the end
of the list.

Reported-by: syzbot+c732f8644185de340492@syzkaller.appspotmail.com
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_log.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 33c9a3aae948..7bfcd09d446b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1540,6 +1540,8 @@ xlog_alloc_log(
 		if (iclog->ic_bp)
 			xfs_buf_free(iclog->ic_bp);
 		kmem_free(iclog);
+		if (prev_iclog == log->l_iclog)
+			break;
 	}
 	spinlock_destroy(&log->l_icloglock);
 	xfs_buf_free(log->l_xbuf);
-- 
2.20.1



