Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDA43A6093
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbhFNKfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:35:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233398AbhFNKeP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:34:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46CDD611EE;
        Mon, 14 Jun 2021 10:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666712;
        bh=UptBzNfeCFXoO/8+cAJLZdyvV3fW0PW442zm1FX1824=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kqnaVDMIX/UHN6s8EoLjEalyVlNt/J4DaHbJF7wQ2VvfdvhmQAc9P3MAthD8nw46D
         TMQpjACSprOz65c6S5+LhnoAtz2ykk0E44RKc5fTqf8jy0bY/t2FvCb1o5fE4c7YgW
         DXn+9r9jX8Iv3LRPW6u3pF923fyWzwLDuwId0nZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 35/42] NFS: Fix a potential NULL dereference in nfs_get_client()
Date:   Mon, 14 Jun 2021 12:27:26 +0200
Message-Id: <20210614102643.820943274@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102642.700712386@linuxfoundation.org>
References: <20210614102642.700712386@linuxfoundation.org>
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
index 28d8a57a9908..d322ed5cbc1c 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -379,7 +379,7 @@ nfs_get_client(const struct nfs_client_initdata *cl_init,
 
 	if (cl_init->hostname == NULL) {
 		WARN_ON(1);
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	dprintk("--> nfs_get_client(%s,v%u)\n",
-- 
2.30.2



