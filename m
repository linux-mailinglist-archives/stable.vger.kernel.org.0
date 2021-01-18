Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2060F2F9F85
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 13:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391040AbhARM0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 07:26:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:39146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390740AbhARLps (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:45:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D17A722D49;
        Mon, 18 Jan 2021 11:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970307;
        bh=1ERfOFqGT1dpnN5Kw49ETGYF8Fv7bFF4ub2QM9ntee8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pj8ppGb3rHCvdU2cOdbntE/7oQfwgyeAGQ2T8/aCNpofdun7KVeRkPbc+lXAN103E
         +lkd09RNuHI/yJQxSx0iHVCQv2NOLrTbkXDifRF3Cap76VddD3dgeLQT0ekmrWr2+U
         mk5Zuqdw1RpOMBv8WCO31IJPcans9dKZ7eYUyic8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.10 124/152] pNFS: Stricter ordering of layoutget and layoutreturn
Date:   Mon, 18 Jan 2021 12:34:59 +0100
Message-Id: <20210118113358.668200331@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 2c8d5fc37fe2384a9bdb6965443ab9224d46f704 upstream.

If a layout return is in progress, we should wait for it to complete,
in case the layout segment we are picking up gets returned too.

Fixes: 30cb3ee299cb ("pNFS: Handle NFS4ERR_OLD_STATEID on layoutreturn by bumping the state seqid")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/pnfs.c |   43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2019,6 +2019,27 @@ lookup_again:
 		goto lookup_again;
 	}
 
+	/*
+	 * Because we free lsegs when sending LAYOUTRETURN, we need to wait
+	 * for LAYOUTRETURN.
+	 */
+	if (test_bit(NFS_LAYOUT_RETURN, &lo->plh_flags)) {
+		spin_unlock(&ino->i_lock);
+		dprintk("%s wait for layoutreturn\n", __func__);
+		lseg = ERR_PTR(pnfs_prepare_to_retry_layoutget(lo));
+		if (!IS_ERR(lseg)) {
+			pnfs_put_layout_hdr(lo);
+			dprintk("%s retrying\n", __func__);
+			trace_pnfs_update_layout(ino, pos, count, iomode, lo,
+						 lseg,
+						 PNFS_UPDATE_LAYOUT_RETRY);
+			goto lookup_again;
+		}
+		trace_pnfs_update_layout(ino, pos, count, iomode, lo, lseg,
+					 PNFS_UPDATE_LAYOUT_RETURN);
+		goto out_put_layout_hdr;
+	}
+
 	lseg = pnfs_find_lseg(lo, &arg, strict_iomode);
 	if (lseg) {
 		trace_pnfs_update_layout(ino, pos, count, iomode, lo, lseg,
@@ -2071,28 +2092,6 @@ lookup_again:
 		nfs4_stateid_copy(&stateid, &lo->plh_stateid);
 	}
 
-	/*
-	 * Because we free lsegs before sending LAYOUTRETURN, we need to wait
-	 * for LAYOUTRETURN even if first is true.
-	 */
-	if (test_bit(NFS_LAYOUT_RETURN, &lo->plh_flags)) {
-		spin_unlock(&ino->i_lock);
-		dprintk("%s wait for layoutreturn\n", __func__);
-		lseg = ERR_PTR(pnfs_prepare_to_retry_layoutget(lo));
-		if (!IS_ERR(lseg)) {
-			if (first)
-				pnfs_clear_first_layoutget(lo);
-			pnfs_put_layout_hdr(lo);
-			dprintk("%s retrying\n", __func__);
-			trace_pnfs_update_layout(ino, pos, count, iomode, lo,
-					lseg, PNFS_UPDATE_LAYOUT_RETRY);
-			goto lookup_again;
-		}
-		trace_pnfs_update_layout(ino, pos, count, iomode, lo, lseg,
-				PNFS_UPDATE_LAYOUT_RETURN);
-		goto out_put_layout_hdr;
-	}
-
 	if (pnfs_layoutgets_blocked(lo)) {
 		trace_pnfs_update_layout(ino, pos, count, iomode, lo, lseg,
 				PNFS_UPDATE_LAYOUT_BLOCKED);


