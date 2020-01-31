Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2F2E14E8A8
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 07:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgAaGMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 01:12:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:60258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbgAaGMx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jan 2020 01:12:53 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FD33214D8;
        Fri, 31 Jan 2020 06:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580451172;
        bh=WIY7V7L5gqqMK/BeKpCdFsRN/WRQshodkTF3WA6WadE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kBMXjjn1Qw56Xoy48uQ+iOMKV0ldHyfHyII0sQcMGKYIKwff+js5kktlN0KpcvTxI
         OJaQvtZb+QLUT0CzULXq+abghsBD7OR1yc/u4BgmFr/ndDUlshIBp3kp7t8yc5f+Ml
         TCtq8Js+h8jjBuHKjcwZf+wn5Nyxm9N/Tk8ymMO8=
Date:   Thu, 30 Jan 2020 22:12:50 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.williamson@redhat.com,
        aneesh.kumar@linux.ibm.com, axboe@kernel.dk, bjorn.topel@intel.com,
        corbet@lwn.net, dan.j.williams@intel.com, daniel.vetter@ffwll.ch,
        hch@lst.de, hverkuil-cisco@xs4all.nl, ira.weiny@intel.com,
        jack@suse.cz, jgg@mellanox.com, jgg@ziepe.ca, jglisse@redhat.com,
        jhubbard@nvidia.com, kirill@shutemov.name, leonro@mellanox.com,
        linux-mm@kvack.org, mchehab@kernel.org, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 033/118] media/v4l2-core: set pages dirty upon
 releasing DMA buffers
Message-ID: <20200131061250.z37jD6vNq%akpm@linux-foundation.org>
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: media/v4l2-core: set pages dirty upon releasing DMA buffers

After DMA is complete, and the device and CPU caches are synchronized,
it's still required to mark the CPU pages as dirty, if the data was coming
from the device.  However, this driver was just issuing a bare put_page()
call, without any set_page_dirty*() call.

Fix the problem, by calling set_page_dirty_lock() if the CPU pages were
potentially receiving data from the device.

Link: http://lkml.kernel.org/r/20200107224558.2362728-11-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: <stable@vger.kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Leon Romanovsky <leonro@mellanox.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
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
