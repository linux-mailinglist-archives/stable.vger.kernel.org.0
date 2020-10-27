Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE4029B981
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802550AbgJ0PuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1795679AbgJ0PPT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:15:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FC0220657;
        Tue, 27 Oct 2020 15:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811718;
        bh=mSnEMt0wZBdP23QbnAwNuHi2Lus+8y0UzZ/0+xcpOZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ecGfPxLxdrfBU9q9BpyiQhWmPXFGJIh+mcMZljBupLzea59vkfrBbpprhm50zdaoP
         s0GEIgovJ7JU/FewiQsWD+n15zt7AJ2MOAvk7Z2hg5lMUabQSLoNOFxNwl/Nrs+zer
         rYGgyUi52tiEs6HrQYMcZA5nyu1XsinZfFuKYTFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 593/633] iomap: fix WARN_ON_ONCE() from unprivileged users
Date:   Tue, 27 Oct 2020 14:55:36 +0100
Message-Id: <20201027135550.638920129@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ec7b78e6fecaf..28d656b15300b 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -387,6 +387,16 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
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



