Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF37E4638A4
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245125AbhK3PFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:05:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243828AbhK3O6y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:58:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB11BC0698E4;
        Tue, 30 Nov 2021 06:52:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 33242CE1A68;
        Tue, 30 Nov 2021 14:52:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1FDCC53FD3;
        Tue, 30 Nov 2021 14:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283927;
        bh=wL3gMLfz8NIciqBIL29Na1AVFG8NtaxdC6fD/JtlC3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fv9+uSSOBxxLiaov+JMcLudGZo/OqPo2XZFuoKMHoQtnQA27MEDxYoKme95LTRX3g
         w96oU2t1rduO8j6h0nCbvr3PXmNfbqOwrA7NybcP+Z59Y+9T5l/DDSjurReVO8ONxl
         jH98tKQO0m+RxfYGrCO4XvU+7Y8yu6E2kl3V6wpAZkJitXrrmZ68mXIYD6nnFBgsXS
         NPNopzvTowaEyt0kfl0lYsbQd4Rjv8Jy55O+eLYj0yLnJejCm3XpOu8+5IqAgjQuaZ
         mW3zUQ0Sq3e+f2t2tWtSpty/2ajl8sa6/ScLUvDJsA/IQwupZrqT6eZvVhdmYMj0zw
         PRcYAKwKBzhEg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 05/25] NFSv4.1: handle NFS4ERR_NOSPC by CREATE_SESSION
Date:   Tue, 30 Nov 2021 09:51:35 -0500
Message-Id: <20211130145156.946083-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145156.946083-1-sashal@kernel.org>
References: <20211130145156.946083-1-sashal@kernel.org>
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
index ea680f619438b..54b6a05d533b7 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1966,6 +1966,10 @@ static int nfs4_handle_reclaim_lease_error(struct nfs_client *clp, int status)
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

