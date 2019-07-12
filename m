Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF1366EE7
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbfGLMWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:22:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:57472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727740AbfGLMWh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:22:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C648208E4;
        Fri, 12 Jul 2019 12:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934157;
        bh=X9WQ/ktOz+HBaUxvZSp95khvRqJtVx22HGawG6wBIB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YfTd4zOYDo3bEdb6wHv0HYXku/u28J4+aSbC7Orxplob9LkkcI99JoPyEVS9tM1cM
         YFtFvVRqqQNkh7NJZGDlel6q647oSAJs+M5JcYl05zGSggv90mdGmTztGJGK/PVb1A
         dnby0Oy10VQZuzm2frWj4A84lNQjGKbRoFDkFaZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Yi <teroincn@163.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 55/91] net :sunrpc :clnt :Fix xps refcount imbalance on the error path
Date:   Fri, 12 Jul 2019 14:18:58 +0200
Message-Id: <20190712121624.649755174@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
References: <20190712121621.422224300@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b96226148491505318228ac52624956bd98f9e0c ]

rpc_clnt_add_xprt take a reference to struct rpc_xprt_switch, but forget
to release it before return, may lead to a memory leak.

Signed-off-by: Lin Yi <teroincn@163.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 7e4553dbc3c7..0d7d149b1b1b 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2713,6 +2713,7 @@ int rpc_clnt_add_xprt(struct rpc_clnt *clnt,
 	xprt = xprt_iter_xprt(&clnt->cl_xpi);
 	if (xps == NULL || xprt == NULL) {
 		rcu_read_unlock();
+		xprt_switch_put(xps);
 		return -EAGAIN;
 	}
 	resvport = xprt->resvport;
-- 
2.20.1



