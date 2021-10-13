Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2EB42B142
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237005AbhJMA53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:57:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236560AbhJMA5O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:57:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE70D60EDF;
        Wed, 13 Oct 2021 00:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086511;
        bh=8zCU2nlRYLRBGVJ26VlzzduvBDnrz13k2Me2mSuQRm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DNPVPLoWeXgfTh/d+4VQN6FEfTPUzUDZngPzamuQ1S2sSJCmBMcx+0XGm3WT6Xr8a
         ykdWVZW3NOU8V2m2RgZhGrjXxC4TLFTZ/CSx0Q1TrO84D6inWfkTQbyZALYyCIewDp
         WJY5UTbq2NYkcTtBvI8j4NDQ0TZnXyg+4qgvwX8s1eTgs6TAgauQQ73SMVKkUXAvvC
         obFXvX3QCxDSclWnimGvg1QCXhF00V2r+KpI0/rzjOFAYgXma6cf02L0VgDGibMYl6
         BJJSCoIcA/TXuyKqX2b7p/BtK0ReyVr45z9xlH2yZCRlcL/kUb9/7a+V1N3F0kT4Wz
         /Jiw3Vm9HBJIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Coddington <bcodding@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, bfields@fieldses.org,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 12/17] NFSD: Keep existing listeners on portlist error
Date:   Tue, 12 Oct 2021 20:54:36 -0400
Message-Id: <20211013005441.699846-12-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013005441.699846-1-sashal@kernel.org>
References: <20211013005441.699846-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit c20106944eb679fa3ab7e686fe5f6ba30fbc51e5 ]

If nfsd has existing listening sockets without any processes, then an error
returned from svc_create_xprt() for an additional transport will remove
those existing listeners.  We're seeing this in practice when userspace
attempts to create rpcrdma transports without having the rpcrdma modules
present before creating nfsd kernel processes.  Fix this by checking for
existing sockets before calling nfsd_destroy().

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsctl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index c2c3d9077dc5..696a217255fc 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -793,7 +793,10 @@ static ssize_t __write_ports_addxprt(char *buf, struct net *net, const struct cr
 		svc_xprt_put(xprt);
 	}
 out_err:
-	nfsd_destroy(net);
+	if (!list_empty(&nn->nfsd_serv->sv_permsocks))
+		nn->nfsd_serv->sv_nrthreads--;
+	 else
+		nfsd_destroy(net);
 	return err;
 }
 
-- 
2.33.0

