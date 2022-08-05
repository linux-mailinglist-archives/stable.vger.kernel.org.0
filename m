Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2AF58A9DE
	for <lists+stable@lfdr.de>; Fri,  5 Aug 2022 13:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240571AbiHELDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Aug 2022 07:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240414AbiHELDt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Aug 2022 07:03:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6085D1E3CC
        for <stable@vger.kernel.org>; Fri,  5 Aug 2022 04:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659697427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mJ3wb3wnNw2CiOGpWxs5L2Tr+je+/REmFMZ2ZlIWVD0=;
        b=MGrMMpaz0eSX0+RZ6LK+i07kQo8xM+2f0wZ9gojRIj/N5AwmKXx6ec02qm/JaDdq/sDTT2
        H3oc5vm/9/wDUB8PgSsGIS2Z/IxWR4YPc5Fmp9JgvDZdBXW2cQvyctWJMI1TyKIC8YK3W+
        5pCE6OZhUm+1bni9Y9Tye+7FNzoy6Is=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-299-s0xMztL9Mhql4sPg9FocmA-1; Fri, 05 Aug 2022 07:03:36 -0400
X-MC-Unique: s0xMztL9Mhql4sPg9FocmA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F65C382ECC7;
        Fri,  5 Aug 2022 11:03:36 +0000 (UTC)
Received: from t480s.fritz.box (unknown [10.39.194.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1DCC9404E4D6;
        Fri,  5 Aug 2022 11:03:33 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Peter Xu <peterx@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH v1 1/2] mm/hugetlb: fix hugetlb not supporting write-notify
Date:   Fri,  5 Aug 2022 13:03:28 +0200
Message-Id: <20220805110329.80540-2-david@redhat.com>
In-Reply-To: <20220805110329.80540-1-david@redhat.com>
References: <20220805110329.80540-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Staring at hugetlb_wp(), one might wonder where all the logic for shared
mappings is when stumbling over a write-protected page in a shared
mapping. In fact, there is none, and so far we thought we could get
away with that because e.g., mprotect() should always do the right thing
and map all pages directly writable.

Looks like we were wrong:

--------------------------------------------------------------------------
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <fcntl.h>
 #include <unistd.h>
 #include <errno.h>
 #include <sys/mman.h>

 #define HUGETLB_SIZE (2 * 1024 * 1024u)

 static void clear_softdirty(void)
 {
         int fd = open("/proc/self/clear_refs", O_WRONLY);
         const char *ctrl = "4";
         int ret;

         if (fd < 0) {
                 fprintf(stderr, "open(clear_refs) failed\n");
                 exit(1);
         }
         ret = write(fd, ctrl, strlen(ctrl));
         if (ret != strlen(ctrl)) {
                 fprintf(stderr, "write(clear_refs) failed\n");
                 exit(1);
         }
         close(fd);
 }

 int main(int argc, char **argv)
 {
         char *map;
         int fd;

         fd = open("/dev/hugepages/tmp", O_RDWR | O_CREAT);
         if (!fd) {
                 fprintf(stderr, "open() failed\n");
                 return -errno;
         }
         if (ftruncate(fd, HUGETLB_SIZE)) {
                 fprintf(stderr, "ftruncate() failed\n");
                 return -errno;
         }

         map = mmap(NULL, HUGETLB_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
         if (map == MAP_FAILED) {
                 fprintf(stderr, "mmap() failed\n");
                 return -errno;
         }

         *map = 0;

         if (mprotect(map, HUGETLB_SIZE, PROT_READ)) {
                 fprintf(stderr, "mmprotect() failed\n");
                 return -errno;
         }

         clear_softdirty();

         if (mprotect(map, HUGETLB_SIZE, PROT_READ|PROT_WRITE)) {
                 fprintf(stderr, "mmprotect() failed\n");
                 return -errno;
         }

         *map = 0;

         return 0;
 }
--------------------------------------------------------------------------

Above test fails with SIGBUS when there is only a single free hugetlb page.
 # echo 1 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
 # ./test
 Bus error (core dumped)

And worse, with sufficient free hugetlb pages it will map an anonymous page
into a shared mapping, for example, messing up accounting during unmap
and breaking MAP_SHARED semantics:
 # echo 2 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
 # ./test
 # cat /proc/meminfo | grep HugePages_
 HugePages_Total:       2
 HugePages_Free:        1
 HugePages_Rsvd:    18446744073709551615
 HugePages_Surp:        0

Reason in this particular case is that vma_wants_writenotify() will
return "true", removing VM_SHARED in vma_set_page_prot() to map pages
write-protected. Let's teach vma_wants_writenotify() that hugetlb does not
support write-notify, including softdirty tracking.

Fixes: 64e455079e1b ("mm: softdirty: enable write notifications on VMAs after VM_SOFTDIRTY cleared")
Cc: <stable@vger.kernel.org> # v3.18+
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/mmap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/mmap.c b/mm/mmap.c
index 61e6135c54ef..462a6b0344ac 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1683,6 +1683,13 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
 	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
 		return 0;
 
+	/*
+	 * Hugetlb does not require/support writenotify; especially, it does not
+	 * support softdirty tracking.
+	 */
+	if (is_vm_hugetlb_page(vma))
+		return 0;
+
 	/* The backer wishes to know when pages are first written to? */
 	if (vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite))
 		return 1;
-- 
2.35.3

