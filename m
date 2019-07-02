Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDEDB5CB68
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbfGBIIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:08:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727442AbfGBIIP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:08:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66DA3206A2;
        Tue,  2 Jul 2019 08:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054894;
        bh=aRwZf47F5Au9hTwdY7W3PXKuPcX5jdbLZiowoiLsp9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qE2KKE0R5UqD2eKAf25aHSkzQYvbn7SThjtent6SDVSnkvGHME6+8zTeq2m7sEKA8
         XGCRI7oE3DgrcUct3ROedkvKNsrWTFaCjA2F8jZnvMzqJ21Uov0MMeNhjDTVKWzNM9
         tPTtsWezEub+HX2JwT5rrZBSJ9ZNz5FzgVSmQxr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dominique Martinet <dominique.martinet@cea.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 18/72] 9p: potential NULL dereference
Date:   Tue,  2 Jul 2019 10:01:19 +0200
Message-Id: <20190702080125.601601192@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 72ea0321088df2c41eca8cc6160c24bcceb56ac7 ]

p9_tag_alloc() is supposed to return error pointers, but we accidentally
return a NULL here.  It would cause a NULL dereference in the caller.

Link: http://lkml.kernel.org/m/20180926103934.GA14535@mwanda
Fixes: 996d5b4db4b1 ("9p: Use a slab for allocating requests")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 4becde979462..b615aae5a0f8 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -287,7 +287,7 @@ p9_tag_alloc(struct p9_client *c, int8_t type, unsigned int max_size)
 	int tag;
 
 	if (!req)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	if (p9_fcall_init(c, &req->tc, alloc_msize))
 		goto free_req;
-- 
2.20.1



