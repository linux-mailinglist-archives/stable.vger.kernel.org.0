Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93233A616D
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbhFNKrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:47:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234400AbhFNKpJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:45:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDABA6144B;
        Mon, 14 Jun 2021 10:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666991;
        bh=U9b19LqfA6gAVxSQN6qm/Ym1F4SLPLWT3NMoMmEoC/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TwQ64jpr61DT7I52GywblKh32by0/6DLA/kPKJGpMI9a4u75Qr/GBxMwLq3IIRFBr
         ajhFl3brtUP40WR8tIiJUjIrby5xj+tZvtx4jHBC30Nhjt7nOj4eVZD6dwFOW9QOp8
         b4lTsBZcc01vJbYopQsgl5SuXL+v5vGuB3MoAvP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 56/67] NFS: Fix a potential NULL dereference in nfs_get_client()
Date:   Mon, 14 Jun 2021 12:27:39 +0200
Message-Id: <20210614102645.657262029@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102643.797691914@linuxfoundation.org>
References: <20210614102643.797691914@linuxfoundation.org>
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
index 07c5ddd5d6d5..78b6f8bc9d76 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -407,7 +407,7 @@ struct nfs_client *nfs_get_client(const struct nfs_client_initdata *cl_init)
 
 	if (cl_init->hostname == NULL) {
 		WARN_ON(1);
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	/* see if the client already exists */
-- 
2.30.2



