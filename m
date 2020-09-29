Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6ADA27CB3E
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732715AbgI2MZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:25:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728493AbgI2Ldc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:33:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6E7723BDE;
        Tue, 29 Sep 2020 11:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378863;
        bh=r3usBbgdB6SBB/hyaXQtkm5z6RepovNZ6PuxvKuzcVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KlIX7hBGMtMLqEHu+9aTvXwEvdTwqsYMnMH2iwBCIhP33UKda08HJkSUixef11URw
         QcvYma9Um9I/vSFW9LZLak0p0t25XPkndcjY23WWfk3OIllsjiXhOt7Lumf20sXALW
         wPAR32QNxw/+ScJN+dN5woG3SLZOLWbZIeaOMFA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 166/245] fuse: dont check refcount after stealing page
Date:   Tue, 29 Sep 2020 13:00:17 +0200
Message-Id: <20200929105955.059007465@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
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
index 01e6ea11822bf..c51c9a6881e49 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -831,7 +831,6 @@ static int fuse_check_page(struct page *page)
 {
 	if (page_mapcount(page) ||
 	    page->mapping != NULL ||
-	    page_count(page) != 1 ||
 	    (page->flags & PAGE_FLAGS_CHECK_AT_PREP &
 	     ~(1 << PG_locked |
 	       1 << PG_referenced |
-- 
2.25.1



