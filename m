Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89F3513C7E6
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 16:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbgAOPes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 10:34:48 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53432 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728901AbgAOPes (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 10:34:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579102486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A1Dc3gs8JZdhCjkc7OqCqrUxdiJH6iZG5nSEy7h1nY4=;
        b=XwuPz0jnn7C3SHeUR9Jx6Cqp9bdI9BCW7aUU8AO2kW93Tg+vf7MpqqD26innFtutlEvQQv
        dxf/nUUz03SWneerdsOiKuzscZ1Scz7LnJ0ptI2QLmhqTUmpo3Ii7WqCL+/t1UpmG0KdBK
        aLxA//HGEhL6InTdQ3wQM7ef5Bk0sjg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-FQWVYX7pNEaOnXsfG3rlBw-1; Wed, 15 Jan 2020 10:34:43 -0500
X-MC-Unique: FQWVYX7pNEaOnXsfG3rlBw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EED271945ECD;
        Wed, 15 Jan 2020 15:34:41 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.36.118.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C20CF86CB2;
        Wed, 15 Jan 2020 15:34:39 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     stable@vger.kernel.org
Cc:     linux-mm@kvack.org, Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Baoquan He <bhe@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH for 4.19-stable 21/25] mm/hotplug: kill is_dev_zone() usage in __remove_pages()
Date:   Wed, 15 Jan 2020 16:33:35 +0100
Message-Id: <20200115153339.36409-22-david@redhat.com>
In-Reply-To: <20200115153339.36409-1-david@redhat.com>
References: <20200115153339.36409-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 96da4350000973ef9310a10d077d65bbc017f093 upstream.

-- snip --

Minor conflict, keep the altmap check.

-- snip --

The zone type check was a leftover from the cleanup that plumbed altmap
through the memory hotplug path, i.e.  commit da024512a1fa "mm: pass the
vmem_altmap to arch_remove_memory and __remove_pages".

Link: http://lkml.kernel.org/r/156092352642.979959.6664333788149363039.st=
git@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>	[ppc64]
Cc: Michal Hocko <mhocko@suse.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/memory_hotplug.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 74cfa2fbe88e..888fcbdf97cf 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -507,11 +507,8 @@ void __remove_pages(struct zone *zone, unsigned long=
 phys_start_pfn,
 	unsigned long map_offset =3D 0;
 	int sections_to_remove;
=20
-	/* In the ZONE_DEVICE case device driver owns the memory region */
-	if (is_dev_zone(zone)) {
-		if (altmap)
-			map_offset =3D vmem_altmap_offset(altmap);
-	}
+	if (altmap)
+		map_offset =3D vmem_altmap_offset(altmap);
=20
 	clear_zone_contiguous(zone);
=20
--=20
2.24.1

