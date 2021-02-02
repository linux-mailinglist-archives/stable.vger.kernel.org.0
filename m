Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE00630C049
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbhBBNxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:53:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:41022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232640AbhBBNvo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:51:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6536064FBD;
        Tue,  2 Feb 2021 13:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273410;
        bh=onaZ8XFYYkEufPgP5rHs26W5zhQS+nX8oYg1XWr25TE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cIm7eIDQHPpoLlI7tcz/5/jwuiKc5CvmBDnRUIRx1C3hg+tpr99L6mFn/5jDz/8Fn
         xfx/brzO/9aECSKMX5fO9H9fqZeVHrl9TQ3pMXSTpl5LddZ/M8nAdlXPuivgO00Nq5
         kNfmqAg6OO7Y8Z13mNGBCKT8pvCZOD4WqzkLrgbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/142] pNFS/NFSv4: Fix a layout segment leak in pnfs_layout_process()
Date:   Tue,  2 Feb 2021 14:37:39 +0100
Message-Id: <20210202133001.674846954@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
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
index 471bfa273dade..426877f72441e 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2418,6 +2418,7 @@ out_forget:
 	spin_unlock(&ino->i_lock);
 	lseg->pls_layout = lo;
 	NFS_SERVER(ino)->pnfs_curr_ld->free_lseg(lseg);
+	pnfs_free_lseg_list(&free_me);
 	return ERR_PTR(-EAGAIN);
 }
 
-- 
2.27.0



