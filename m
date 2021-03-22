Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC87C34413F
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhCVMbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:31:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231340AbhCVMbZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:31:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F2CC61992;
        Mon, 22 Mar 2021 12:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416284;
        bh=6GFbRAZsPl//1pDmXBHQ+vZWCPBlRNlZ5dVRuKzJEZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lnuxnovv/ek5u9IuFKNuh/bTzGyEaP8KVWxZDz6zm0J4nRhzH+IywjvBFlypmnFtZ
         IqkBZVzKyjXg0CWyCwH1cwsG/K5fsIMZukfzKV11hFmnLGCv6xyQZvYowBn0NwrckB
         3KPqi5ie5To6f9bVRTv5Bq7BhWBaXMsDTIHw+aTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Dai Ngo <dai.ngo@oracle.com>
Subject: [PATCH 5.11 049/120] NFSD: fix dest to src mount in inter-server COPY
Date:   Mon, 22 Mar 2021 13:27:12 +0100
Message-Id: <20210322121931.314446867@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

commit 614c9750173e412663728215152cc6d12bcb3425 upstream.

A cleanup of the inter SSC copy needs to call fput() of the source
file handle to make sure that file structure is freed as well as
drop the reference on the superblock to unmount the source server.

Fixes: 36e1e5ba90fb ("NFSD: Fix use-after-free warning when doing inter-server copy")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Tested-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1304,7 +1304,7 @@ nfsd4_cleanup_inter_ssc(struct vfsmount
 			struct nfsd_file *dst)
 {
 	nfs42_ssc_close(src->nf_file);
-	/* 'src' is freed by nfsd4_do_async_copy */
+	fput(src->nf_file);
 	nfsd_file_put(dst);
 	mntput(ss_mnt);
 }


