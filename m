Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEB9211D78
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbfEBPav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:30:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727097AbfEBPav (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:30:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B91F20B7C;
        Thu,  2 May 2019 15:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811050;
        bh=Qc4WrYPkG7zpu49vQ/9U7rHXma7VTH1nY6PgLIOK7Bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VWeOewu2omTC2wDh4uKIJiRXje+4Ow6155tfjCsqXdxN2tfPb2muUy3zrH4Ginkx5
         Tpi8Krl8gYabNXUOFHP5T0vWOSXFFR8qU9AxteZfM94Gf/SK/72jLlAk8/GlTd4t8o
         zN2o18sZcUjhe6wJJI1HWq4Ii+10+phgcRpJpfK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 055/101] NFS: Fix a typo in nfs_init_timeout_values()
Date:   Thu,  2 May 2019 17:20:57 +0200
Message-Id: <20190502143343.350822916@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5a698243930c441afccec04e4d5dc8febfd2b775 ]

Specifying a retrans=0 mount parameter to a NFS/TCP mount, is
inadvertently causing the NFS client to rewrite any specified
timeout parameter to the default of 60 seconds.

Fixes: a956beda19a6 ("NFS: Allow the mount option retrans=0")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 fs/nfs/client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index fb1cf1a4bda2..90d71fda65ce 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -453,7 +453,7 @@ void nfs_init_timeout_values(struct rpc_timeout *to, int proto,
 	case XPRT_TRANSPORT_RDMA:
 		if (retrans == NFS_UNSPEC_RETRANS)
 			to->to_retries = NFS_DEF_TCP_RETRANS;
-		if (timeo == NFS_UNSPEC_TIMEO || to->to_retries == 0)
+		if (timeo == NFS_UNSPEC_TIMEO || to->to_initval == 0)
 			to->to_initval = NFS_DEF_TCP_TIMEO * HZ / 10;
 		if (to->to_initval > NFS_MAX_TCP_TIMEOUT)
 			to->to_initval = NFS_MAX_TCP_TIMEOUT;
-- 
2.19.1



