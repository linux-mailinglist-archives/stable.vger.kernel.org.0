Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CE22E4135
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439394AbgL1PDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:03:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:47222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439884AbgL1OMb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:12:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 689AE205CB;
        Mon, 28 Dec 2020 14:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164710;
        bh=VzmwSly9OGY6Tl/9K8gxHqG98NunnJFINc05TrFHU+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ajo1FsWHz6LBAGFXxh7RBIN20WpgYgIkRwv9/4wDXTq3gZgO2XP7riej0F0fitt9x
         zmuqfyAyoglL6dpBfs/MDuxa01ag7ciJ2QAOLcjuXlexlEizMNlk9NjW1OHd9ACA2i
         Z08hQrQ5KHyhGQ8QRYQLZ7ODTsiToEDKTo97wSpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fedor Tokarev <ftokarev@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 270/717] net: sunrpc: Fix snprintf return value check in do_xprt_debugfs
Date:   Mon, 28 Dec 2020 13:44:28 +0100
Message-Id: <20201228125033.950359662@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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



