Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C4B2E63BA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405573AbgL1NrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:47:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:48084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405569AbgL1NrM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:47:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE4C32063A;
        Mon, 28 Dec 2020 13:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163217;
        bh=VzmwSly9OGY6Tl/9K8gxHqG98NunnJFINc05TrFHU+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ttm5sWFXybJubRYIN8kbju5IFhF2APQmffj2qynYHIKDo2T7XUTP52FUgVZNngwOI
         3U6qcTFn/ARjLOIUIbUGqRq7ienXUKnHJY4iMuH9nxe6pcjj2ePrT3VyHVV6w9+OWi
         tkGp1HSxkAM0XYw45TfQAUymG/L3tIPAJnTYX6NY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fedor Tokarev <ftokarev@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 203/453] net: sunrpc: Fix snprintf return value check in do_xprt_debugfs
Date:   Mon, 28 Dec 2020 13:47:19 +0100
Message-Id: <20201228124946.981405787@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fedor Tokarev <ftokarev@gmail.com>

[ Upstream commit 35a6d396721e28ba161595b0fc9e8896c00399bb ]

'snprintf' returns the number of characters which would have been written
if enough space had been available, excluding the terminating null byte.
Thus, the return value of 'sizeof(buf)' means that the last character
has been dropped.

Signed-off-by: Fedor Tokarev <ftokarev@gmail.com>
Fixes: 2f34b8bfae19 ("SUNRPC: add links for all client xprts to debugfs")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/debugfs.c b/net/sunrpc/debugfs.c
index fd9bca2427242..56029e3af6ff0 100644
--- a/net/sunrpc/debugfs.c
+++ b/net/sunrpc/debugfs.c
@@ -128,13 +128,13 @@ static int do_xprt_debugfs(struct rpc_clnt *clnt, struct rpc_xprt *xprt, void *n
 		return 0;
 	len = snprintf(name, sizeof(name), "../../rpc_xprt/%s",
 		       xprt->debugfs->d_name.name);
-	if (len > sizeof(name))
+	if (len >= sizeof(name))
 		return -1;
 	if (*nump == 0)
 		strcpy(link, "xprt");
 	else {
 		len = snprintf(link, sizeof(link), "xprt%d", *nump);
-		if (len > sizeof(link))
+		if (len >= sizeof(link))
 			return -1;
 	}
 	debugfs_create_symlink(link, clnt->cl_debugfs, name);
-- 
2.27.0



