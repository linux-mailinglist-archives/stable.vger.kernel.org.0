Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A26FB10FE11
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 13:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfLCMup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 07:50:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25911 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726186AbfLCMup (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 07:50:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575377445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vUK+qbv4vcR++ilRAwdwA/Hrp9NPAPx99bcSEG1xv8w=;
        b=MqDtkLKXV5FWiVTfwBWsuyDRDAUbVCn+lFGbDRVEbCyUmVUamgzFtLg7FQqqy43k18enwo
        udmLBoWGKvvOVpsn3nBpYm9HhNnzxPSMZ9NuS1Mwx8Ug43/u+r3bDF6VehEy2jpIg02fxM
        E/uMDEAu0FT6WLNCNVdLil5nVfR1pEw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-twkIHNhdORWSSUH0wNu3iA-1; Tue, 03 Dec 2019 07:50:41 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AABB18C35A4;
        Tue,  3 Dec 2019 12:50:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D0F9A67E5D;
        Tue,  3 Dec 2019 12:50:39 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4498918089C8;
        Tue,  3 Dec 2019 12:50:39 +0000 (UTC)
Date:   Tue, 3 Dec 2019 07:50:39 -0500 (EST)
From:   Jan Stancek <jstancek@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, darrick.wong@oracle.com
Cc:     linuxppc-dev@lists.ozlabs.org,
        Memory Management <mm-qe@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>,
        Linux Stable maillist <stable@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Message-ID: <1766807082.14812757.1575377439007.JavaMail.zimbra@redhat.com>
In-Reply-To: <1420623640.14527843.1575289859701.JavaMail.zimbra@redhat.com>
References: <cki.6C6A189643.3T2ZUWEMOI@redhat.com> <1738119916.14437244.1575151003345.JavaMail.zimbra@redhat.com> <8736e3ffen.fsf@mpe.ellerman.id.au> <1420623640.14527843.1575289859701.JavaMail.zimbra@redhat.com>
Subject: [bug] userspace hitting sporadic SIGBUS on xfs (Power9, ppc64le),
 v4.19 and later
MIME-Version: 1.0
X-Originating-IP: [10.43.17.163, 10.4.195.10]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel
 5.3.13-3b5f971.cki (stable-queue)
Thread-Index: cteAZVs1buDEh+CFMxyFiJYhnT9cJLxMrbue
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: twkIHNhdORWSSUH0wNu3iA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

(This bug report is summary from thread [1] with some additions)

User-space binaries on Power9 ppc64le (with 64k pages) on xfs
filesystem are sporadically hitting SIGBUS:

---------- 8< ----------
(gdb) r
Starting program: /mnt/testarea/ltp/testcases/bin/genasin

Program received signal SIGBUS, Bus error.
dl_main (phdr=0x10000040, phnum=<optimized out>, user_entry=0x7fffffffe760, auxv=<optimized out>) at rtld.c:1362
1362        switch (ph->p_type)

(gdb) p ph
$1 = (const Elf64_Phdr *) 0x10000040

(gdb) p *ph
Cannot access memory at address 0x10000040

(gdb) info proc map
process 1110670
Mapped address spaces:

          Start Addr           End Addr       Size     Offset objfile
          0x10000000         0x10010000    0x10000        0x0 /mnt/testarea/ltp/testcases/bin/genasin
          0x10010000         0x10030000    0x20000        0x0 /mnt/testarea/ltp/testcases/bin/genasin
      0x7ffff7f90000     0x7ffff7fb0000    0x20000        0x0 [vdso]
      0x7ffff7fb0000     0x7ffff7fe0000    0x30000        0x0 /usr/lib64/ld-2.30.so
      0x7ffff7fe0000     0x7ffff8000000    0x20000    0x20000 /usr/lib64/ld-2.30.so
      0x7ffffffd0000     0x800000000000    0x30000        0x0 [stack]

(gdb) x/1x 0x10000040
0x10000040:     Cannot access memory at address 0x10000040
---------- >8 ----------

When this happens the binary continues to hit SIGBUS until page
is released, for example by: echo 3 > /proc/sys/vm/drop_caches

The issue goes back to at least v4.19.

I can semi-reliably reproduce it with LTP is installed to /mnt/testarea/ltp by:
while [ True ]; do
        echo 3 > /proc/sys/vm/drop_caches
        rm -f /mnt/testarea/ltp/results/RUNTEST.log /mnt/testarea/ltp/output/RUNTEST.run.log
        ./runltp -p -d results -l RUNTEST.log -o RUNTEST.run.log -f math
        grep FAIL /mnt/testarea/ltp/results/RUNTEST.log && exit 1
done

and some stress activity in other terminal (e.g. kernel build).
Sometimes in minutes, sometimes in hours. It is not reliable
enough to get meaningful bisect results.

My theory is that there's a race in iomap. There appear to be
interleaved calls to iomap_set_range_uptodate() for same page
with varying offset and length. Each call sees bitmap as _not_
entirely "uptodate" and hence doesn't call SetPageUptodate().
Even though each bit in bitmap ends up uptodate by the time
all calls finish.

For example, with following traces:

iomap_set_range_uptodate()
...
        if (uptodate && !PageError(page))
                SetPageUptodate(page);
+       
+       if (mycheck(page)) {
+               trace_printk("page: %px, iop: %px, uptodate: %d, !PageError(page): %d, flags: %lx\n", page, iop, uptodate, !PageError(page), page->flags);
+               trace_printk("first: %u, last: %u, off: %u, len: %u, i: %u\n", first, last, off, len, i);
+       }

I get:
         genacos-18471 [057] ....   162.465730: iomap_readpages: mapping: c000003f185a1ab0
         genacos-18471 [057] ....   162.465732: iomap_page_create: iomap_page_create page: c00c00000fe26180, page->private: 0000000000000000, iop: c000003fc70a19c0, flags: 3ffff800000001
         genacos-18471 [057] ....   162.465736: iomap_set_range_uptodate: page: c00c00000fe26180, iop: c000003fc70a19c0, uptodate: 0, !PageError(page): 1, flags: 3ffff800002001
         genacos-18471 [057] ....   162.465736: iomap_set_range_uptodate: first: 1, last: 14, off: 4096, len: 57344, i: 16
          <idle>-0     [060] ..s.   162.534862: iomap_set_range_uptodate: page: c00c00000fe26180, iop: c000003fc70a19c0, uptodate: 0, !PageError(page): 1, flags: 3ffff800002081
          <idle>-0     [061] ..s.   162.534862: iomap_set_range_uptodate: page: c00c00000fe26180, iop: c000003fc70a19c0, uptodate: 0, !PageError(page): 1, flags: 3ffff800002081
          <idle>-0     [060] ..s.   162.534864: iomap_set_range_uptodate: first: 0, last: 0, off: 0, len: 4096, i: 16
          <idle>-0     [061] ..s.   162.534864: iomap_set_range_uptodate: first: 15, last: 15, off: 61440, len: 4096, i: 16

This page doesn't have Uptodate flag set, which leads to filemap_fault()
returning VM_FAULT_SIGBUS:

crash> p/x ((struct page *) 0xc00c00000fe26180)->flags                                                                                                                                             
$1 = 0x3ffff800002032

crash> kmem -g 0x3ffff800002032
FLAGS: 3ffff800002032
  PAGE-FLAG       BIT  VALUE
  PG_error          1  0000002
  PG_dirty          4  0000010
  PG_lru            5  0000020
  PG_private_2     13  0002000
  PG_fscache       13  0002000
  PG_savepinned     4  0000010
  PG_double_map    13  0002000

But iomap_page->uptodate in page->private suggests all bits are uptodate:

crash> p/x ((struct page *) 0xc00c00000fe26180)->private
$2 = 0xc000003fc70a19c0

crash> p/x ((struct iomap_page *) 0xc000003fc70a19c0)->uptodate                                                                                                                                    
$3 = {0xffff, 0x0}


It appears (after ~4 hours) that I can avoid the problem if I split
the loop so that bits are checked only after all updates are made.
Not sure if this correct approach, or just making it less reproducible:

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index e25901ae3ff4..abe37031c93d 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -131,7 +131,11 @@ iomap_set_range_uptodate(struct page *page, unsigned off, unsigned len)
                for (i = 0; i < PAGE_SIZE / i_blocksize(inode); i++) {
                        if (i >= first && i <= last)
                                set_bit(i, iop->uptodate);
-                       else if (!test_bit(i, iop->uptodate))
+               }
+               for (i = 0; i < PAGE_SIZE / i_blocksize(inode); i++) {
+                       if (i >= first && i <= last)
+                               continue;
+                       if (!test_bit(i, iop->uptodate))
                                uptodate = false;
                }
        }

Thanks,
Jan

[1] https://lore.kernel.org/stable/1420623640.14527843.1575289859701.JavaMail.zimbra@redhat.com/T/#u

