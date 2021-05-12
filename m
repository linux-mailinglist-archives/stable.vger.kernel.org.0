Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B22B37CC6B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238276AbhELQo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:44:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242841AbhELQf5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:35:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BA7B61E00;
        Wed, 12 May 2021 15:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835193;
        bh=fEWnPJ9ApPsOX/ykWbo98KwQdMW4MD5ysNU2fn6KiZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o61KxnHTOH7lQ5CyoefvSowpHTJXby/yMArk5OKEq3mO34eWKk5XB9/i8ZFbNn6lp
         Q+dMBUbpS1eI+UvWTF6w3735Clfv2aoSkE6Kg6785GP1sd0KSAWDVjbidjFyNQ+VJn
         q9o1nzuXJbqBYlhB2SIyRx7Zxy6Is1AxhirxCz2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Dai Ngo <dai.ngo@oracle.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 245/677] NFSv4.2: fix copy stateid copying for the async copy
Date:   Wed, 12 May 2021 16:44:51 +0200
Message-Id: <20210512144845.374536443@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit e739b12042b6b079a397a3c234f96c09d1de0b40 ]

This patch fixes Dan Carpenter's report that the static checker
found a problem where memcpy() was copying into too small of a buffer.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: e0639dc5805a ("NFSD introduce async copy feature")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index dd9f38d072dd..e13c4c81fb89 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1538,8 +1538,8 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		if (!nfs4_init_copy_state(nn, copy))
 			goto out_err;
 		refcount_set(&async_copy->refcount, 1);
-		memcpy(&copy->cp_res.cb_stateid, &copy->cp_stateid,
-			sizeof(copy->cp_stateid));
+		memcpy(&copy->cp_res.cb_stateid, &copy->cp_stateid.stid,
+			sizeof(copy->cp_res.cb_stateid));
 		dup_copy_fields(copy, async_copy);
 		async_copy->copy_task = kthread_create(nfsd4_do_async_copy,
 				async_copy, "%s", "copy thread");
-- 
2.30.2



