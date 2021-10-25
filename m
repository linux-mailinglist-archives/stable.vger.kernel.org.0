Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFB143A160
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236683AbhJYTiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:38:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235171AbhJYTfh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:35:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C3506105A;
        Mon, 25 Oct 2021 19:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190376;
        bh=zbKQ1sBdjgOxJMMGjfW9LsPtXSkoQfTPpBNAz5r5MHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pNiqjQ+ongfCQHZeyzpLeXSg1a2heVuHrAenhWpR7BMTlWmur/9U1wYeo0MdMq5Zs
         h79oQodKp+OU7DOuhOBc07OGXPZbI/Z7Wjd3oxovVFIv7/C0d2ymry/XGXucJIK1DL
         tGnOCkMD+aJjIW7c9uK+DRyHmGnwcnkV2+EZFAoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Faiyaz Mohammed <faiyazm@codeaurora.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Kees Cook <keescook@chromium.org>,
        Pekka Enberg <penberg@kernel.org>,
        Roman Gushchin <guro@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 60/95] mm, slub: fix potential memoryleak in kmem_cache_open()
Date:   Mon, 25 Oct 2021 21:14:57 +0200
Message-Id: <20211025191005.622375123@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

commit 9037c57681d25e4dcc442d940d6dbe24dd31f461 upstream.

In error path, the random_seq of slub cache might be leaked.  Fix this
by using __kmem_cache_release() to release all the relevant resources.

Link: https://lkml.kernel.org/r/20210916123920.48704-4-linmiaohe@huawei.com
Fixes: 210e7a43fa90 ("mm: SLUB freelist randomization")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Bharata B Rao <bharata@linux.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Faiyaz Mohammed <faiyazm@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3832,8 +3832,8 @@ static int kmem_cache_open(struct kmem_c
 	if (alloc_kmem_cache_cpus(s))
 		return 0;
 
-	free_kmem_cache_nodes(s);
 error:
+	__kmem_cache_release(s);
 	return -EINVAL;
 }
 


