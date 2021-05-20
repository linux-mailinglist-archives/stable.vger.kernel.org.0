Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C76538A7A1
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbhETKlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:41:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237413AbhETKiF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:38:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A14D61C78;
        Thu, 20 May 2021 09:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504481;
        bh=mfU49GYTZqOw/I7JKuvZr88Pd7fKmif0/zfVAt6DikE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E+O4DOy0wIvynLraAetdkoKq/gbGdJ1FYFNGrRQsR2gY/2C4BRLs2W5SjFsHCVsZx
         Z2+OhSRscYEFL5vPRCqpdkk1M2nyqtBLPVA0EjJ8rfnLQt+B9kF21D4ap8nplVKwIj
         eUwVouv4EYWGpddJkp+WAnzhfBasb0csTCfv/p3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikola Livic <nlivic@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 265/323] pNFS/flexfiles: fix incorrect size check in decode_nfs_fh()
Date:   Thu, 20 May 2021 11:22:37 +0200
Message-Id: <20210520092129.302664881@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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
index 74f15498c9bf..9d99e19d98bd 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -101,7 +101,7 @@ static int decode_nfs_fh(struct xdr_stream *xdr, struct nfs_fh *fh)
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



