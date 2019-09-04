Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9C9A8FE5
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388530AbfIDSGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:06:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388704AbfIDSGb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:06:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC82222CF7;
        Wed,  4 Sep 2019 18:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620390;
        bh=EXJFMCe0j7c1JE5xw+Ox8ar2HYLuO+hkBy9PQix63Jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pDZBwTh3KhbQgIe92iJKdoIOcEIm8pLnb9tuj0fniIVU8bnOMNwrieunxxPH6FfFp
         p3HIIlkpcw9jk7t0J8pQ/UtTEpeIGWqVBGa+lNMt5HdnlUW8m5hVAvvfuVAHobY3Uy
         F5ilOOSjB9Y612tXRAW91dL/nxLe4Tiiz4BHX8ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Henry Burns <henrywolfeburns@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Jonathan Adams <jwadams@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 39/93] mm/zsmalloc.c: fix build when CONFIG_COMPACTION=n
Date:   Wed,  4 Sep 2019 19:53:41 +0200
Message-Id: <20190904175306.592082075@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

commit 441e254cd40dc03beec3c650ce6ce6074bc6517f upstream.

Fixes: 701d678599d0c1 ("mm/zsmalloc.c: fix race condition in zs_destroy_pool")
Link: http://lkml.kernel.org/r/201908251039.5oSbEEUT%25lkp@intel.com
Reported-by: kbuild test robot <lkp@intel.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Henry Burns <henrywolfeburns@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Jonathan Adams <jwadams@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/zsmalloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -2432,7 +2432,9 @@ struct zs_pool *zs_create_pool(const cha
 	if (!pool->name)
 		goto err;
 
+#ifdef CONFIG_COMPACTION
 	init_waitqueue_head(&pool->migration_wait);
+#endif
 
 	if (create_cache(pool))
 		goto err;


