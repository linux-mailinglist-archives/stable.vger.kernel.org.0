Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24F746373A
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242485AbhK3OwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:52:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242491AbhK3OvX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:51:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A6BC061756;
        Tue, 30 Nov 2021 06:48:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D5A3B81A1A;
        Tue, 30 Nov 2021 14:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DEC2C5674A;
        Tue, 30 Nov 2021 14:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283681;
        bh=ZgvZjKX5libj68VsWjPP/N/sLjldTMXfqOXGBoHep/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I54x6qnv+kgsLR9jTZ7oXnfK5B3tAnFaR0SVLRjp0fe3xzcR/6RbWr2EJmlDJtgyK
         O3OtBtIlXv413N+YnI7YA6uZgnwTpqBjDWJWnTPBnvQmqU3qKSuX1G+cyFWMrWOq7I
         E4bvpc73bFRuv4j8GcSv24tFC0+VPlgTLQQyl4Wt54Nek1hAfIi7w/Pu3QQn8I8ZNn
         rUaMM2mxEhFAnr+yw1uaIoaKVsuukxEXn+pXSxH6qONpOYnojGoJsQWIS0JXLT/nMt
         xvAZtrcky/8uvFmLkI7IJGNCCaJ1VfXCofYqyWAgjbaxYvIs0ZF1+l9cEbDueOJ4HP
         aItw2XgXoWHkA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 17/68] NFSv4.1: handle NFS4ERR_NOSPC by CREATE_SESSION
Date:   Tue, 30 Nov 2021 09:46:13 -0500
Message-Id: <20211130144707.944580-17-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit ea027cb2e1b59c76582af867b71d5c037fa6bb8e ]

When the client receives ERR_NOSPC on reply to CREATE_SESSION
it leads to a client hanging in nfs_wait_client_init_complete().
Instead, complete and fail the client initiation with an EIO
error which allows for the mount command to fail instead of
hanging.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4state.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index f22818a80c2c7..118aeeffd244b 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2001,6 +2001,10 @@ static int nfs4_handle_reclaim_lease_error(struct nfs_client *clp, int status)
 		dprintk("%s: exit with error %d for server %s\n",
 				__func__, -EPROTONOSUPPORT, clp->cl_hostname);
 		return -EPROTONOSUPPORT;
+	case -ENOSPC:
+		if (clp->cl_cons_state == NFS_CS_SESSION_INITING)
+			nfs_mark_client_ready(clp, -EIO);
+		return -EIO;
 	case -NFS4ERR_NOT_SAME: /* FixMe: implement recovery
 				 * in nfs4_exchange_id */
 	default:
-- 
2.33.0

