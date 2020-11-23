Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D39E2C07C6
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733179AbgKWMoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:44:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733173AbgKWMoF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:44:05 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 881CD21534;
        Mon, 23 Nov 2020 12:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135445;
        bh=dPyFk8BTQ9ZWKFDCA6KL93rnYZxnoBEdm02hE+tuejY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eOe9/xSd9u5tLCqyu1k9cQsrDhG6oIM5IYlm7Z+kExMrwvKUMKlJTO6Lyh6Bv2Abb
         Oh6X5ZC/Vg13wf/Kk3egIbKRtEUknu8zwrUiYNxEpyitfLqhAHGxY55Pl1o/Dm8L1Q
         hG02vR0P5oiPMi1MIQDM/2s2C/yE1tqqWuL3ez/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 070/252] gfs2: Fix case in which ail writes are done to jdata holes
Date:   Mon, 23 Nov 2020 13:20:20 +0100
Message-Id: <20201123121838.968481468@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



