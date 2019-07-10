Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA6863E99
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 02:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfGJA3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jul 2019 20:29:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbfGJA3L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jul 2019 20:29:11 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6AB520645;
        Wed, 10 Jul 2019 00:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562718549;
        bh=bacaU1OxdOmT0R9cRxNDJ671Eey3dYdEH/+Uih4vI90=;
        h=Date:From:To:Subject:From;
        b=pZvCD4dKRJ7VNZySLnjoq7UJQ6WePRi0gr/KovMWAI6kgF+hIGRWGwzqKlLG6ckMT
         QDKn87eu59a6WP3zFYB9MSZdHoX1s4FcnouVQP+wOeaknNYzFlH9VqLwbJi+kd7YVa
         fmWCqsMj1qR9Ja06wl9eReUAaeimX+P5H8/94Ed8=
Date:   Tue, 09 Jul 2019 17:29:09 -0700
From:   akpm@linux-foundation.org
To:     jgg@mellanox.com, jglisse@redhat.com,
        kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        stable@vger.kernel.org
Subject:  +
 mm-hmm-fix-bad-subpage-pointer-in-try_to_unmap_one.patch added to -mm tree
Message-ID: <20190710002909.t9_-gS6wA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hmm: Fix bad subpage pointer in try_to_unmap_one
has been added to the -mm tree.  Its filename is
     mm-hmm-fix-bad-subpage-pointer-in-try_to_unmap_one.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hmm-fix-bad-subpage-pointer=
-in-try_to_unmap_one.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hmm-fix-bad-subpage-pointer=
-in-try_to_unmap_one.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/hmm: Fix bad subpage pointer in try_to_unmap_one

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

mm-hmm-fix-bad-subpage-pointer-in-try_to_unmap_one.patch

