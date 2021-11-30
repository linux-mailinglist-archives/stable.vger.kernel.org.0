Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0624638E9
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244860AbhK3PG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:06:26 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58866 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243227AbhK3O4o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:56:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2DC5CCE1A5F;
        Tue, 30 Nov 2021 14:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE84DC53FC7;
        Tue, 30 Nov 2021 14:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638284002;
        bh=6twH5+TpWJnPN7F7KBiM85o+hDSCWp2TFCGV04d+MoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QWlwx3Eq/4Yz3p77cGfIpIhx/23tXbpAz6hhnMxtB6SKuAGs44KNHBEKSITG2KbEf
         myEXk2enTwHxPJpK9VLs53GqwIEOf8hdYIAEMi1+FTffdE+D5CtYxGHeEqRdtywSM4
         xx/Va/+Gg13P6KtaDacxgJrTjDfIQlvlGi0oy1tRnqaYvwBLq16RXm+xmc/wX+Tgz5
         Eeyk6FbIEjDNVQwQ1tsfHc8vUzLJOLcCwad0zP1itD5KweaD8INO/rD8nwG83c7Vym
         0+jwIMdbHN1nMoOzXXrcicTPYsUMPw9bDr6iPK14j55QHOeqGv/4lADzSTTghCH5Er
         kWCduFttIz10A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 03/14] NFSv4.1: handle NFS4ERR_NOSPC by CREATE_SESSION
Date:   Tue, 30 Nov 2021 09:53:04 -0500
Message-Id: <20211130145317.946676-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145317.946676-1-sashal@kernel.org>
References: <20211130145317.946676-1-sashal@kernel.org>
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
index f92bfc787c5fe..2bdeb212045fd 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1901,6 +1901,10 @@ static int nfs4_handle_reclaim_lease_error(struct nfs_client *clp, int status)
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

