Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E71F1BCBB8
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 21:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgD1S1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:27:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728909AbgD1S1O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:27:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA66020B1F;
        Tue, 28 Apr 2020 18:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098434;
        bh=eKkMLoWmmxBEA0EEWrqjo0000MnuLIWuCTCdkeZCa5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aKqnhTmKkwG/qo1chhed66osAceB8M+TWHsbdWlQDUFJ7K+w5ixJgC07qW5nMNCfp
         /aOTkzQYcwRNzu63q1qndN/b0Re8/IHmWZ8O2/2MkrnISJD+C/Q/0uQHQyCgro6a9b
         9/o7gDHa90nVcajnqYAZYb/b0GokuaoSXEXrD+SI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 005/167] xfs: correctly acount for reclaimable slabs
Date:   Tue, 28 Apr 2020 20:23:01 +0200
Message-Id: <20200428182225.994108964@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit d59eadaea2b9945095d4d6d44367ebabd604395c ]

The XFS inode item slab actually reclaimed by inode shrinker
callbacks from the memory reclaim subsystem. These should be marked
as reclaimable so the mm subsystem has the full picture of how much
memory it can actually reclaim from the XFS slab caches.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 2094386af8aca..68fea439d9743 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1861,7 +1861,8 @@ xfs_init_zones(void)
 
 	xfs_ili_zone = kmem_cache_create("xfs_ili",
 					 sizeof(struct xfs_inode_log_item), 0,
-					 SLAB_MEM_SPREAD, NULL);
+					 SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+					 NULL);
 	if (!xfs_ili_zone)
 		goto out_destroy_inode_zone;
 
-- 
2.20.1



