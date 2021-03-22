Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3540D34420C
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhCVMiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:38:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231626AbhCVMg5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:36:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CADF619A6;
        Mon, 22 Mar 2021 12:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416586;
        bh=4OicLWHw75keUaihh6fGQqkS59D1DgzrKVDkdcazLPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uGGDwqhePAUkg+A7/3gkQApx6FSlJxG5n++kWb3Eem2GaA8tqgGcv4GFCqMnFLvSG
         jeUTRFuT9DMqbzr1wv7uYKCSL9/s8LrtERuQOeoV0/NP6yvDIBNr2MEYyoGf4rInC1
         4L/KWvLokKbo1DHAZ7G5aH0k25dgHXRSNMx6OsuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Dai Ngo <dai.ngo@oracle.com>
Subject: [PATCH 5.10 044/157] NFSD: fix dest to src mount in inter-server COPY
Date:   Mon, 22 Mar 2021 13:26:41 +0100
Message-Id: <20210322121935.146886657@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
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
@@ -1299,7 +1299,7 @@ nfsd4_cleanup_inter_ssc(struct vfsmount
 			struct nfsd_file *dst)
 {
 	nfs42_ssc_close(src->nf_file);
-	/* 'src' is freed by nfsd4_do_async_copy */
+	fput(src->nf_file);
 	nfsd_file_put(dst);
 	mntput(ss_mnt);
 }


