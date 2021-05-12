Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528EE37C437
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234657AbhELP3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:29:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234428AbhELPZI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:25:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73A336196A;
        Wed, 12 May 2021 15:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832225;
        bh=5fzwrXYurcH64eVOzjuY+zgCL9/S4g0U+kP4QjKdqIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hilmr/o72l6AiismEFDcbUCdLTdSLr9R8YT/14n98/t9SV1z3A+kbld/CIMoJZ6J8
         qZ6MW0jZrUL3YJ/5L8UzlplWCu0g/bjYt7p1Ui7lgJ6oJKfHWSaVG+6ikJyDL3EGWt
         AUAvAZ0yGH6avyMtRZP3wTN+7R5OEN8kUu3q7J1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Dai Ngo <dai.ngo@oracle.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 193/530] NFSv4.2: fix copy stateid copying for the async copy
Date:   Wed, 12 May 2021 16:45:03 +0200
Message-Id: <20210512144826.183298536@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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
index 015d25a5cd03..00440337efc1 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1535,8 +1535,8 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
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



