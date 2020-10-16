Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE9CF290933
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 18:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410574AbgJPQE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 12:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410569AbgJPQE4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 12:04:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF1DC0613DE;
        Fri, 16 Oct 2020 09:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=J3dIYfqfYa58oXV6j+5Y6Rq8CwUVru9FXe4AJtaFdts=; b=vCH11OKZXL9NGakbK4kDvShlck
        2N1p/5myGxqgcjko4iNvCq32P73BNcmWnyBns4QWj+n+rhh8u9pRPawGx4M/1w6lZdNSDKCOBAmuu
        3hserHxEru/BWigBhy+IwlvYFFrboAtozx8dmlZxRdtv/qeJLtJCuV9TsZm+EfuNShRw7ZGdn1chk
        KRG0gGMEWkTIAy881LlpvLSntWo6aedRtfBL65ObCuTTG4i2qXjqSqwObEbNflG5bCEO3Czc/5+6x
        8m9bPSZ5YR5dEHaTg2p1NlRx8+s5T44ihtgxdgxD5Mddr6DTxp1SdjsD1vwPk7ZjF2xVEw3jDHcEg
        z9W3ZX1g==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kTSDl-0004s8-4B; Fri, 16 Oct 2020 16:04:45 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-mm@kvack.org, David Howells <dhowells@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH v3 01/18] cachefiles: Handle readpage error correctly
Date:   Fri, 16 Oct 2020 17:04:26 +0100
Message-Id: <20201016160443.18685-2-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201016160443.18685-1-willy@infradead.org>
References: <20201016160443.18685-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If ->readpage returns an error, it has already unlocked the page.

Fixes: 5e929b33c393 ("CacheFiles: Handle truncate unlocking the page we're reading")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/cachefiles/rdwr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
index 3080cda9e824..8bda092e60c5 100644
--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -121,7 +121,7 @@ static int cachefiles_read_reissue(struct cachefiles_object *object,
 		_debug("reissue read");
 		ret = bmapping->a_ops->readpage(NULL, backpage);
 		if (ret < 0)
-			goto unlock_discard;
+			goto discard;
 	}
 
 	/* but the page may have been read before the monitor was installed, so
@@ -138,6 +138,7 @@ static int cachefiles_read_reissue(struct cachefiles_object *object,
 
 unlock_discard:
 	unlock_page(backpage);
+discard:
 	spin_lock_irq(&object->work_lock);
 	list_del(&monitor->op_link);
 	spin_unlock_irq(&object->work_lock);
-- 
2.28.0

