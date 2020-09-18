Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8377026ED3E
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729598AbgIRCRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:17:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729544AbgIRCRs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:17:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4817D23772;
        Fri, 18 Sep 2020 02:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395468;
        bh=bJmLIFgkps+uvZwlLZlyfVmMQ0zhPoXU7BMyDWH1xm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=giQKlQkMymfbwSUhdXZIoPBDlE1nICa6Vlqq7NoBRyArM5tNSaMt1BJuqzsZVT/dV
         lRj1i1WUkoTh3cUO4fVfl0zJl+03sA1+wCVF25Ny0JeRyQu+Ffd9sH68e7g2GyhvKO
         irwzVFoMID/uWpyoy4H6C6E0pOqeLoyv4ubLM88s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        fuse-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.4 53/64] fuse: don't check refcount after stealing page
Date:   Thu, 17 Sep 2020 22:16:32 -0400
Message-Id: <20200918021643.2067895-53-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021643.2067895-1-sashal@kernel.org>
References: <20200918021643.2067895-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

