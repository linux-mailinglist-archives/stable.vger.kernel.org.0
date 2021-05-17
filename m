Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681A53835F4
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243974AbhEQP0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:26:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245094AbhEQPYg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:24:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA07261CA0;
        Mon, 17 May 2021 14:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262149;
        bh=u6enwhgOyuBoYcq5IHLjeNJWidCdBOh+jHlbcUEv4S8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IycSSx91jUsyMfeyXq6aMDXYrJOjg/4HKYxgHKmFUTHNue4RZ0ip53+kFiERwJq1m
         skZRT7ajjCjdz1soFICYFy7dVBLtboehUMBl6ULzdXI8akYwRyG3M/ksvsdzU0Xz5d
         e6EYotoBmvOSdxYZIOLyLSv1IO1qH9RDrGuiRkpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikola Livic <nlivic@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/289] pNFS/flexfiles: fix incorrect size check in decode_nfs_fh()
Date:   Mon, 17 May 2021 16:00:46 +0200
Message-Id: <20210517140309.232200773@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
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
index fd0eda328943..a8a02081942d 100644
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



