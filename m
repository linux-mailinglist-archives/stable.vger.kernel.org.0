Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB8D014B20C
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 10:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgA1JvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 04:51:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39717 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726162AbgA1JvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 04:51:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580205076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+mL7eP+xIe7uFOXHzIdoUahyoIfaOlQfAVxV6UWyqbw=;
        b=QfOZKSprE9tdJwL3EWxYr/+6Lq2tJhvEOt+3aCDP3xmNg8FeUqD8fHonYRJxQsIIi7ztYm
        oQVE8XIiwdWWjGJamRvFsU/nE5ue5emIMKejy+X7Zrcc6Px2ajDirJ93RvRIziz4BDdqV9
        mVYufpC5n85O595FJpuCqRH+7Y849aU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-JHvH_oaGNIeWxqsYPsuw7A-1; Tue, 28 Jan 2020 04:51:14 -0500
X-MC-Unique: JHvH_oaGNIeWxqsYPsuw7A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B480F477;
        Tue, 28 Jan 2020 09:51:12 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-116-207.ams2.redhat.com [10.36.116.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 87BC860BE0;
        Tue, 28 Jan 2020 09:51:10 +0000 (UTC)
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
Subject: [PATCH for 4.19-stable v3 15/24] drivers/base/memory: pass a block_id to init_memory_block()
Date:   Tue, 28 Jan 2020 10:50:12 +0100
Message-Id: <20200128095021.8076-16-david@redhat.com>
In-Reply-To: <20200128095021.8076-1-david@redhat.com>
References: <20200128095021.8076-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 1811582587c43bdf13d690d83345610d4df433bb upstream.

We'll rework hotplug_memory_register() shortly, so it no longer consumes
pass a section.

[cai@lca.pw: fix a compilation warning]
  Link: http://lkml.kernel.org/r/1559320186-28337-1-git-send-email-cai@lc=
a.pw
Link: http://lkml.kernel.org/r/20190527111152.16324-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Qian Cai <cai@lca.pw>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Andrew Banman <andrew.banman@hpe.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Arun KS <arunks@codeaurora.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chintan Pandya <cpandya@codeaurora.org>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jun Yao <yaojun8558363@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Mathieu Malaterre <malat@debian.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: "mike.travis@hpe.com" <mike.travis@hpe.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/base/memory.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 9a5f81dc32c5..f9818d75ac43 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -660,21 +660,18 @@ int register_memory(struct memory_block *memory)
 	return ret;
 }
=20
-static int init_memory_block(struct memory_block **memory,
-			     struct mem_section *section, unsigned long state)
+static int init_memory_block(struct memory_block **memory, int block_id,
+			     unsigned long state)
 {
 	struct memory_block *mem;
 	unsigned long start_pfn;
-	int scn_nr;
 	int ret =3D 0;
=20
 	mem =3D kzalloc(sizeof(*mem), GFP_KERNEL);
 	if (!mem)
 		return -ENOMEM;
=20
-	scn_nr =3D __section_nr(section);
-	mem->start_section_nr =3D
-			base_memory_block_id(scn_nr) * sections_per_block;
+	mem->start_section_nr =3D block_id * sections_per_block;
 	mem->end_section_nr =3D mem->start_section_nr + sections_per_block - 1;
 	mem->state =3D state;
 	start_pfn =3D section_nr_to_pfn(mem->start_section_nr);
@@ -689,21 +686,18 @@ static int init_memory_block(struct memory_block **=
memory,
 static int add_memory_block(int base_section_nr)
 {
 	struct memory_block *mem;
-	int i, ret, section_count =3D 0, section_nr;
+	int i, ret, section_count =3D 0;
=20
 	for (i =3D base_section_nr;
 	     i < base_section_nr + sections_per_block;
-	     i++) {
-		if (!present_section_nr(i))
-			continue;
-		if (section_count =3D=3D 0)
-			section_nr =3D i;
-		section_count++;
-	}
+	     i++)
+		if (present_section_nr(i))
+			section_count++;
=20
 	if (section_count =3D=3D 0)
 		return 0;
-	ret =3D init_memory_block(&mem, __nr_to_section(section_nr), MEM_ONLINE=
);
+	ret =3D init_memory_block(&mem, base_memory_block_id(base_section_nr),
+				MEM_ONLINE);
 	if (ret)
 		return ret;
 	mem->section_count =3D section_count;
@@ -716,6 +710,7 @@ static int add_memory_block(int base_section_nr)
  */
 int hotplug_memory_register(int nid, struct mem_section *section)
 {
+	int block_id =3D base_memory_block_id(__section_nr(section));
 	int ret =3D 0;
 	struct memory_block *mem;
=20
@@ -726,7 +721,7 @@ int hotplug_memory_register(int nid, struct mem_secti=
on *section)
 		mem->section_count++;
 		put_device(&mem->dev);
 	} else {
-		ret =3D init_memory_block(&mem, section, MEM_OFFLINE);
+		ret =3D init_memory_block(&mem, block_id, MEM_OFFLINE);
 		if (ret)
 			goto out;
 		mem->section_count++;
--=20
2.24.1

