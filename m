Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5467E2E4139
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733033AbgL1PEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:04:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:46286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439728AbgL1OMD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:12:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E77AC207B2;
        Mon, 28 Dec 2020 14:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164708;
        bh=c4uzeTj50vlQD7eHvOSJxiqzCvF4akCT+NmJ+f63u88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jgoelqScNYEDX1GE+GJWopDBVgFyLoDUft1YyGTmvkNsOznGkqxlkIIYsjTW9P6cn
         fcGg4K/G5jOvPvAGdezMpKyagr5YYZAPrAoFLs0Od3JSTgD1WkJ8/TtpSidWdP2RJR
         12b+bBam/D7OPfRLhh3Ich1BkUXoX7u8PVVHrB6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 269/717] NFSv4: Fix the alignment of page data in the getdeviceinfo reply
Date:   Mon, 28 Dec 2020 13:44:27 +0100
Message-Id: <20201228125033.901340432@linuxfoundation.org>
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
index c6dbfcae75171..c16b93df1bc14 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -3009,15 +3009,19 @@ static void nfs4_xdr_enc_getdeviceinfo(struct rpc_rqst *req,
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



