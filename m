Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A238B461DF3
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379208AbhK2Sa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:30:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33610 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376866AbhK2S25 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:28:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6A76B815D5;
        Mon, 29 Nov 2021 18:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25198C53FAD;
        Mon, 29 Nov 2021 18:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210337;
        bh=CAE+nHsVee2Mqd0E5lhmAFQMmQfw11N4jZtn6G0bYQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0qMG/pImFW3IYUXhs9AHoGSb+2YbpScfSWvqKBBYWdGzJs5fbw1oZ40p3V2CEGEA
         YVC8u7P8khYd2t6OnCbd4ekoF1vrgAZQknJcCYxosVA4h1Ed7IuhAeE6G7yB/Poiax
         EjPl2unpP1Z7Z406+HKougc4EWJL8vdQ6LhaBp4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 53/92] NFSv42: Dont fail clone() unless the OP_CLONE operation failed
Date:   Mon, 29 Nov 2021 19:18:22 +0100
Message-Id: <20211129181709.190639611@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
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
index aed865a846296..2b78f7b8d5467 100644
--- a/fs/nfs/nfs42xdr.c
+++ b/fs/nfs/nfs42xdr.c
@@ -769,8 +769,7 @@ static int nfs4_xdr_dec_clone(struct rpc_rqst *rqstp,
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



