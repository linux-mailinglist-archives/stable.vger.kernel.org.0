Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10FFB4638D2
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238791AbhK3PGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:06:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244777AbhK3PCl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 10:02:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59281C08EACA;
        Tue, 30 Nov 2021 06:54:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22B7CB81A21;
        Tue, 30 Nov 2021 14:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A71C53FCD;
        Tue, 30 Nov 2021 14:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638284045;
        bh=E/EVtFc/E/hc4xg0Tm1/JXdr6VWklKGBiUjYr0QDf1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u4QhsvGzoqGBFJNUs2kLXL1TWSfSPwtBJR8uY/SvQDM5fZ8pFuzF3a/pWC81lMaBP
         cmtGIju/k7cJSrwXBx+90aoPSicfL+O22HcUeMd3KMoVmOXBTfw3XEs0gemohTIdkz
         8zms8QIRpaYaVRQo/G94FNdWMVxGlL1MtOZGZ6VM7D22HGbI2+4CUa1vNjhsd00ksV
         KPkZC6mJV+8fuMQY3YZYrAkMjD58gtPmRbPnkH/9VxEJrTCs9kdenUYSCeE3lKcoxy
         +bkxhtxdSefy1huOvw+z4quGyIV9CS9EHw4kQKRjCSobhsfz+/GCt2R1NEqta/hD2N
         ElWu+EW6yxwAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 2/9] NFSv4.1: handle NFS4ERR_NOSPC by CREATE_SESSION
Date:   Tue, 30 Nov 2021 09:53:55 -0500
Message-Id: <20211130145402.947049-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145402.947049-1-sashal@kernel.org>
References: <20211130145402.947049-1-sashal@kernel.org>
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
index ef3ed2b1fd278..9e872db0f70ea 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1843,6 +1843,10 @@ static int nfs4_handle_reclaim_lease_error(struct nfs_client *clp, int status)
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

