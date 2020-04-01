Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B8619B3DD
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732888AbgDAQYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:24:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387726AbgDAQYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:24:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B840D20857;
        Wed,  1 Apr 2020 16:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758283;
        bh=uCCBnvAmoM6CXoiE31srDPDYHRKuIFtQnwp9kkaKSDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tAv+9D7Mo8IQ+mzQhX8mGBVJmvH6m0xdEtsWDRU0PgEfiA9u1DgHfX2ao9tkk58Xw
         6tGYc5VHsgP2+xzCWR7cpiTVCa5f5U4CMt1hOSpFkDrTQp6i8QjILmjN0B6PrDjSP4
         B508Klt90PwUC+VGo5YIFOvsmvvSpGM7dP33UafQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+68a8ed58e3d17c700de5@syzkaller.appspotmail.com
Subject: [PATCH 4.19 007/116] geneve: move debug check after netdev unregister
Date:   Wed,  1 Apr 2020 18:16:23 +0200
Message-Id: <20200401161543.245711159@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161542.669484650@linuxfoundation.org>
References: <20200401161542.669484650@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 0fda7600c2e174fe27e9cf02e78e345226e441fa ]

The debug check must be done after unregister_netdevice_many() call --
the list_del() for this is done inside .ndo_stop.

Fixes: 2843a25348f8 ("geneve: speedup geneve tunnels dismantle")
Reported-and-tested-by: <syzbot+68a8ed58e3d17c700de5@syzkaller.appspotmail.com>
Cc: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/geneve.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1725,8 +1725,6 @@ static void geneve_destroy_tunnels(struc
 		if (!net_eq(dev_net(geneve->dev), net))
 			unregister_netdevice_queue(geneve->dev, head);
 	}
-
-	WARN_ON_ONCE(!list_empty(&gn->sock_list));
 }
 
 static void __net_exit geneve_exit_batch_net(struct list_head *net_list)
@@ -1741,6 +1739,12 @@ static void __net_exit geneve_exit_batch
 	/* unregister the devices gathered above */
 	unregister_netdevice_many(&list);
 	rtnl_unlock();
+
+	list_for_each_entry(net, net_list, exit_list) {
+		const struct geneve_net *gn = net_generic(net, geneve_net_id);
+
+		WARN_ON_ONCE(!list_empty(&gn->sock_list));
+	}
 }
 
 static struct pernet_operations geneve_net_ops = {


