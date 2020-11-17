Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58792B5FDD
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgKQM72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 07:59:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:54226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728601AbgKQM5V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 07:57:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD87C24695;
        Tue, 17 Nov 2020 12:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605617840;
        bh=dPyFk8BTQ9ZWKFDCA6KL93rnYZxnoBEdm02hE+tuejY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TZYPSntkn8N67aOIadY8CfMrI7OFkMXC15ExU4YCJL2jSr66gAJOs8PPxhvQvG3Ir
         KpWPDlXNT3fIXPcsfzz8HSQ8LU3F26M19VTHiZrhDZ8+Xt2I7pQJVQWvAkq/KaZtag
         23FCyhvpTkrovO9pFb7u0yt2tfnVIYP7BVZ2GCIo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.9 18/21] gfs2: Fix case in which ail writes are done to jdata holes
Date:   Tue, 17 Nov 2020 07:56:49 -0500
Message-Id: <20201117125652.599614-18-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117125652.599614-1-sashal@kernel.org>
References: <20201117125652.599614-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit 4e79e3f08e576acd51dffb4520037188703238b3 ]

Patch b2a846dbef4e ("gfs2: Ignore journal log writes for jdata holes")
tried (unsuccessfully) to fix a case in which writes were done to jdata
blocks, the blocks are sent to the ail list, then a punch_hole or truncate
operation caused the blocks to be freed. In other words, the ail items
are for jdata holes. Before b2a846dbef4e, the jdata hole caused function
gfs2_block_map to return -EIO, which was eventually interpreted as an
IO error to the journal, and then withdraw.

This patch changes function gfs2_get_block_noalloc, which is only used
for jdata writes, so it returns -ENODATA rather than -EIO, and when
-ENODATA is returned to gfs2_ail1_start_one, the error is ignored.
We can safely ignore it because gfs2_ail1_start_one is only called
when the jdata pages have already been written and truncated, so the
ail1 content no longer applies.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/aops.c | 2 +-
 fs/gfs2/log.c  | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index d4af283fc8886..317a47d49442b 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -77,7 +77,7 @@ static int gfs2_get_block_noalloc(struct inode *inode, sector_t lblock,
 	if (error)
 		return error;
 	if (!buffer_mapped(bh_result))
-		return -EIO;
+		return -ENODATA;
 	return 0;
 }
 
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 93032feb51599..1ceeec0ffb16c 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -132,6 +132,8 @@ __acquires(&sdp->sd_ail_lock)
 		spin_unlock(&sdp->sd_ail_lock);
 		ret = generic_writepages(mapping, wbc);
 		spin_lock(&sdp->sd_ail_lock);
+		if (ret == -ENODATA) /* if a jdata write into a new hole */
+			ret = 0; /* ignore it */
 		if (ret || wbc->nr_to_write <= 0)
 			break;
 		return -EBUSY;
-- 
2.27.0

