Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C043D3833B7
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242103AbhEQPBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:01:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242534AbhEQO7r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:59:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22E9F619D0;
        Mon, 17 May 2021 14:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261589;
        bh=FwYVnjf8Xh5Sgm+huifcus/pm26Z0K+1Wl/+k7Imd44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CB1CBvUN4mcf1+hIE/f2s76MCvOZpJE78l6ec5+eEGGMZkfUofufFKwXoAzZ5abrZ
         6Q7llNtVXNFcW4f2usU3sKPhLZWAg5ydHfiMuS49iN/E6LknQRPHvRuTHdraWuncnv
         p4lHlIu0qgjdCX1aJDByxN/fN57J6kFAnJ+yOKRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nagendra S Tomar <natomar@microsoft.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 132/329] nfs: Subsequent READDIR calls should carry non-zero cookieverifier
Date:   Mon, 17 May 2021 16:00:43 +0200
Message-Id: <20210517140306.581927150@linuxfoundation.org>
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

From: Nagendra S Tomar <natomar@microsoft.com>

[ Upstream commit ee3707ae2c1f1327ad5188836b7ab62ed2c93b28 ]

If the loop in nfs_readdir_xdr_to_array() runs more than once, subsequent
READDIR RPCs may wrongly carry a zero cookie verifier and non-zero cookie.
Make sure subsequent calls to READDIR carry the cookie verifier returned
by the first call.

Signed-off-by: Nagendra S Tomar <natomar@microsoft.com>
Fixes: b593c09f83a2 ("NFS: Improve handling of directory verifiers")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 4db3018776f6..c3618b6abfc0 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -865,6 +865,8 @@ static int nfs_readdir_xdr_to_array(struct nfs_readdir_descriptor *desc,
 			break;
 		}
 
+		verf_arg = verf_res;
+
 		status = nfs_readdir_page_filler(desc, entry, pages, pglen,
 						 arrays, narrays);
 	} while (!status && nfs_readdir_page_needs_filling(page));
-- 
2.30.2



