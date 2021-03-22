Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5C6344208
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbhCVMiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:38:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230509AbhCVMgq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:36:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B45660C3D;
        Mon, 22 Mar 2021 12:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416579;
        bh=DP7kCN/NRzLbeaIS4v4yb8mBnuwouqhxKVPx34LwnnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yFj7Y+w08La+j2iosPRY+/s02lwbqmkNJSqW4jffYR6CQfYA22UagBPVwp8OWFuxv
         uilvWc5+c0l6mVxxpvxUYfT6IYaAUrwuooxkt3ZstZOT8rFKRDIY3X2SZjpfhrg+u6
         Ec91yxcpZfily60Fp4EMJtyZjFe8X8F0ZJXWMYl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 041/157] nfsd: Dont keep looking up unhashed files in the nfsd file cache
Date:   Mon, 22 Mar 2021 13:26:38 +0100
Message-Id: <20210322121935.058644804@linuxfoundation.org>
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
@@ -897,6 +897,8 @@ nfsd_file_find_locked(struct inode *inod
 			continue;
 		if (!nfsd_match_cred(nf->nf_cred, current_cred()))
 			continue;
+		if (!test_bit(NFSD_FILE_HASHED, &nf->nf_flags))
+			continue;
 		if (nfsd_file_get(nf) != NULL)
 			return nf;
 	}


