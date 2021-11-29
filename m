Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9463A462435
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbhK2WRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbhK2WQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:16:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06539C127121;
        Mon, 29 Nov 2021 10:22:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EAACB815D5;
        Mon, 29 Nov 2021 18:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA509C53FC7;
        Mon, 29 Nov 2021 18:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210105;
        bh=H9/V30PWjxASP3dUn6g4dasj1kdCMMIUnbwnIqY0oHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5HR+oRFPAj9kle1q+DDraxxJCWzHt/nOPGil81Zr/bqhEPBphGAAfFQPFleeHBfF
         Emt31p59fiBU1A7/EOGt88pVN69p3ZWzx5DM+c9VgpFoXoNm3hT6JcicwZ5hTMIJTz
         3uL3Fit6sXSXC1OS5XKEyumKTV0J9/908S/5LQ68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 44/69] NFSv42: Dont fail clone() unless the OP_CLONE operation failed
Date:   Mon, 29 Nov 2021 19:18:26 +0100
Message-Id: <20211129181705.101770891@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
References: <20211129181703.670197996@linuxfoundation.org>
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
index ec9803088f6b8..eee011de3f58b 100644
--- a/fs/nfs/nfs42xdr.c
+++ b/fs/nfs/nfs42xdr.c
@@ -707,8 +707,7 @@ static int nfs4_xdr_dec_clone(struct rpc_rqst *rqstp,
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



