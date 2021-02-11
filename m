Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A83318E48
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhBKPYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:24:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:52474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230231AbhBKPT5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:19:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08DFF6024A;
        Thu, 11 Feb 2021 15:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055978;
        bh=Yhi2Z1egjuosOWB1BmQ12EbaVaKb9Lt0pI+RIJIyiy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=orVd07yS5oqmvZund7EUQUcQM8t0o7rDn624ejb7SX3i7hEWyG2yFnh44BWDPaQod
         SZvoVxHvAIpvg9Sem0SVXLmOiOkXnNM83uEynp38iFLyhB6H/jJp7oudDZeEulrV2G
         UiSsFLMDDYlFU2i60Bq9TMrjvyRmFEaOUTLR8Dmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/24] pNFS/NFSv4: Try to return invalid layout in pnfs_layout_process()
Date:   Thu, 11 Feb 2021 16:02:30 +0100
Message-Id: <20210211150148.833411184@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150148.516371325@linuxfoundation.org>
References: <20210211150148.516371325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ca1d98f274d12..e3a79e6958124 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2369,7 +2369,13 @@ pnfs_layout_process(struct nfs4_layoutget *lgp)
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



