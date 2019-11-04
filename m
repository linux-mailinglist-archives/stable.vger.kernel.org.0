Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 886E3EEF98
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388370AbfKDV43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:56:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:52000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388330AbfKDV4Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:56:25 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E76AC21D7D;
        Mon,  4 Nov 2019 21:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904584;
        bh=mmCyMoEi5q0DzQrl4wcc7xUC6DBbuTlcG7S2lUHES90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b1tRgM5nyIvusDweyr1BIB4/SpLSlVVlKx2+ul6jw6qe7P7FfKscC+oKTFv9j5Q71
         IAe2HViPZvVdpBA/zC/oELhO3iWvx03e+6UQG5cEGznmA/jsgsbh+IXxImShEYCeqA
         chVyXaFRdrg1h4FK818EvYSs9UufgH+E6XeZrbsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vratislav Bendel <vbendel@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Alex Lyakas <alex@zadara.com>
Subject: [PATCH 4.14 93/95] xfs: Correctly invert xfs_buftarg LRU isolation logic
Date:   Mon,  4 Nov 2019 22:45:31 +0100
Message-Id: <20191104212124.782825738@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
References: <20191104212038.056365853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vratislav Bendel <vbendel@redhat.com>

commit 19957a181608d25c8f4136652d0ea00b3738972d upstream.

Due to an inverted logic mistake in xfs_buftarg_isolate()
the xfs_buffers with zero b_lru_ref will take another trip
around LRU, while isolating buffers with non-zero b_lru_ref.

Additionally those isolated buffers end up right back on the LRU
once they are released, because b_lru_ref remains elevated.

Fix that circuitous route by leaving them on the LRU
as originally intended.

Signed-off-by: Vratislav Bendel <vbendel@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Alex Lyakas <alex@zadara.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/xfs_buf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1702,7 +1702,7 @@ xfs_buftarg_isolate(
 	 * zero. If the value is already zero, we need to reclaim the
 	 * buffer, otherwise it gets another trip through the LRU.
 	 */
-	if (!atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
+	if (atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
 		spin_unlock(&bp->b_lock);
 		return LRU_ROTATE;
 	}


