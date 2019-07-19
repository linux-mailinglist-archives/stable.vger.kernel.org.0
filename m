Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB5ED6EBD1
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 23:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731911AbfGSU7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 16:59:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731747AbfGSU7v (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 16:59:51 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D579D21849;
        Fri, 19 Jul 2019 20:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563569990;
        bh=IDvVSc1a5nuwKvdt+BzwEa8zJyMLfqeRw6wcZV5/aao=;
        h=Date:From:To:Subject:From;
        b=N3aq4xvejOsmBBGPjCfSjk4rKMkk5QyyHTyCaYdwIyZtB+91GO9qvx1eNx+ozEz0a
         lr27fQ7egmU2/aTmfZxWhgEsW4caX7iJ8Cu8Xr+wDG/DhWYnvY0q4PvPLtDyw0yQUm
         1F+HG1EBpEV4lXTrkifXAbaAAcQnADo4R4grfDxE=
Date:   Fri, 19 Jul 2019 13:59:49 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mike.kravetz@oracle.com, kirill.shutemov@linux.intel.com,
        jglisse@redhat.com, jgg@mellanox.com, rcampbell@nvidia.com
Subject:  [to-be-updated]
 mm-hmm-fix-bad-subpage-pointer-in-try_to_unmap_one.patch removed from -mm
 tree
Message-ID: <20190719205949.bc5aa%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hmm: fix bad subpage pointer in try_to_unmap_one
has been removed from the -mm tree.  Its filename was
     mm-hmm-fix-bad-subpage-pointer-in-try_to_unmap_one.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/hmm: fix bad subpage pointer in try_to_unmap_one

When migrating a ZONE device private page from device memory to system
memory, the subpage pointer is initialized from a swap pte which computes
an invalid page pointer. A kernel panic results such as:

BUG: unable to handle page fault for address: ffffea1fffffffc8

Initialize subpage correctly before calling page_remove_rmap().

Link: http://lkml.kernel.org/r/20190709223556.28908-1-rcampbell@nvidia.com
Fixes: a5430dda8a3a1c ("mm/migrate: support un-addressable ZONE_DEVICE page=
 in migration")
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/rmap.c~mm-hmm-fix-bad-subpage-pointer-in-try_to_unmap_one
+++ a/mm/rmap.c
@@ -1476,6 +1476,7 @@ static bool try_to_unmap_one(struct page
 			 * No need to invalidate here it will synchronize on
 			 * against the special swap migration pte.
 			 */
+			subpage =3D page;
 			goto discard;
 		}
=20
_

Patches currently in -mm which might be from rcampbell@nvidia.com are


