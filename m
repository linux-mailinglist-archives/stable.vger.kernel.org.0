Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1FE6382FDB
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235590AbhEQOVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:21:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239324AbhEQOTb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:19:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE84A613B9;
        Mon, 17 May 2021 14:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260660;
        bh=+vQ7GaDBS37A4+b6pqKMSGtMBefdnqmSi+qZP4C4x2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dYsNpKXH7yGhGcfAS89NlL+BmdfsHkCRG5X/P32uT1+q39H+WapfsYo7qPmagT6wc
         ++WkZsgNq9KfweT3/m0oJSNUomfcgGNyPn/NrpK82wrYyooRh30Y09a4Eoucau0ebu
         90g0Z7G8A8dOqt8tThIT7QieVVbKtgR7e1o0v/W0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 147/363] NFS: Only change the cookie verifier if the directory page cache is empty
Date:   Mon, 17 May 2021 16:00:13 +0200
Message-Id: <20210517140307.584151619@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
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
index 2cf2a7d92faf..0cd7c59a6601 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -929,7 +929,12 @@ static int find_and_lock_cache_page(struct nfs_readdir_descriptor *desc)
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



