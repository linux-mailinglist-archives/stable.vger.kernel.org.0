Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3657BFF28E
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbfKPPpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:45:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:49896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729067AbfKPPos (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:44:48 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB405207FA;
        Sat, 16 Nov 2019 15:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919087;
        bh=/X42qqck8nkLc0mAmS/qSEjM3OBOAqD15gc7gZhyWjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ue3wTW4bGDhHFAl9i7h2KsOf0DL2XOD9FxydrFnJyTLMWSbbnzwemvB4ZpL8cbVIT
         KhR4xBB2tLr1URar4G4MAkU5bAoT7tAaeuWpWCzen7NzDu89gPpQUXV2fMWClYpKA5
         +4aUMv0IlQTg70zxLxKNSE+K5RAdMa2Zns8D1Y+Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Keith Busch <keith.busch@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 4.19 149/237] mm/gup_benchmark.c: prevent integer overflow in ioctl
Date:   Sat, 16 Nov 2019 10:39:44 -0500
Message-Id: <20191116154113.7417-149-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

