Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 647C8117D0E
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 02:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfLJBQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 20:16:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:49192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726743AbfLJBQ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 20:16:57 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63969208C3;
        Tue, 10 Dec 2019 01:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575940616;
        bh=HzHHllQJuC8snN9xZMXrFfs4xjoHAoylV5TJAJ2ih8Y=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=d++/EeXYHvj0qa0K6drZjxkE3WFGyk33iMyyToVhr0YyiKxt2fCxtGnKHFeVLPSf3
         COaCkkhkLLvvnxLHThXPtHAg9qml/MWbCJvG7acyeqK3rDBxbf45/tBlxe/Hvi8Jw8
         4v32bTQrktnrhi9cbOXkMl0/zKIEvHEqDHlSU8iI=
Date:   Mon, 09 Dec 2019 17:16:53 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     airlied@linux.ie, alex.williamson@redhat.com,
        aneesh.kumar@linux.ibm.com, axboe@kernel.dk,
        benh@kernel.crashing.org, bjorn.topel@intel.com, corbet@lwn.net,
        dan.j.williams@intel.com, daniel.vetter@ffwll.ch, daniel@ffwll.ch,
        davem@davemloft.net, david@fromorbit.com, hch@lst.de,
        hverkuil-cisco@xs4all.nl, ira.weiny@intel.com, jack@suse.cz,
        jgg@mellanox.com, jgg@ziepe.ca, jglisse@redhat.com,
        jhubbard@nvidia.com, kirill.shutemov@linux.intel.com,
        leonro@mellanox.com, magnus.karlsson@intel.com, mchehab@kernel.org,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org,
        rppt@linux.ibm.com, shuah@kernel.org, stable@vger.kernel.org,
        vbabka@suse.cz, viro@zeniv.linux.org.uk
Subject:  +
 media-v4l2-core-set-pages-dirty-upon-releasing-dma-buffers.patch added to
 -mm tree
Message-ID: <20191210011653.DlmE2wgea%akpm@linux-foundation.org>
In-Reply-To: <20191206170123.cb3ad1f76af2b48505fabb33@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: media/v4l2-core: set pages dirty upon releasing DMA buffers
has been added to the -mm tree.  Its filename is
     media-v4l2-core-set-pages-dirty-upon-releasing-dma-buffers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/media-v4l2-core-set-pages-dirt=
y-upon-releasing-dma-buffers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/media-v4l2-core-set-pages-dirt=
y-upon-releasing-dma-buffers.patch

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
=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: media/v4l2-core: set pages dirty upon releasing DMA buffers

After DMA is complete, and the device and CPU caches are synchronized,
it's still required to mark the CPU pages as dirty, if the data was coming
from the device.  However, this driver was just issuing a bare put_page()
call, without any set_page_dirty*() call.

Fix the problem, by calling set_page_dirty_lock() if the CPU pages were
potentially receiving data from the device.

Link: http://lkml.kernel.org/r/20191209225344.99740-18-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: <stable@vger.kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Airlie <airlied@linux.ie>
Cc: "David S . Miller" <davem@davemloft.net>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Leon Romanovsky <leonro@mellanox.com>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/v4l2-core/videobuf-dma-sg.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/media/v4l2-core/videobuf-dma-sg.c~media-v4l2-core-set-pages-d=
irty-upon-releasing-dma-buffers
+++ a/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -349,8 +349,11 @@ int videobuf_dma_free(struct videobuf_dm
 	BUG_ON(dma->sglen);
=20
 	if (dma->pages) {
-		for (i =3D 0; i < dma->nr_pages; i++)
+		for (i =3D 0; i < dma->nr_pages; i++) {
+			if (dma->direction =3D=3D DMA_FROM_DEVICE)
+				set_page_dirty_lock(dma->pages[i]);
 			put_page(dma->pages[i]);
+		}
 		kfree(dma->pages);
 		dma->pages =3D NULL;
 	}
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-factor-out-duplicate-code-from-four-routines.patch
mm-gup-move-try_get_compound_head-to-top-fix-minor-issues.patch
mm-devmap-refactor-1-based-refcounting-for-zone_device-pages.patch
goldish_pipe-rename-local-pin_user_pages-routine.patch
mm-fix-get_user_pages_remotes-handling-of-foll_longterm.patch
vfio-fix-foll_longterm-use-simplify-get_user_pages_remote-call.patch
mm-gup-allow-foll_force-for-get_user_pages_fast.patch
ib-umem-use-get_user_pages_fast-to-pin-dma-pages.patch
mm-gup-introduce-pin_user_pages-and-foll_pin.patch
goldish_pipe-convert-to-pin_user_pages-and-put_user_page.patch
ib-corehwumem-set-foll_pin-via-pin_user_pages-fix-up-odp.patch
mm-process_vm_access-set-foll_pin-via-pin_user_pages_remote.patch
drm-via-set-foll_pin-via-pin_user_pages_fast.patch
fs-io_uring-set-foll_pin-via-pin_user_pages.patch
net-xdp-set-foll_pin-via-pin_user_pages.patch
media-v4l2-core-set-pages-dirty-upon-releasing-dma-buffers.patch
media-v4l2-core-pin_user_pages-foll_pin-and-put_user_page-conversion.patch
vfio-mm-pin_user_pages-foll_pin-and-put_user_page-conversion.patch
powerpc-book3s64-convert-to-pin_user_pages-and-put_user_page.patch
powerpc-book3s64-convert-to-pin_user_pages-and-put_user_page-fix.patch
mm-gup_benchmark-use-proper-foll_write-flags-instead-of-hard-coding-1.patch
mm-tree-wide-rename-put_user_page-to-unpin_user_page.patch
mm-gup-pass-flags-arg-to-__gup_device_-functions.patch
mm-gup-track-foll_pin-pages.patch
mm-gup_benchmark-support-pin_user_pages-and-related-calls.patch
selftests-vm-run_vmtests-invoke-gup_benchmark-with-basic-foll_pin-coverage.=
patch

