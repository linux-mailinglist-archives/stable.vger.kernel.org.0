Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54063CE5A9
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245105AbhGSPwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:52:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344015AbhGSPqa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:46:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 392BC6124C;
        Mon, 19 Jul 2021 16:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712024;
        bh=WfFWXTXhuEAzDW6RksKJVzKJUYVvGv5V+i8H6XDgzvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qbdRO1nDsYBpn5ei5gREJynA1aJYzr2/O4dXri5QHnoeem5W2R83jALnPLrxBMdEY
         wwHeXe5bdCeUMoMlA/NBQ1b/gj0rrLHB7cikJeHkviUw0aAAlKyNFMgvhLIYjN8+iX
         fg9bmniP2Ni/jBGoS581YEi+nnLiM/P/OmBXP6C4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 220/292] NFSv4/pnfs: Fix layoutget behaviour after invalidation
Date:   Mon, 19 Jul 2021 16:54:42 +0200
Message-Id: <20210719144950.214875616@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 0b77f97a7e42adc72bd566ff8cb733ea426f74f6 ]

If the layout gets invalidated, we should wait for any outstanding
layoutget requests for that layout to complete, and we should resend
them only after re-establishing the layout stateid.

Fixes: d29b468da4f9 ("pNFS/NFSv4: Improve rejection of out-of-order layouts")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index cd041ba6f0aa..2da35a31508c 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2014,7 +2014,7 @@ lookup_again:
 	 * If the layout segment list is empty, but there are outstanding
 	 * layoutget calls, then they might be subject to a layoutrecall.
 	 */
-	if (list_empty(&lo->plh_segs) &&
+	if ((list_empty(&lo->plh_segs) || !pnfs_layout_is_valid(lo)) &&
 	    atomic_read(&lo->plh_outstanding) != 0) {
 		spin_unlock(&ino->i_lock);
 		lseg = ERR_PTR(wait_var_event_killable(&lo->plh_outstanding,
@@ -2390,11 +2390,13 @@ pnfs_layout_process(struct nfs4_layoutget *lgp)
 		goto out_forget;
 	}
 
+	if (!pnfs_layout_is_valid(lo) && !pnfs_is_first_layoutget(lo))
+		goto out_forget;
+
 	if (nfs4_stateid_match_other(&lo->plh_stateid, &res->stateid)) {
 		/* existing state ID, make sure the sequence number matches. */
 		if (pnfs_layout_stateid_blocked(lo, &res->stateid)) {
-			if (!pnfs_layout_is_valid(lo) &&
-			    pnfs_is_first_layoutget(lo))
+			if (!pnfs_layout_is_valid(lo))
 				lo->plh_barrier = 0;
 			dprintk("%s forget reply due to sequence\n", __func__);
 			goto out_forget;
@@ -2415,8 +2417,6 @@ pnfs_layout_process(struct nfs4_layoutget *lgp)
 		goto out_forget;
 	} else {
 		/* We have a completely new layout */
-		if (!pnfs_is_first_layoutget(lo))
-			goto out_forget;
 		pnfs_set_layout_stateid(lo, &res->stateid, lgp->cred, true);
 	}
 
-- 
2.30.2



