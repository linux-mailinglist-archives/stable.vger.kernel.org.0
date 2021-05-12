Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476ED37C4BE
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234565AbhELPdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:33:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234330AbhELPYu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:24:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0922E619B0;
        Wed, 12 May 2021 15:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832222;
        bh=GyM9gKbYClNFVOIMKTvnE/vOoFVKJe1bk5gJ1jYG2nY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QlahJ34fC8QJVcfy0AFwAqQmqkg2LhrUM89geAhjaHuU/p0fdKCGlnqzuU5E1xq/A
         1dUdAvQ8Hdy8pr7HbG8PzMzUDK4M6ZbdL5pr0pWXYPkt9BntaevOzUls9w6y6gtjom
         o5W0h6Ut01rhGmV8ZZwXN7ULZ9NitE+KZ/idhtHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 192/530] NFSD: Fix sparse warning in nfs4proc.c
Date:   Wed, 12 May 2021 16:45:02 +0200
Message-Id: <20210512144826.150808924@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit eb162e1772f85231dabc789fb4bfea63d2d9df79 ]

linux/fs/nfsd/nfs4proc.c:1542:24: warning: incorrect type in assignment (different base types)
linux/fs/nfsd/nfs4proc.c:1542:24:    expected restricted __be32 [assigned] [usertype] status
linux/fs/nfsd/nfs4proc.c:1542:24:    got int

Clean-up: The dup_copy_fields() function returns only zero, so make
it return void for now, and get rid of the return code check.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 2e68cea148e0..015d25a5cd03 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1425,7 +1425,7 @@ static __be32 nfsd4_do_copy(struct nfsd4_copy *copy, bool sync)
 	return status;
 }
 
-static int dup_copy_fields(struct nfsd4_copy *src, struct nfsd4_copy *dst)
+static void dup_copy_fields(struct nfsd4_copy *src, struct nfsd4_copy *dst)
 {
 	dst->cp_src_pos = src->cp_src_pos;
 	dst->cp_dst_pos = src->cp_dst_pos;
@@ -1444,8 +1444,6 @@ static int dup_copy_fields(struct nfsd4_copy *src, struct nfsd4_copy *dst)
 	memcpy(&dst->stateid, &src->stateid, sizeof(src->stateid));
 	memcpy(&dst->c_fh, &src->c_fh, sizeof(src->c_fh));
 	dst->ss_mnt = src->ss_mnt;
-
-	return 0;
 }
 
 static void cleanup_async_copy(struct nfsd4_copy *copy)
@@ -1539,9 +1537,7 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		refcount_set(&async_copy->refcount, 1);
 		memcpy(&copy->cp_res.cb_stateid, &copy->cp_stateid,
 			sizeof(copy->cp_stateid));
-		status = dup_copy_fields(copy, async_copy);
-		if (status)
-			goto out_err;
+		dup_copy_fields(copy, async_copy);
 		async_copy->copy_task = kthread_create(nfsd4_do_async_copy,
 				async_copy, "%s", "copy thread");
 		if (IS_ERR(async_copy->copy_task))
-- 
2.30.2



