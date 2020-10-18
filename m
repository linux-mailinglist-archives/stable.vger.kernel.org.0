Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46468291D2D
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730344AbgJRTnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:43:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730358AbgJRTXk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:23:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45AF5222C8;
        Sun, 18 Oct 2020 19:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049019;
        bh=pczS5DlWXVa6fiIHMoBSKiiTtWrg4VUKcYl1CkNJuok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O2wDltW8qSAsfWSlKBXw4nP9RmGSFMMH/GMb55RuGGbp1RRK1DsJExACjKHpsoB1u
         slohW96giiPqv8a2OBE6OraWP5jHMO78JmoroY0fm6z6gDR8Lit14TeSrEEYecnBUq
         N9shVJoB7wzLTwRCVat81uX0hOh0WHiUJcpH4hec=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 54/80] iomap: fix WARN_ON_ONCE() from unprivileged users
Date:   Sun, 18 Oct 2020 15:22:05 -0400
Message-Id: <20201018192231.4054535-54-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192231.4054535-1-sashal@kernel.org>
References: <20201018192231.4054535-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit a805c111650cdba6ee880f528abdd03c1af82089 ]

It is trivial to trigger a WARN_ON_ONCE(1) in iomap_dio_actor() by
unprivileged users which would taint the kernel, or worse - panic if
panic_on_warn or panic_on_taint is set. Hence, just convert it to
pr_warn_ratelimited() to let users know their workloads are racing.
Thank Dave Chinner for the initial analysis of the racing reproducers.

Signed-off-by: Qian Cai <cai@lca.pw>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/direct-io.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 7b5f76efef02d..8c98fd92bf665 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -377,6 +377,16 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 		return iomap_dio_bio_actor(inode, pos, length, dio, iomap);
 	case IOMAP_INLINE:
 		return iomap_dio_inline_actor(inode, pos, length, dio, iomap);
+	case IOMAP_DELALLOC:
+		/*
+		 * DIO is not serialised against mmap() access at all, and so
+		 * if the page_mkwrite occurs between the writeback and the
+		 * iomap_apply() call in the DIO path, then it will see the
+		 * DELALLOC block that the page-mkwrite allocated.
+		 */
+		pr_warn_ratelimited("Direct I/O collision with buffered writes! File: %pD4 Comm: %.20s\n",
+				    dio->iocb->ki_filp, current->comm);
+		return -EIO;
 	default:
 		WARN_ON_ONCE(1);
 		return -EIO;
-- 
2.25.1

