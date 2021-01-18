Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478702FA302
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389462AbhARLnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:43:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:38996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390659AbhARLng (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:43:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E08982222A;
        Mon, 18 Jan 2021 11:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970175;
        bh=c5M0GX/KyPccCx8l3Rju1NTzujwdled1A39+mZKlC1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vQH2EPs/io2iKLFzC8XMzV7xHPg+NLKe5f++Q8kTzEngUTLUzv+ToaaaKhnLqW1X2
         CAtYPTRZ+75bqRkaO1vLkLwhato+W3ZNor+bNkeHAZGvq+EKu53YAJYmGhym5ofpPT
         X1KjIwSI+qRQ8EyJkhoixVxZvFYsUeIJVFIOIEqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shijie Luo <luoshijie1@huawei.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 038/152] mm/vmalloc.c: fix potential memory leak
Date:   Mon, 18 Jan 2021 12:33:33 +0100
Message-Id: <20210118113354.611794436@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

commit c22ee5284cf58017fa8c6d21d8f8c68159b6faab upstream.

In VM_MAP_PUT_PAGES case, we should put pages and free array in vfree.
But we missed to set area->nr_pages in vmap().  So we would fail to put
pages in __vunmap() because area->nr_pages = 0.

Link: https://lkml.kernel.org/r/20210107123541.39206-1-linmiaohe@huawei.com
Fixes: b944afc9d64d ("mm: add a VM_MAP_PUT_PAGES flag for vmap")
Signed-off-by: Shijie Luo <luoshijie1@huawei.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmalloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2405,8 +2405,10 @@ void *vmap(struct page **pages, unsigned
 		return NULL;
 	}
 
-	if (flags & VM_MAP_PUT_PAGES)
+	if (flags & VM_MAP_PUT_PAGES) {
 		area->pages = pages;
+		area->nr_pages = count;
+	}
 	return area->addr;
 }
 EXPORT_SYMBOL(vmap);


