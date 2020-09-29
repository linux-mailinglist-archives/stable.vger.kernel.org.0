Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3EF27C383
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbgI2LG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:06:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728734AbgI2LFd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:05:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F23320C09;
        Tue, 29 Sep 2020 11:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377530;
        bh=bJmLIFgkps+uvZwlLZlyfVmMQ0zhPoXU7BMyDWH1xm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ARrTQIL/hSlurt5qrlkieyqo1bwtEOs3H7UjiQwHfhRLo5tfIZjBbZ12Cv/Un/CgO
         zH8WS3hGreFsfHWB9U3/MK8YFCG1TdrKq8H5lPy+zvHBH40X2zjRYJJ5B0K5YK+VWf
         pGb9j523hg02UMiOlXRgmFVe7IV4NtywhywAcnHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 61/85] fuse: dont check refcount after stealing page
Date:   Tue, 29 Sep 2020 13:00:28 +0200
Message-Id: <20200929105931.262811710@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105928.198942536@linuxfoundation.org>
References: <20200929105928.198942536@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 32f98877c57bee6bc27f443a96f49678a2cd6a50 ]

page_count() is unstable.  Unless there has been an RCU grace period
between when the page was removed from the page cache and now, a
speculative reference may exist from the page cache.

Reported-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 8142f6bf3d310..fc265f4b839ae 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -850,7 +850,6 @@ static int fuse_check_page(struct page *page)
 {
 	if (page_mapcount(page) ||
 	    page->mapping != NULL ||
-	    page_count(page) != 1 ||
 	    (page->flags & PAGE_FLAGS_CHECK_AT_PREP &
 	     ~(1 << PG_locked |
 	       1 << PG_referenced |
-- 
2.25.1



