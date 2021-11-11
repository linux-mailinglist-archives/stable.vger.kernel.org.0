Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D6744DA36
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 17:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234138AbhKKQUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 11:20:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31116 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233937AbhKKQUU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 11:20:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636647450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xujJ/bq+SC+rezsEo80o3fydJSWpSL4LfjFJ7txhcyk=;
        b=Ow5B4UqNLz4ZKTW++f61002AqEU9vsjY4mJC9E/RSSCToYfBzNNwG/ZMVCH6upmVffKXIc
        qawMUsVnxQSy+HVY028K8qwyYllHK43G4C0CRuTjs2R+6Bp40j6DlrR4TPziT3/SU9GuT/
        /MJkggHNJCmNDIFL0UupGCNFKIgPGQI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-A6_XSJcFNnupHv64UvLiwQ-1; Thu, 11 Nov 2021 11:17:25 -0500
X-MC-Unique: A6_XSJcFNnupHv64UvLiwQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4871F10151E1;
        Thu, 11 Nov 2021 16:17:24 +0000 (UTC)
Received: from max.localdomain (unknown [10.40.195.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D7D3960854;
        Thu, 11 Nov 2021 16:17:15 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com,
        Andreas Gruenbacher <agruenba@redhat.com>,
        stable@vger.kernel.org
Subject: [5.15 REGRESSION v2] iomap: Fix inline extent handling in iomap_readpage
Date:   Thu, 11 Nov 2021 17:17:14 +0100
Message-Id: <20211111161714.584718-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Before commit 740499c78408 ("iomap: fix the iomap_readpage_actor return
value for inline data"), when hitting an IOMAP_INLINE extent,
iomap_readpage_actor would report having read the entire page.  Since
then, it only reports having read the inline data (iomap->length).

This will force iomap_readpage into another iteration, and the
filesystem will report an unaligned hole after the IOMAP_INLINE extent.
But iomap_readpage_actor (now iomap_readpage_iter) isn't prepared to
deal with unaligned extents, it will get things wrong on filesystems
with a block size smaller than the page size, and we'll eventually run
into the following warning in iomap_iter_advance:

  WARN_ON_ONCE(iter->processed > iomap_length(iter));

Fix that by changing iomap_readpage_iter to return 0 when hitting an
inline extent; this will cause iomap_iter to stop immediately.

To fix readahead as well, change iomap_readahead_iter to pass on
iomap_readpage_iter return values less than or equal to zero.

Fixes: 740499c78408 ("iomap: fix the iomap_readpage_actor return value for inline data")
Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/iomap/buffered-io.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 1753c26c8e76..fe10d8a30f6b 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -256,8 +256,13 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
 	unsigned poff, plen;
 	sector_t sector;
 
-	if (iomap->type == IOMAP_INLINE)
-		return min(iomap_read_inline_data(iter, page), length);
+	if (iomap->type == IOMAP_INLINE) {
+		loff_t ret = iomap_read_inline_data(iter, page);
+
+		if (ret < 0)
+			return ret;
+		return 0;
+	}
 
 	/* zero post-eof blocks as the page may be mapped */
 	iop = iomap_page_create(iter->inode, page);
@@ -370,6 +375,8 @@ static loff_t iomap_readahead_iter(const struct iomap_iter *iter,
 			ctx->cur_page_in_bio = false;
 		}
 		ret = iomap_readpage_iter(iter, ctx, done);
+		if (ret <= 0)
+			return ret;
 	}
 
 	return done;
-- 
2.31.1

