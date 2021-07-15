Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57BA13CA7B6
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242412AbhGOSz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:55:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239531AbhGOSxx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:53:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA109613CA;
        Thu, 15 Jul 2021 18:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375060;
        bh=/aw41K5/NSchCtxNyxON9OJdJYhSrdRVM1wLVHcs0hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D7/sRP+s950+4qtxnEXyHA6xUgLOCelPo8nZLdp2YGPCNn/9VTD8os4BhfKPGVIes
         G6UA/HYvyzIBx2xiSOLQirepD/FDMjwVmlVH/ehRbBaW9wwhXcUEXhc93XkPMqY62E
         eFD0bYzPw1yUg+X5MrjxEx7JXtMhQ4oN+xvfgdkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oscar Salvador <osalvador@suse.de>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 5.10 140/215] mm,hwpoison: return -EBUSY when migration fails
Date:   Thu, 15 Jul 2021 20:38:32 +0200
Message-Id: <20210715182624.294004469@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oscar Salvador <osalvador@suse.de>

commit 3f4b815a439adfb8f238335612c4b28bc10084d8

Currently, we return -EIO when we fail to migrate the page.

Migrations' failures are rather transient as they can happen due to
several reasons, e.g: high page refcount bump, mapping->migrate_page
failing etc.  All meaning that at that time the page could not be
migrated, but that has nothing to do with an EIO error.

Let us return -EBUSY instead, as we do in case we failed to isolate the
page.

While are it, let us remove the "ret" print as its value does not change.

Link: https://lkml.kernel.org/r/20201209092818.30417-1-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-failure.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1856,11 +1856,11 @@ static int __soft_offline_page(struct pa
 			pr_info("soft offline: %#lx: %s migration failed %d, type %lx (%pGp)\n",
 				pfn, msg_page[huge], ret, page->flags, &page->flags);
 			if (ret > 0)
-				ret = -EIO;
+				ret = -EBUSY;
 		}
 	} else {
-		pr_info("soft offline: %#lx: %s isolation failed: %d, page count %d, type %lx (%pGp)\n",
-			pfn, msg_page[huge], ret, page_count(page), page->flags, &page->flags);
+		pr_info("soft offline: %#lx: %s isolation failed, page count %d, type %lx (%pGp)\n",
+			pfn, msg_page[huge], page_count(page), page->flags, &page->flags);
 		ret = -EBUSY;
 	}
 	return ret;


