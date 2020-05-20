Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC821DB63D
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgETOXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:23:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33356 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726805AbgETOW3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:29 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPby-00036p-Ei; Wed, 20 May 2020 15:22:22 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbx-007DVy-Gi; Wed, 20 May 2020 15:22:21 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jens Axboe" <axboe@kernel.dk>,
        "Jerome Glisse" <jglisse@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        "John Hubbard" <jhubbard@nvidia.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Jan Kara" <jack@suse.cz>,
        "Dan Williams" <dan.j.williams@intel.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        "Hans Verkuil" <hverkuil-cisco@xs4all.nl>,
        "Christoph Hellwig" <hch@lst.de>,
        "Leon Romanovsky" <leonro@mellanox.com>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Jason Gunthorpe" <jgg@mellanox.com>,
        "=?UTF-8?Q?Bj=C3=B6rn=20?= =?UTF-8?Q?T=C3=B6pel?=" 
        <bjorn.topel@intel.com>, "Ira Weiny" <ira.weiny@intel.com>,
        "Mike Rapoport" <rppt@linux.ibm.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Date:   Wed, 20 May 2020 15:14:56 +0100
Message-ID: <lsq.1589984009.929198316@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 88/99] media/v4l2-core: set pages dirty upon
 releasing DMA buffers
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: John Hubbard <jhubbard@nvidia.com>

commit 3c7470b6f68434acae459482ab920d1e3fabd1c7 upstream.

After DMA is complete, and the device and CPU caches are synchronized,
it's still required to mark the CPU pages as dirty, if the data was
coming from the device.  However, this driver was just issuing a bare
put_page() call, without any set_page_dirty*() call.

Fix the problem, by calling set_page_dirty_lock() if the CPU pages were
potentially receiving data from the device.

Link: http://lkml.kernel.org/r/20200107224558.2362728-11-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Björn Töpel <bjorn.topel@intel.com>
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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/v4l2-core/videobuf-dma-sg.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/media/v4l2-core/videobuf-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -316,8 +316,11 @@ int videobuf_dma_free(struct videobuf_dm
 	BUG_ON(dma->sglen);
 
 	if (dma->pages) {
-		for (i = 0; i < dma->nr_pages; i++)
+		for (i = 0; i < dma->nr_pages; i++) {
+			if (dma->direction == DMA_FROM_DEVICE)
+				set_page_dirty_lock(dma->pages[i]);
 			page_cache_release(dma->pages[i]);
+		}
 		kfree(dma->pages);
 		dma->pages = NULL;
 	}

