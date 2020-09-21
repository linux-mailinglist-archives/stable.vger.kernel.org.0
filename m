Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54760272DEC
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729046AbgIUQoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:44:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729180AbgIUQns (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:43:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1289023976;
        Mon, 21 Sep 2020 16:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706627;
        bh=J3gXBR/Gjl3DzX0hS0PTmUv2pIWLYi4Gy2GOp/A5aj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mVcU5j2kIW1+spWYo4kPJTkcfdRzTJt037Y6Y+wO/XJa2n+oX8a51+tou1ImW0wjL
         GP3tvqq8U1qx204Yu0pToLFl0d/yAneEJE119jZmF8jJDrE9H7ZUZhQoeIfrTo4f+8
         lgDhEOJMukHQTaIP2PG6m2A+oPbN+pFRlJ8hcu6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Aloni <dan@kernelim.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 009/118] xprtrdma: Release in-flight MRs on disconnect
Date:   Mon, 21 Sep 2020 18:27:01 +0200
Message-Id: <20200921162036.774749872@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 5de55ce951a1466e31ff68a7bc6b0a7ce3cb5947 ]

Dan Aloni reports that when a server disconnects abruptly, a few
memory regions are left DMA mapped. Over time this leak could pin
enough I/O resources to slow or even deadlock an NFS/RDMA client.

I found that if a transport disconnects before pending Send and
FastReg WRs can be posted, the to-be-registered MRs are stranded on
the req's rl_registered list and never released -- since they
weren't posted, there's no Send completion to DMA unmap them.

Reported-by: Dan Aloni <dan@kernelim.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 75c646743df3e..ca89f24a1590b 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -933,6 +933,8 @@ static void rpcrdma_req_reset(struct rpcrdma_req *req)
 
 	rpcrdma_regbuf_dma_unmap(req->rl_sendbuf);
 	rpcrdma_regbuf_dma_unmap(req->rl_recvbuf);
+
+	frwr_reset(req);
 }
 
 /* ASSUMPTION: the rb_allreqs list is stable for the duration,
-- 
2.25.1



