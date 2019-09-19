Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 466D7B8747
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393216AbfISWH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:07:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393204AbfISWH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:07:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCADA218AF;
        Thu, 19 Sep 2019 22:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930846;
        bh=UXVo+pU6qQRSRGMlASXtc2PBgkdgS/CgDw6gXYTmWk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p4nlPGb+66Ilu/qcJbN+uOKj1VfTgb3Fkxa8AfE321E3lc7pDriYPYsEHEZ5WbOCb
         2Ts14vhQv+NXlt2dCxJ4vjb1QV6EjFHR/PYjdB/nl6gg+GskInTPCBwPZ0SVfg/eOW
         hnOuT0g3A7hScg2U2zkhEaStSJlQQIxkfWXT3oZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.2 008/124] SUNRPC: Handle connection breakages correctly in call_status()
Date:   Fri, 20 Sep 2019 00:01:36 +0200
Message-Id: <20190919214819.482284980@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit c82e5472c9980e0e483f4b689044150eefaca408 upstream.

If the connection breaks while we're waiting for a reply from the
server, then we want to immediately try to reconnect.

Fixes: ec6017d90359 ("SUNRPC fix regression in umount of a secure mount")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/clnt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2301,7 +2301,7 @@ call_status(struct rpc_task *task)
 	case -ECONNABORTED:
 	case -ENOTCONN:
 		rpc_force_rebind(clnt);
-		/* fall through */
+		break;
 	case -EADDRINUSE:
 		rpc_delay(task, 3*HZ);
 		/* fall through */


