Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20B4210BD27
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730997AbfK0VCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:02:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:54502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727340AbfK0VCB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:02:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D2F82084B;
        Wed, 27 Nov 2019 21:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888520;
        bh=/X42qqck8nkLc0mAmS/qSEjM3OBOAqD15gc7gZhyWjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G6XG/lJSz/201uNsHqwYHhzu+0G0jpERtkVwlPmhYxHbyPkDUUOloPW7C9lQd/ZwH
         uc9TrwhNFAa+3O7d36LHiRDE199XCqpVnW/vicIe90gfRNI7VjvwpzaQ18StY4RyYw
         JSCRhyIUeUq/ME3xaTL3zyhkcVadtkX4dMeoSndA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Keith Busch <keith.busch@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 166/306] mm/gup_benchmark.c: prevent integer overflow in ioctl
Date:   Wed, 27 Nov 2019 21:30:16 +0100
Message-Id: <20191127203127.552874142@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 4b408c74ee5a0b74fc9265c2fe39b0e7dec7c056 ]

The concern here is that "gup->size" is a u64 and "nr_pages" is unsigned
long.  On 32 bit systems we could trick the kernel into allocating fewer
pages than expected.

Link: http://lkml.kernel.org/r/20181025061546.hnhkv33diogf2uis@kili.mountain
Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Keith Busch <keith.busch@intel.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup_benchmark.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/gup_benchmark.c b/mm/gup_benchmark.c
index 7405c9d89d651..7e6f2d2dafb55 100644
--- a/mm/gup_benchmark.c
+++ b/mm/gup_benchmark.c
@@ -23,6 +23,9 @@ static int __gup_benchmark_ioctl(unsigned int cmd,
 	int nr;
 	struct page **pages;
 
+	if (gup->size > ULONG_MAX)
+		return -EINVAL;
+
 	nr_pages = gup->size / PAGE_SIZE;
 	pages = kvcalloc(nr_pages, sizeof(void *), GFP_KERNEL);
 	if (!pages)
-- 
2.20.1



