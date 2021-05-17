Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94AF638345D
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242700AbhEQPHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:07:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241301AbhEQPF2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:05:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D848461627;
        Mon, 17 May 2021 14:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261728;
        bh=HP7JlLYSu7uzp18cQRZzapuSDK/oW2xY9F2XEodd4Ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KPw9k/yLjz2HdJQe9CQP0pXQYnyWpo6ac3hQT/EBp7I6tJEfiZOJXjZyrJezl4RPQ
         n2uHCyBhLzJbeGCw7AYVTyDDGLGM50mKjanPGGu6YkW3rML9vDI6pOUrXiZtnLu6o9
         laB84c8sgkWm+QCqGVOPOIR/RPcz1pr0/MIuh3l8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Alistair Popple <apopple@nvidia.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Rafael Aquini <aquini@redhat.com>,
        Yang Shi <shy828301@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 082/141] mm/migrate.c: fix potential indeterminate pte entry in migrate_vma_insert_page()
Date:   Mon, 17 May 2021 16:02:14 +0200
Message-Id: <20210517140245.539243255@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit 34f5e9b9d1990d286199084efa752530ee3d8297 ]

If the zone device page does not belong to un-addressable device memory,
the variable entry will be uninitialized and lead to indeterminate pte
entry ultimately.  Fix this unexpected case and warn about it.

Link: https://lkml.kernel.org/r/20210325131524.48181-4-linmiaohe@huawei.com
Fixes: df6ad69838fc ("mm/device-public-memory: device memory cache coherent with CPU")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/migrate.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index c4c313e47f12..00bbe57c1ce2 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2771,6 +2771,13 @@ static void migrate_vma_insert_page(struct migrate_vma *migrate,
 
 			swp_entry = make_device_private_entry(page, vma->vm_flags & VM_WRITE);
 			entry = swp_entry_to_pte(swp_entry);
+		} else {
+			/*
+			 * For now we only support migrating to un-addressable
+			 * device memory.
+			 */
+			pr_warn_once("Unsupported ZONE_DEVICE page type.\n");
+			goto abort;
 		}
 	} else {
 		entry = mk_pte(page, vma->vm_page_prot);
-- 
2.30.2



