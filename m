Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C40B34413B
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhCVMbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:31:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231280AbhCVMbQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:31:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E51DD60C3D;
        Mon, 22 Mar 2021 12:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416276;
        bh=YEsO1KwxtEsjByGqtI4KcOYOwT/lgtdJdpOEwcfhPCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hVicPMLPQqVPuCz1ptV4qK0xaqIKNZBIZTEcauWQoZIz5JdDc9Gt2lfkOsWtm3638
         ZIzKF8m5DO2qOrB2of+mkJT4xjrA6+tFDfAu0e4HJG6mRYBbSNPJpQtM8rZjBEh0Lo
         9VP6f8NovIO13IVk5VqiTVjXq3ZzgCm6R6reQx3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.11 046/120] nfsd: Dont keep looking up unhashed files in the nfsd file cache
Date:   Mon, 22 Mar 2021 13:27:09 +0100
Message-Id: <20210322121931.210218626@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit d30881f573e565ebb5dbb50b31ed6106b5c81328 upstream.

If a file is unhashed, then we're going to reject it anyway and retry,
so make sure we skip it when we're doing the RCU lockless lookup.
This avoids a number of unnecessary nfserr_jukebox returns from
nfsd_file_acquire()

Fixes: 65294c1f2c5e ("nfsd: add a new struct file caching facility to nfsd")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/filecache.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -898,6 +898,8 @@ nfsd_file_find_locked(struct inode *inod
 			continue;
 		if (!nfsd_match_cred(nf->nf_cred, current_cred()))
 			continue;
+		if (!test_bit(NFSD_FILE_HASHED, &nf->nf_flags))
+			continue;
 		if (nfsd_file_get(nf) != NULL)
 			return nf;
 	}


