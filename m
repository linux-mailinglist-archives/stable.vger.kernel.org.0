Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79BAA3833C7
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242335AbhEQPCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:02:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242570AbhEQO74 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:59:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEEE6619B2;
        Mon, 17 May 2021 14:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261603;
        bh=gKcRR0TefNrZaYTv51gEWGoVyxEWytgSGwr3JzQzl/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pi1J79/Yq4YpS2zwQ6+aW+Mbx1+cT7te56Fgm5HmLjL8/HK1dM+fBiOEGzcO068IT
         IesF9HjpvAsorVMOsBKi+lrd62VUhE0AF8aZJ13NdkBCjt2w19lG4dcvtOUsYb6ao3
         43RYo1e0h+rifE6yFR+YX+N6Squu75XpJJfaDsxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 134/329] NFS: Only change the cookie verifier if the directory page cache is empty
Date:   Mon, 17 May 2021 16:00:45 +0200
Message-Id: <20210517140306.645842593@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit f892c41c14e0fa3d78ce37de1d5c8161ed13bf08 ]

The cached NFSv3/v4 readdir cookies are associated with a verifier,
which is checked by the server on subsequent calls to readdir, and is
only expected to change when the cookies (and hence also the page cache
contents) are considered invalid.
We therefore do have to store the verifier, but only when the page cache
is empty.

Fixes: b593c09f83a2 ("NFS: Improve handling of directory verifiers")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index ca1dddc81436..d5f28a1f3671 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -928,7 +928,12 @@ static int find_and_lock_cache_page(struct nfs_readdir_descriptor *desc)
 			}
 			return res;
 		}
-		memcpy(nfsi->cookieverf, verf, sizeof(nfsi->cookieverf));
+		/*
+		 * Set the cookie verifier if the page cache was empty
+		 */
+		if (desc->page_index == 0)
+			memcpy(nfsi->cookieverf, verf,
+			       sizeof(nfsi->cookieverf));
 	}
 	res = nfs_readdir_search_array(desc);
 	if (res == 0) {
-- 
2.30.2



