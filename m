Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDE8318E6D
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhBKP0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:26:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230445AbhBKPWi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:22:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4972E64F3C;
        Thu, 11 Feb 2021 15:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613056051;
        bh=8E6WZmFizPDa+uxrj+vSD1bp5LLb1Q3wsf5WVP8fcQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JqSEDac7r9wXxGJlr4GoRQtkXs5ShZiLbEYIZtaSH/H/DhrMBXQ4pzVg9RmFM+K5n
         CBmgIARDI9HtoLJ6e6S1yhsdglrxspettfglUnnriiRs5pTCPam40axdqy6xO/Ql/a
         4ffq2brqP7wJaOsVtSBMsEFV3P3QOlIQsuGLFI1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/24] pNFS/NFSv4: Try to return invalid layout in pnfs_layout_process()
Date:   Thu, 11 Feb 2021 16:02:43 +0100
Message-Id: <20210211150148.170803970@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150147.743660073@linuxfoundation.org>
References: <20210211150147.743660073@linuxfoundation.org>
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
index 4b165aa5a2561..55965e8e9a2ed 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2301,7 +2301,13 @@ pnfs_layout_process(struct nfs4_layoutget *lgp)
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



