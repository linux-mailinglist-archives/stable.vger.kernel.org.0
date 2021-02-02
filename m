Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303B730C0AE
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbhBBOEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 09:04:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:47000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233698AbhBBOC1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:02:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0127E64F7F;
        Tue,  2 Feb 2021 13:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273653;
        bh=kAWN8Vbby6o/hGtE/MOGSrcJ0xN5ug0yOsvG4bbH1kQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3taY8L31IPxXkP7BuUohPWrOJ/rChvLHV0lfAaaGFSnyug4mmTEUfMnZJTeDL9sg
         aYJXwiot7O7YGnd44NJeFWIYcpvG1vqojlEuTZHhxAmGkghAnUYx+5p9AdBp4i+ZTf
         8/PBR4bu0j7lsAQPvFFzKlRHFfIbOLpqsx6xdMrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 42/61] pNFS/NFSv4: Fix a layout segment leak in pnfs_layout_process()
Date:   Tue,  2 Feb 2021 14:38:20 +0100
Message-Id: <20210202132948.244698892@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 814b84971388cd5fb182f2e914265b3827758455 ]

If the server returns a new stateid that does not match the one in our
cache, then pnfs_layout_process() will leak the layout segments returned
by pnfs_mark_layout_stateid_invalid().

Fixes: 9888d837f3cf ("pNFS: Force a retry of LAYOUTGET if the stateid doesn't match our cache")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 4232f956bdac0..ca1d98f274d12 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2388,6 +2388,7 @@ out_forget:
 	spin_unlock(&ino->i_lock);
 	lseg->pls_layout = lo;
 	NFS_SERVER(ino)->pnfs_curr_ld->free_lseg(lseg);
+	pnfs_free_lseg_list(&free_me);
 	return ERR_PTR(-EAGAIN);
 }
 
-- 
2.27.0



