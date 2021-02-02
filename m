Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318CF30C417
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 16:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235002AbhBBPlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 10:41:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:39460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235264AbhBBPOr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 10:14:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D8C964FA1;
        Tue,  2 Feb 2021 15:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278453;
        bh=myC20GzG4yb86AWQuQJ/5AAA5IHzhNSyKhrgFITgzg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bve5fbT/Eg2LSJFjOVXRcKCGjSn935TzFbHlA1Ry9fV7k5O0wm4OzFJJM1M6vur5r
         O7QtW/EskrCIijBXsLNSUaldkuA4ldUfNptDJa9AUDdDTL2cOlFM0HpahI8O3AEEWx
         PPXWdGrb7Bjx334MzR9hQNS2fXa4J5p4uMQe/lz0ZA1NeOwp7nNRG3dQdSRMPjcX9k
         o0Tt/EcfKuEhT/JDhH/EjOO7LJwsXHSVWguUqgJADVk+TpSkZhO4pLMujyhqqg5cyR
         j90RWydmW3ebHGE6mNcx/EH+H/UkkCy2qfq87rXlbI8NPT+I4Bt5E0pe+HIRDuF7Zb
         E6mOeFOAnUKJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 2/7] pNFS/NFSv4: Try to return invalid layout in pnfs_layout_process()
Date:   Tue,  2 Feb 2021 10:07:24 -0500
Message-Id: <20210202150730.1864745-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150730.1864745-1-sashal@kernel.org>
References: <20210202150730.1864745-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 08bd8dbe88825760e953759d7ec212903a026c75 ]

If the server returns a new stateid that does not match the one in our
cache, then try to return the one we hold instead of just invalidating
it on the client side. This ensures that both client and server will
agree that the stateid is invalid.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 8e2e3d3b7b253..0737f193fc532 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1973,7 +1973,13 @@ pnfs_layout_process(struct nfs4_layoutget *lgp)
 		 * We got an entirely new state ID.  Mark all segments for the
 		 * inode invalid, and retry the layoutget
 		 */
-		pnfs_mark_layout_stateid_invalid(lo, &free_me);
+		struct pnfs_layout_range range = {
+			.iomode = IOMODE_ANY,
+			.length = NFS4_MAX_UINT64,
+		};
+		pnfs_set_plh_return_info(lo, IOMODE_ANY, 0);
+		pnfs_mark_matching_lsegs_return(lo, &lo->plh_return_segs,
+						&range, 0);
 		goto out_forget;
 	}
 
-- 
2.27.0

