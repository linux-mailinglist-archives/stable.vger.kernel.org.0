Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC96276D9E
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389493AbfGZPcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:32:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389489AbfGZPcb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:32:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A238222CBD;
        Fri, 26 Jul 2019 15:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155151;
        bh=4zUQ3mFen+G+852s1/5awg/7sJQT7678uvNjAI8tJyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U3HfVpaGHsrhuXKQdsDCD7xwuf+sEL4xKqY3apj4QfsUl0r5R+nvZ3fihNLxV/nrt
         xZC+zzKh7GRaa976zReowPCJdQ8+4gBVI8fEYtFHuhjqo8mfq3RLzzP+N5pmMkqNhS
         lq5IDqP8MamP4SzmDRR7Mo7/A1u8an44kvRXFzx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 02/50] caif-hsi: fix possible deadlock in cfhsi_exit_module()
Date:   Fri, 26 Jul 2019 17:24:37 +0200
Message-Id: <20190726152301.005179735@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152300.760439618@linuxfoundation.org>
References: <20190726152300.760439618@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit fdd258d49e88a9e0b49ef04a506a796f1c768a8e ]

cfhsi_exit_module() calls unregister_netdev() under rtnl_lock().
but unregister_netdev() internally calls rtnl_lock().
So deadlock would occur.

Fixes: c41254006377 ("caif-hsi: Add rtnl support")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/caif/caif_hsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/caif/caif_hsi.c
+++ b/drivers/net/caif/caif_hsi.c
@@ -1455,7 +1455,7 @@ static void __exit cfhsi_exit_module(voi
 	rtnl_lock();
 	list_for_each_safe(list_node, n, &cfhsi_list) {
 		cfhsi = list_entry(list_node, struct cfhsi, list);
-		unregister_netdev(cfhsi->ndev);
+		unregister_netdevice(cfhsi->ndev);
 	}
 	rtnl_unlock();
 }


