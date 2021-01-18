Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16EA62F9F83
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 13:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390855AbhARM0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 07:26:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:37938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390753AbhARLps (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:45:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 801362222A;
        Mon, 18 Jan 2021 11:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970305;
        bh=G10ML0bLZOI/SsRxZEk0TDh7Nj3gmzAu7m08OfG19RU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u8+SKMlwMPiDGrISm78vHRnIGUWh8G1lRuqlcF2ZcyDDrVhSFq5b0s0lQ80TY2URj
         5ySIXnKkrzze2NzPtlPGc9JLpD8FGv+KwcK1suRiRJPSgx+6xbJsh0JsJGC4Mn81QS
         gY5t5BqAOg4k1ugEA+n4BKEP7ZW80rY5Mi3Zt7jk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.10 123/152] pNFS: Mark layout for return if return-on-close was not sent
Date:   Mon, 18 Jan 2021 12:34:58 +0100
Message-Id: <20210118113358.620798668@linuxfoundation.org>
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

commit 67bbceedc9bb8ad48993a8bd6486054756d711f4 upstream.

If the layout return-on-close failed because the layoutreturn was never
sent, then we should mark the layout for return again.

Fixes: 9c47b18cf722 ("pNFS: Ensure we do clear the return-on-close layout stateid on fatal errors")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/pnfs.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1558,12 +1558,18 @@ void pnfs_roc_release(struct nfs4_layout
 		int ret)
 {
 	struct pnfs_layout_hdr *lo = args->layout;
+	struct inode *inode = args->inode;
 	const nfs4_stateid *arg_stateid = NULL;
 	const nfs4_stateid *res_stateid = NULL;
 	struct nfs4_xdr_opaque_data *ld_private = args->ld_private;
 
 	switch (ret) {
 	case -NFS4ERR_NOMATCHING_LAYOUT:
+		spin_lock(&inode->i_lock);
+		if (pnfs_layout_is_valid(lo) &&
+		    nfs4_stateid_match_other(&args->stateid, &lo->plh_stateid))
+			pnfs_set_plh_return_info(lo, args->range.iomode, 0);
+		spin_unlock(&inode->i_lock);
 		break;
 	case 0:
 		if (res->lrs_present)


