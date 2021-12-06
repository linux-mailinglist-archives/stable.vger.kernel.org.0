Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114D3469A82
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347192AbhLFPIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:08:21 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56178 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346437AbhLFPG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:06:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E50876130D;
        Mon,  6 Dec 2021 15:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C870AC341C1;
        Mon,  6 Dec 2021 15:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802980;
        bh=mRHsj9aBL6OMO2joKiFcgr10RRRigkMrkExUYAI9jfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lT+xVCSz5vPbo6bcbQHDun78KPV6ibmHIGTcu0j1ZPE+bqP4eT3s8ttatr+Qagrt+
         t22f/R8XBOCT/ezqhRdNGwr4wljA4lnaNGPnUgCdLgK9zVjht0pf0LfSaJK4wraA2G
         4p9xBbK4HO/Eg9QX4MYTR/0UMXJXetvwPE2R9U0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 16/62] NFSv42: Dont fail clone() unless the OP_CLONE operation failed
Date:   Mon,  6 Dec 2021 15:55:59 +0100
Message-Id: <20211206145549.728361164@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145549.155163074@linuxfoundation.org>
References: <20211206145549.155163074@linuxfoundation.org>
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
index 8b2605882a201..335c34f0d1303 100644
--- a/fs/nfs/nfs42xdr.c
+++ b/fs/nfs/nfs42xdr.c
@@ -593,8 +593,7 @@ static int nfs4_xdr_dec_clone(struct rpc_rqst *rqstp,
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



