Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAD0814B209
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 10:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgA1JvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 04:51:05 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51490 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726162AbgA1JvF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 04:51:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580205064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uBgTreueQ4GMfX9dOgeNYJcp9dN6Z4IlmuREQf3D2BY=;
        b=M7+ABDHy2yVtLVgHBFuk4lHK6aix7j2Vv55qIwJbzPZdHDSPKNqiPILv+dE2ZvGiKGzu0G
        /mrlvcSytd5CIf2UKRwE6aGeIAHFKKWWlZqvr2RhJJ1tcTH97Uj0iaeTirKDJmDEsZ7Wxx
        RVelB80q6UDTF/P+1Ky2pJPwX4tpv4c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-P3c8-9mCMpifqe9ZwLcA0w-1; Tue, 28 Jan 2020 04:51:00 -0500
X-MC-Unique: P3c8-9mCMpifqe9ZwLcA0w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9D5918FF660;
        Tue, 28 Jan 2020 09:50:58 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-116-207.ams2.redhat.com [10.36.116.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93C6960BE0;
        Tue, 28 Jan 2020 09:50:55 +0000 (UTC)
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
Subject: [PATCH for 4.19-stable v3 11/24] powerpc/mm: Fix section mismatch warning
Date:   Tue, 28 Jan 2020 10:50:08 +0100
Message-Id: <20200128095021.8076-12-david@redhat.com>
In-Reply-To: <20200128095021.8076-1-david@redhat.com>
References: <20200128095021.8076-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>

commit 26ad26718dfaa7cf49d106d212ebf2370076c253 upstream.

This patch fix the below section mismatch warnings.

WARNING: vmlinux.o(.text+0x2d1f44): Section mismatch in reference from th=
e function devm_memremap_pages_release() to the function .meminit.text:ar=
ch_remove_memory()
WARNING: vmlinux.o(.text+0x2d265c): Section mismatch in reference from th=
e function devm_memremap_pages() to the function .meminit.text:arch_add_m=
emory()

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/powerpc/mm/mem.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 1b6e0ef5d14d..625d78547fe7 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -118,8 +118,8 @@ int __weak remove_section_mapping(unsigned long start=
, unsigned long end)
 	return -ENODEV;
 }
=20
-int __meminit arch_add_memory(int nid, u64 start, u64 size, struct vmem_=
altmap *altmap,
-		bool want_memblock)
+int __ref arch_add_memory(int nid, u64 start, u64 size, struct vmem_altm=
ap *altmap,
+			  bool want_memblock)
 {
 	unsigned long start_pfn =3D start >> PAGE_SHIFT;
 	unsigned long nr_pages =3D size >> PAGE_SHIFT;
@@ -140,8 +140,8 @@ int __meminit arch_add_memory(int nid, u64 start, u64=
 size, struct vmem_altmap *
 }
=20
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int __meminit arch_remove_memory(int nid, u64 start, u64 size,
-					struct vmem_altmap *altmap)
+int __ref arch_remove_memory(int nid, u64 start, u64 size,
+			     struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn =3D start >> PAGE_SHIFT;
 	unsigned long nr_pages =3D size >> PAGE_SHIFT;
--=20
2.24.1

