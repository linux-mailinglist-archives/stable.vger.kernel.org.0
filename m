Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D59DE3D2916
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbhGVQA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:00:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233559AbhGVP7T (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:59:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEE446136E;
        Thu, 22 Jul 2021 16:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971993;
        bh=mp11EiE24wDcNafm9JEypj8lxrQqDu93h6rWFarLp/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LyATMjuLmCVoSuBE1tN+QfK0xXeSpwz9JiKLBHEXRVsy6V8NNci8SrFQacR6jL3CF
         x2mzFwqQoNrNmlpaDDqDk8w0HbrhbyT1RbRra5DTrGLIBY/MMaW9AhAwHW6vzd8OTN
         Ckd9urW8JKr7Twj77Nu6qQsL138zJ0B2E+BkR6FI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 105/125] net: ti: fix UAF in tlan_remove_one
Date:   Thu, 22 Jul 2021 18:31:36 +0200
Message-Id: <20210722155628.193020169@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit 0336f8ffece62f882ab3012820965a786a983f70 upstream.

priv is netdev private data and it cannot be
used after free_netdev() call. Using priv after free_netdev()
can cause UAF bug. Fix it by moving free_netdev() at the end of the
function.

Fixes: 1e0a8b13d355 ("tlan: cancel work at remove path")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/tlan.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -313,9 +313,8 @@ static void tlan_remove_one(struct pci_d
 	pci_release_regions(pdev);
 #endif
 
-	free_netdev(dev);
-
 	cancel_work_sync(&priv->tlan_tqueue);
+	free_netdev(dev);
 }
 
 static void tlan_start(struct net_device *dev)


