Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5BE2FA982
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407666AbhARTBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:01:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:36204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390619AbhARLkZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:40:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36D9A22573;
        Mon, 18 Jan 2021 11:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969984;
        bh=gR6OTNwpqjjxbdrOEq1niqQNz+WgnqVd/AA8yuL6hUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1SzX9x30Ap9YjU/zeAcgUhoq458VCwZ27O6jpBP41sxkDs0/8lDqsQ5hHY8+rPRgh
         8zDfTTABiEAFjA3XmPjzskMNigD3n9WTxzanJWeOiXYBZzK14roWXqXClHVer3kOMy
         j6Ty+7NxpokUBO8ciqrm/rh1AWJ3Sbd5H/bswkfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.4 57/76] pNFS: Mark layout for return if return-on-close was not sent
Date:   Mon, 18 Jan 2021 12:34:57 +0100
Message-Id: <20210118113343.711374109@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
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
@@ -1524,12 +1524,18 @@ void pnfs_roc_release(struct nfs4_layout
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


