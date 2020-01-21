Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C03781443E8
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 19:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729273AbgAUSCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 13:02:38 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24008 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729399AbgAUSCh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jan 2020 13:02:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579629756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q7+B7kA+K5vm1PBvKdf/WWruA8iRMBrg/brj2Z528cc=;
        b=HlEaxNo6O5skxGWuABUMM6r9n1Ry2s5ED1oMAHkKHnS4n6DyVlgQ97AYlLo8H2ZsYMi5I9
        /q8CZ091WiJUdf1s9R9q2hI85wswzCOxaUHUK07sGrUpBCjUhMCBejhNmT9QX0KHRhre+S
        NN+Sxm0eGjIYmLJuP9JG6FIMQ80JpCQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-yQEsAdkDMV6mee36oqi-vw-1; Tue, 21 Jan 2020 13:02:30 -0500
X-MC-Unique: yQEsAdkDMV6mee36oqi-vw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BCEE107ACC7;
        Tue, 21 Jan 2020 18:02:27 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.36.118.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14EDC5C3FD;
        Tue, 21 Jan 2020 18:02:19 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     stable@vger.kernel.org
Cc:     linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Baoquan He <bhe@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Wei Yang <richard.weiyang@gmail.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH for 4.19-stable v2 07/24] drivers/base/memory.c: clean up relics in function parameters
Date:   Tue, 21 Jan 2020 19:01:33 +0100
Message-Id: <20200121180150.37454-8-david@redhat.com>
In-Reply-To: <20200121180150.37454-1-david@redhat.com>
References: <20200121180150.37454-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baoquan He <bhe@redhat.com>

commit 063b8a4cee8088224bcdb79bcd08db98df16178e upstream.

The input parameter 'phys_index' of memory_block_action() is actually the
section number, but not the phys_index of memory_block.  This is a relic
from the past when one memory block could only contain one section.
Rename it to start_section_nr.

And also in remove_memory_section(), the 'node_id' and 'phys_device'
arguments are not used by anyone.  Remove them.

Link: http://lkml.kernel.org/r/20190329144250.14315-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/base/memory.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 5fca7225f3fe..b384f01ad29d 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -230,13 +230,14 @@ static bool pages_correctly_probed(unsigned long st=
art_pfn)
  * OK to have direct references to sparsemem variables in here.
  */
 static int
-memory_block_action(unsigned long phys_index, unsigned long action, int =
online_type)
+memory_block_action(unsigned long start_section_nr, unsigned long action=
,
+		    int online_type)
 {
 	unsigned long start_pfn;
 	unsigned long nr_pages =3D PAGES_PER_SECTION * sections_per_block;
 	int ret;
=20
-	start_pfn =3D section_nr_to_pfn(phys_index);
+	start_pfn =3D section_nr_to_pfn(start_section_nr);
=20
 	switch (action) {
 	case MEM_ONLINE:
@@ -250,7 +251,7 @@ memory_block_action(unsigned long phys_index, unsigne=
d long action, int online_t
 		break;
 	default:
 		WARN(1, KERN_WARNING "%s(%ld, %ld) unknown action: "
-		     "%ld\n", __func__, phys_index, action, action);
+		     "%ld\n", __func__, start_section_nr, action, action);
 		ret =3D -EINVAL;
 	}
=20
@@ -747,8 +748,7 @@ unregister_memory(struct memory_block *memory)
 	device_unregister(&memory->dev);
 }
=20
-static int remove_memory_section(unsigned long node_id,
-			       struct mem_section *section, int phys_device)
+static int remove_memory_section(struct mem_section *section)
 {
 	struct memory_block *mem;
=20
@@ -780,7 +780,7 @@ int unregister_memory_section(struct mem_section *sec=
tion)
 	if (!present_section(section))
 		return -EINVAL;
=20
-	return remove_memory_section(0, section, 0);
+	return remove_memory_section(section);
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
=20
--=20
2.24.1

