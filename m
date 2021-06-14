Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8A03A6492
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235506AbhFNL00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:26:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236270AbhFNLYY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:24:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1894613F2;
        Mon, 14 Jun 2021 10:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623668051;
        bh=xhHb26kpx4nRhG32IEujXdiCAMn93UWleYYpVnzfNn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZeJyyB1vf/7wUKMne1IVOC+B5UTKXk7sV1zSlwbmZTar78PXNufKGY/bg/btypF2
         FOjfeUURNrZu5GczinOeUKf5QAxiGZNytjrQ9lveFYHEp7UQuV12Ol5OKrp2UexmET
         2hsfmh/rEa7hcldSPWED6NAaexeZ2q7oN2PdlbUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 162/173] NFS: Fix a potential NULL dereference in nfs_get_client()
Date:   Mon, 14 Jun 2021 12:28:14 +0200
Message-Id: <20210614102703.551028794@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 09226e8303beeec10f2ff844d2e46d1371dc58e0 ]

None of the callers are expecting NULL returns from nfs_get_client() so
this code will lead to an Oops.  It's better to return an error
pointer.  I expect that this is dead code so hopefully no one is
affected.

Fixes: 31434f496abb ("nfs: check hostname in nfs_get_client")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index ff5c4d0d6d13..686b211342a8 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -406,7 +406,7 @@ struct nfs_client *nfs_get_client(const struct nfs_client_initdata *cl_init)
 
 	if (cl_init->hostname == NULL) {
 		WARN_ON(1);
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	/* see if the client already exists */
-- 
2.30.2



