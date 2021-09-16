Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE1C40E5F1
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344123AbhIPRQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:16:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350351AbhIPRN4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:13:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6F0F61B5D;
        Thu, 16 Sep 2021 16:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810336;
        bh=nO4fqyB/6RvF5UPCubhhgOtrIynrJ98N1KVOwT5/MZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=genCACjUSFgm0CSW/9YcevPwexCqybQKfDWYiYsaQAsTWRvIlwtzq1e9fYBHvgLWg
         KQpVDjle89InXlA16d7+8Xg4Sm7XQtKbcogXzGEPmZkbdBadyKg0VyuDNG942rStxe
         QfaVR1rcm6VXSBLhvJ5vhJEOCe35bRCJ8dveX03Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 104/432] NFSv4/pNFS: Fix a layoutget livelock loop
Date:   Thu, 16 Sep 2021 17:57:33 +0200
Message-Id: <20210916155814.299415181@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit e20772cbdf463c12088837e5a08bde1b876bfd25 ]

If NFS_LAYOUT_RETURN_REQUESTED is set, but there is no value set for
the layout plh_return_seq, we can end up in a livelock loop in which
every layout segment retrieved by a new call to layoutget is immediately
invalidated by pnfs_layout_need_return().
To get around this, we should just set plh_return_seq to the current
value of the layout stateid's seqid.

Fixes: d474f96104bd ("NFS: Don't return layout segments that are in use")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index ef14ea0b6ab8..da5cacad6979 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -347,11 +347,15 @@ pnfs_set_plh_return_info(struct pnfs_layout_hdr *lo, enum pnfs_iomode iomode,
 		iomode = IOMODE_ANY;
 	lo->plh_return_iomode = iomode;
 	set_bit(NFS_LAYOUT_RETURN_REQUESTED, &lo->plh_flags);
-	if (seq != 0) {
-		WARN_ON_ONCE(lo->plh_return_seq != 0 && lo->plh_return_seq != seq);
+	/*
+	 * We must set lo->plh_return_seq to avoid livelocks with
+	 * pnfs_layout_need_return()
+	 */
+	if (seq == 0)
+		seq = be32_to_cpu(lo->plh_stateid.seqid);
+	if (!lo->plh_return_seq || pnfs_seqid_is_newer(seq, lo->plh_return_seq))
 		lo->plh_return_seq = seq;
-		pnfs_barrier_update(lo, seq);
-	}
+	pnfs_barrier_update(lo, seq);
 }
 
 static void
-- 
2.30.2



