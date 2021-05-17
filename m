Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E433834A8
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242355AbhEQPLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:11:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243017AbhEQPI6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:08:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5598D61C23;
        Mon, 17 May 2021 14:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261802;
        bh=1Ysj+Hxj23ymvQfvWfk3T8PrgjVs4FfUZeJurHBMO0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ckcq8RMR1AA3XOeEfC0epEFt7rHL/mHNOpi2TP+ImApVD1D1NXitHAVmUrMTO8kKM
         iv9FTp95S7PId7cY64Iz/6RXQG+47ImY/H/FClWye+E0jngPzdaYGD6WpQr4gT8MCd
         8xx3vk4gWzEMws/qZS57ey8M5yd6HQV1sXS0s/W4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikola Livic <nlivic@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 145/329] pNFS/flexfiles: fix incorrect size check in decode_nfs_fh()
Date:   Mon, 17 May 2021 16:00:56 +0200
Message-Id: <20210517140307.023056051@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikola Livic <nlivic@gmail.com>

[ Upstream commit ed34695e15aba74f45247f1ee2cf7e09d449f925 ]

We (adam zabrocki, alexander matrosov, alexander tereshkin, maksym
bazalii) observed the check:

	if (fh->size > sizeof(struct nfs_fh))

should not use the size of the nfs_fh struct which includes an extra two
bytes from the size field.

struct nfs_fh {
	unsigned short         size;
	unsigned char          data[NFS_MAXFHSIZE];
}

but should determine the size from data[NFS_MAXFHSIZE] so the memcpy
will not write 2 bytes beyond destination.  The proposed fix is to
compare against the NFS_MAXFHSIZE directly, as is done elsewhere in fs
code base.

Fixes: d67ae825a59d ("pnfs/flexfiles: Add the FlexFile Layout Driver")
Signed-off-by: Nikola Livic <nlivic@gmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index 872112bffcab..d383de00d486 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -106,7 +106,7 @@ static int decode_nfs_fh(struct xdr_stream *xdr, struct nfs_fh *fh)
 	if (unlikely(!p))
 		return -ENOBUFS;
 	fh->size = be32_to_cpup(p++);
-	if (fh->size > sizeof(struct nfs_fh)) {
+	if (fh->size > NFS_MAXFHSIZE) {
 		printk(KERN_ERR "NFS flexfiles: Too big fh received %d\n",
 		       fh->size);
 		return -EOVERFLOW;
-- 
2.30.2



