Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C79E43A2CE
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237909AbhJYTwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:52:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238630AbhJYTuq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:50:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4ABD60C41;
        Mon, 25 Oct 2021 19:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190953;
        bh=IT8ffS5OJEbVtpDypgVbI4Wto6k5Waur6DCpttyT1js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1pehf+s/KWMx+uAhLcCBr48Evbx0v7pKTTCQKDJS45zPF7WzLPJUVXsx59WUAcC15
         Gl0bRmO3prbP1uVKclfcx4W85MK3s4XFDJEnqEOjXehdxYolWTipwq/lDcJwSkTxzY
         YsRGQU8hdrNYDD82uNG18DTbFygcyX3Xau5DMwLo=
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
Subject: [PATCH 5.14 102/169] mm, slub: fix potential use-after-free in slab_debugfs_fops
Date:   Mon, 25 Oct 2021 21:14:43 +0200
Message-Id: <20211025191030.845152523@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

commit 67823a544414def2a36c212abadb55b23bcda00c upstream.

When sysfs_slab_add failed, we shouldn't call debugfs_slab_add() for s
because s will be freed soon.  And slab_debugfs_fops will use s later
leading to a use-after-free.

Link: https://lkml.kernel.org/r/20210916123920.48704-5-linmiaohe@huawei.com
Fixes: 64dd68497be7 ("mm: slub: move sysfs slab alloc/free interfaces to debugfs")
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
 mm/slub.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4604,13 +4604,15 @@ int __kmem_cache_create(struct kmem_cach
 		return 0;
 
 	err = sysfs_slab_add(s);
-	if (err)
+	if (err) {
 		__kmem_cache_release(s);
+		return err;
+	}
 
 	if (s->flags & SLAB_STORE_USER)
 		debugfs_slab_add(s);
 
-	return err;
+	return 0;
 }
 
 void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, unsigned long caller)


