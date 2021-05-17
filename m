Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E409338355C
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243327AbhEQPSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:18:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242692AbhEQPQM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:16:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1995861C5B;
        Mon, 17 May 2021 14:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261962;
        bh=VSWwm3qHb2ni9JKb0Wjc4srAAOWNFy3yN5/uvmUwoCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p1mLUHBngSqEtTyN66IYXuoV4qiLi3QYRYx7Jii7elxO+ySMIJSSYkvtNpbSy0Z1E
         howUCyqQOWG5sb8EjNzGsfVaD0yOVkv3ZDZyg+T/n3grjWfPu+TYVfO7aqtJMrVGQN
         WTLB0Ud6itMREjhqMDbRQWWHpnT/gmCQfLc1+vDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunjian Wang <wangyunjian@huawei.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 166/329] SUNRPC: Fix null pointer dereference in svc_rqst_free()
Date:   Mon, 17 May 2021 16:01:17 +0200
Message-Id: <20210517140307.753790459@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

[ Upstream commit b9f83ffaa0c096b4c832a43964fe6bff3acffe10 ]

When alloc_pages_node() returns null in svc_rqst_alloc(), the
null rq_scratch_page pointer will be dereferenced when calling
put_page() in svc_rqst_free(). Fix it by adding a null check.

Addresses-Coverity: ("Dereference after null check")
Fixes: 5191955d6fc6 ("SUNRPC: Prepare for xdr_stream-style decoding on the server-side")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 7034b4755fa1..16b6681a97ab 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -846,7 +846,8 @@ void
 svc_rqst_free(struct svc_rqst *rqstp)
 {
 	svc_release_buffer(rqstp);
-	put_page(rqstp->rq_scratch_page);
+	if (rqstp->rq_scratch_page)
+		put_page(rqstp->rq_scratch_page);
 	kfree(rqstp->rq_resp);
 	kfree(rqstp->rq_argp);
 	kfree(rqstp->rq_auth_data);
-- 
2.30.2



