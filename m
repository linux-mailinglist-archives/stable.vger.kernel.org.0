Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74219395D39
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbhEaNnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:43:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232138AbhEaNlE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:41:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 090CB61412;
        Mon, 31 May 2021 13:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467672;
        bh=2uHQSuBtQrpPAeM3h7B7iaCFgz3x0WTe7FSIOTqt+Us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ytiuAipwHdMUgM6pw8nzWZFbnFadH0GsKcmt/dOTjeJ2jVE6+Uwp0W0epKU1IclJn
         /wct8E/slw7ns+n2xPUfK+bLTUmNQnfz36A+elPUqwo1BaA2MOkJAN/ELQp7mo1aVY
         pMbw8UehaARVvg6SWe+E7cve8GRE2FNT2mH6iq9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.14 35/79] NFS: fix an incorrect limit in filelayout_decode_layout()
Date:   Mon, 31 May 2021 15:14:20 +0200
Message-Id: <20210531130637.136064557@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.002722319@linuxfoundation.org>
References: <20210531130636.002722319@linuxfoundation.org>
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


