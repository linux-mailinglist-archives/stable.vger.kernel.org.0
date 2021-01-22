Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47ED6300CA7
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 20:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729286AbhAVSkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:40:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:38774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728482AbhAVOSo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:18:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D9BB23A3A;
        Fri, 22 Jan 2021 14:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324833;
        bh=cMK67UXJo16frcp2Q6y9ABDX5fnaHVkv7J9gR8WUZws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UjbtoLsDvX6tlpVeSfwAvseX/+6ux5aZNMKj7ikPZhmucBWTCQSHMAMdN7+ooUeDC
         ddJVOgdb8FFxgIWRCaTic/R3LxYEMx7IDdGZsvCQjhEGnniTLuW0PGB5Fdz29krumf
         dCJlIcAFB7r2xqZuQ9Cha8BN2ngRxTWKO7wApt8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.14 23/50] pNFS: Mark layout for return if return-on-close was not sent
Date:   Fri, 22 Jan 2021 15:12:04 +0100
Message-Id: <20210122135736.132114268@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.176469491@linuxfoundation.org>
References: <20210122135735.176469491@linuxfoundation.org>
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
@@ -1328,12 +1328,18 @@ void pnfs_roc_release(struct nfs4_layout
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


