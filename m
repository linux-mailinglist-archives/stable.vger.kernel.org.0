Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD70530C489
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 16:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235869AbhBBPyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 10:54:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:39436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhBBPMZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 10:12:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95F8B64F89;
        Tue,  2 Feb 2021 15:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278419;
        bh=CNutUJLVZeWVeQ6N54+/9JrTYSbl7T40hQXRsJiEKd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=adHu5DUbuqzwbmfrp/rk1ub25W8HXjYkuyPWzT01rjNSqXh2SQHkls/k8Nty2YBOW
         K4ZTAUcLco9RdjuE+N89cOycpCju3fSyTLri0/73rpllfAUUl8cR8CCasoe7IixCfK
         AF7ctqCzqx6E3but3yBj+rGXEMLY15ZcJUNY6DMXdFY6XM1zYEuyGw4dVe17QGW8QV
         UIuMfc9NVlSfPxCeNZtWFJF0hqbus0fKyhZcQG0pveOQVb2DftDmGLdfZ7yIr8mLXN
         n5t7QZv6oTI9BIQp6iYq9RtCkNcduGx2Q6ARdUgXvB8dzdORvxhkKYRj/6awNkkfsd
         laos/UHBh0Rdg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/17] pNFS/NFSv4: Try to return invalid layout in pnfs_layout_process()
Date:   Tue,  2 Feb 2021 10:06:40 -0500
Message-Id: <20210202150651.1864426-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150651.1864426-1-sashal@kernel.org>
References: <20210202150651.1864426-1-sashal@kernel.org>
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
index 4232f956bdac0..412ccb4f3bc14 100644
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

