Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA40F461F1A
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379021AbhK2Snx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:43:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46414 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379587AbhK2SlW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:41:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E448AB815C5;
        Mon, 29 Nov 2021 18:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D463C53FAD;
        Mon, 29 Nov 2021 18:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211082;
        bh=0R+iaKig4HXSQLBwXrW7/soZA6vCGUMk9z+SwFYY37w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LirWoXZVKLp3S2eGBDlCxuvQtuYypNKvQH+H6s5jajrcP02+WSiATFUSolqy1pXhK
         e/rhIux058w90PC/JGHMqPx6Utg2y8IzGbb4G9Xe9465340jpmlUKx/H+PaAaBcUFz
         5nYTvE9IBG95+QlTAt/8au1sZNN3KGl0kAcyaehw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.15 056/179] iomap: Fix inline extent handling in iomap_readpage
Date:   Mon, 29 Nov 2021 19:17:30 +0100
Message-Id: <20211129181720.813608185@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit d8af404ffce71448f29bbc19a05e3d095baf98eb upstream.

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/iomap/buffered-io.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -256,8 +256,13 @@ static loff_t iomap_readpage_iter(const
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
@@ -370,6 +375,8 @@ static loff_t iomap_readahead_iter(const
 			ctx->cur_page_in_bio = false;
 		}
 		ret = iomap_readpage_iter(iter, ctx, done);
+		if (ret <= 0)
+			return ret;
 	}
 
 	return done;


