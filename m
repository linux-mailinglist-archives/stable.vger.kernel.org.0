Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A234C3961A2
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhEaOoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:44:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233594AbhEaOlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:41:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47A3B61879;
        Mon, 31 May 2021 13:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469214;
        bh=7aU17wpJD5FM3EuHAtTb3q/DPaJl6R++Mh/lZDtvag0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ks9MdWUBUuFjNu+AvjVB9n5K1f0Og6hkNZFq91v2TcemzoVJ5nXxgLVT6mLQ/Ax/z
         jPRKrYM7u0yeJjZK7tH2R4uUN+wrqtZXn2i94IWa/b2LODxQqRIBctPeJ3NNDquw0B
         ltXaLJHOt0Zf4EmHEBtS9lJWArL86cWicnG+fvGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.12 113/296] NFS: fix an incorrect limit in filelayout_decode_layout()
Date:   Mon, 31 May 2021 15:12:48 +0200
Message-Id: <20210531130707.728178623@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 769b01ea68b6c49dc3cde6adf7e53927dacbd3a8 upstream.

The "sizeof(struct nfs_fh)" is two bytes too large and could lead to
memory corruption.  It should be NFS_MAXFHSIZE because that's the size
of the ->data[] buffer.

I reversed the size of the arguments to put the variable on the left.

Fixes: 16b374ca439f ("NFSv4.1: pnfs: filelayout: add driver's LAYOUTGET and GETDEVICEINFO infrastructure")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/filelayout/filelayout.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/filelayout/filelayout.c
+++ b/fs/nfs/filelayout/filelayout.c
@@ -718,7 +718,7 @@ filelayout_decode_layout(struct pnfs_lay
 		if (unlikely(!p))
 			goto out_err;
 		fl->fh_array[i]->size = be32_to_cpup(p++);
-		if (sizeof(struct nfs_fh) < fl->fh_array[i]->size) {
+		if (fl->fh_array[i]->size > NFS_MAXFHSIZE) {
 			printk(KERN_ERR "NFS: Too big fh %d received %d\n",
 			       i, fl->fh_array[i]->size);
 			goto out_err;


