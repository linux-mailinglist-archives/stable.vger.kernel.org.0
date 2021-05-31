Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2489D396019
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbhEaOWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:22:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233434AbhEaOR7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:17:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12CC1619B4;
        Mon, 31 May 2021 13:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468636;
        bh=2uHQSuBtQrpPAeM3h7B7iaCFgz3x0WTe7FSIOTqt+Us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZGzlEfKSDnJGSCNkzJqwBAYjDNM7ioXPX+JhPGetoGpmxl9vfcxtQXOfnJs1M8mW
         Mt7RdHGSd4L4pFFahky/797llzxP4oNvCEkrtqZZSeCdNH67WTg6Y1udjjUC4dYb05
         Tn4ywilMOhtt9G6vXuwhf7fyJT9OtA1kpnymWLTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.4 067/177] NFS: fix an incorrect limit in filelayout_decode_layout()
Date:   Mon, 31 May 2021 15:13:44 +0200
Message-Id: <20210531130650.217775067@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
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
@@ -717,7 +717,7 @@ filelayout_decode_layout(struct pnfs_lay
 		if (unlikely(!p))
 			goto out_err;
 		fl->fh_array[i]->size = be32_to_cpup(p++);
-		if (sizeof(struct nfs_fh) < fl->fh_array[i]->size) {
+		if (fl->fh_array[i]->size > NFS_MAXFHSIZE) {
 			printk(KERN_ERR "NFS: Too big fh %d received %d\n",
 			       i, fl->fh_array[i]->size);
 			goto out_err;


