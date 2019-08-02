Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBFC87F2AD
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405492AbfHBJqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:46:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405487AbfHBJqI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:46:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D502216C8;
        Fri,  2 Aug 2019 09:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739167;
        bh=mHJ9LcbmW1LTbkgqUUt/uyMFW02Cmwsg9kH1uzToT/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VRHLiM1FWd/fMRZ3eSs3T7bmBz9h7aT0DHZPZQlZobs9hIi4SwjXpXbz/4bUd226j
         M5Dz2HjpdkCgLxpQjdjBI+gvEEo+Hpu8Hm81euvGIhAxFD5IJ1Mm6IQz5XAlGyoVsq
         5R2CjwKDH0UXm286nxrMB9hqAWI51UUkOy91xh5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 131/223] caif-hsi: fix possible deadlock in cfhsi_exit_module()
Date:   Fri,  2 Aug 2019 11:35:56 +0200
Message-Id: <20190802092247.449015600@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
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
@@ -1464,7 +1464,7 @@ static void __exit cfhsi_exit_module(voi
 	rtnl_lock();
 	list_for_each_safe(list_node, n, &cfhsi_list) {
 		cfhsi = list_entry(list_node, struct cfhsi, list);
-		unregister_netdev(cfhsi->ndev);
+		unregister_netdevice(cfhsi->ndev);
 	}
 	rtnl_unlock();
 }


