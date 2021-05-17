Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B36C38358E
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242671AbhEQPXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:23:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243347AbhEQPSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:18:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B343161C6E;
        Mon, 17 May 2021 14:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262009;
        bh=LlLP6X09O5DlDYbL590+9uh82tEFBXAaaL5feOB3nik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a4Uo7DDr/KntlAyiWqKgilC/Vy3oQY/CQUuI+X6I25JRFVy6bryAvs96+gKtk2AL/
         U56+KEaMwCTOixIT/reS0/y2kQuJ7ti8Dmd7lkLVPrWr1fMG3aFI7jGtLmQhiJWaLO
         w0PTsGqH4w1eeEspT+13Fa6ehtInPZt506kgLFVE=
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
Subject: [PATCH 5.11 203/329] mm/migrate.c: fix potential indeterminate pte entry in migrate_vma_insert_page()
Date:   Mon, 17 May 2021 16:01:54 +0200
Message-Id: <20210517140308.980753642@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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
index 20ca887ea769..4754f2489d78 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2967,6 +2967,13 @@ static void migrate_vma_insert_page(struct migrate_vma *migrate,
 
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



