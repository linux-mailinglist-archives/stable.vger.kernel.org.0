Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485662E633C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404640AbgL1Pjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:39:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:49836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405963AbgL1Nsr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:48:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78488206D4;
        Mon, 28 Dec 2020 13:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163312;
        bh=9zCcxbBZCihROBVI0RDvidq1dZsuhI1UZG8VfSxOiH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lRNZCZwxI3sF/+A/K/3hfy/u9rxMW5jhTF6hFFSJjy3jgHJBa9owsMFnksLoXCwUd
         tGnqsta9VYXZAtcNwIMneIeQ8EsyVJqnRe/UPuDBzKlFXD5qENX6iSS6fD0XiSKpSg
         8U6qw2qOsz8G6FEM35eBXQke0276/zyQOw6lS3GE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 202/453] NFSv4: Fix the alignment of page data in the getdeviceinfo reply
Date:   Mon, 28 Dec 2020 13:47:18 +0100
Message-Id: <20201228124946.933598986@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 046e5ccb4198b990190e11fb52fd9cfd264402eb ]

We can fit the device_addr4 opaque data padding in the pages.

Fixes: cf500bac8fd4 ("SUNRPC: Introduce rpc_prepare_reply_pages()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4xdr.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 677751bc3a334..9a022a4fb9643 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -3012,15 +3012,19 @@ static void nfs4_xdr_enc_getdeviceinfo(struct rpc_rqst *req,
 	struct compound_hdr hdr = {
 		.minorversion = nfs4_xdr_minorversion(&args->seq_args),
 	};
+	uint32_t replen;
 
 	encode_compound_hdr(xdr, req, &hdr);
 	encode_sequence(xdr, &args->seq_args, &hdr);
+
+	replen = hdr.replen + op_decode_hdr_maxsz;
+
 	encode_getdeviceinfo(xdr, args, &hdr);
 
-	/* set up reply kvec. Subtract notification bitmap max size (2)
-	 * so that notification bitmap is put in xdr_buf tail */
+	/* set up reply kvec. device_addr4 opaque data is read into the
+	 * pages */
 	rpc_prepare_reply_pages(req, args->pdev->pages, args->pdev->pgbase,
-				args->pdev->pglen, hdr.replen - 2);
+				args->pdev->pglen, replen + 2 + 1);
 	encode_nops(&hdr);
 }
 
-- 
2.27.0



