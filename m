Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D8929BF10
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1814902AbgJ0RA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793881AbgJ0PIv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:08:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A3682072E;
        Tue, 27 Oct 2020 15:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811330;
        bh=V848PUZLDPprJD8EhClYcg6o7BI+rxXHp2BCdI6ULUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PTKywKu5U1fLbyB2v8UdLWoGAI7/Z1BmKBD6WfzzWc50edti0KDk2nEoyLdr0F5j9
         cTts1/NYP0tGv2qhQGyhtG6dl+1/DVDP8ohD0OuRqoVd5Dr6UUbn9n7+OJJ/sttNGh
         KrnxVt9IB/kFROS48BRH4r9VvKRgKIOzOGnkLWNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Aloni <dan@kernelim.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 456/633] svcrdma: fix bounce buffers for unaligned offsets and multiple pages
Date:   Tue, 27 Oct 2020 14:53:19 +0100
Message-Id: <20201027135544.106853688@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Aloni <dan@kernelim.com>

[ Upstream commit c327a310ec4d6ecbea13185ed56c11def441d9ab ]

This was discovered using O_DIRECT at the client side, with small
unaligned file offsets or IOs that span multiple file pages.

Fixes: e248aa7be86 ("svcrdma: Remove max_sge check at connect time")
Signed-off-by: Dan Aloni <dan@kernelim.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_sendto.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
index 38e7c3c8c4a9c..e4f410084c748 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -637,10 +637,11 @@ static int svc_rdma_pull_up_reply_msg(struct svcxprt_rdma *rdma,
 		while (remaining) {
 			len = min_t(u32, PAGE_SIZE - pageoff, remaining);
 
-			memcpy(dst, page_address(*ppages), len);
+			memcpy(dst, page_address(*ppages) + pageoff, len);
 			remaining -= len;
 			dst += len;
 			pageoff = 0;
+			ppages++;
 		}
 	}
 
-- 
2.25.1



