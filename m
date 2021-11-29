Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFE946254B
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbhK2Wht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:37:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232512AbhK2WhY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:37:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABD8C1404FC;
        Mon, 29 Nov 2021 10:30:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E6E48CE155A;
        Mon, 29 Nov 2021 18:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96EBBC53FC7;
        Mon, 29 Nov 2021 18:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210646;
        bh=e4QRCtKQKvUkeJFcBgWo6NspQFmnL1nwTYPiMfzq7VM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o0AV2aAHce7rsfdIGc/vwleIcRB46ccbUHTZoZA3TZIGVwM0cr8WdTdeSyNL37Fea
         btRaTvrv+SLjHsuuvhU9hktsDS1LVe+6fL52JAYT/Bw9p9iuvdSVZahyF2D5ES5+OL
         aQyMFmmYGxUqFSD/vb13mipTffuxKpK8k6kPdzUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/121] NFSv42: Dont fail clone() unless the OP_CLONE operation failed
Date:   Mon, 29 Nov 2021 19:18:05 +0100
Message-Id: <20211129181713.467784938@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit d3c45824ad65aebf765fcf51366d317a29538820 ]

The failure to retrieve post-op attributes has no bearing on whether or
not the clone operation itself was successful. We must therefore ignore
the return value of decode_getfattr() when looking at the success or
failure of nfs4_xdr_dec_clone().

Fixes: 36022770de6c ("nfs42: add CLONE xdr functions")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42xdr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nfs/nfs42xdr.c b/fs/nfs/nfs42xdr.c
index c078f88552695..f2248d9d4db51 100644
--- a/fs/nfs/nfs42xdr.c
+++ b/fs/nfs/nfs42xdr.c
@@ -1396,8 +1396,7 @@ static int nfs4_xdr_dec_clone(struct rpc_rqst *rqstp,
 	status = decode_clone(xdr);
 	if (status)
 		goto out;
-	status = decode_getfattr(xdr, res->dst_fattr, res->server);
-
+	decode_getfattr(xdr, res->dst_fattr, res->server);
 out:
 	res->rpc_status = status;
 	return status;
-- 
2.33.0



