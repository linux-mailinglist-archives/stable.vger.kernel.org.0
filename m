Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3478A1CAF9F
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbgEHNSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:18:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728053AbgEHMnS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:43:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A54BA20731;
        Fri,  8 May 2020 12:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941798;
        bh=+Kr0YZdilqw32Wu6ZnjBEU69JrMi5MUb4OE8GixeM8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fdIYwOi7xxTrt/S6NXWhA+QFvrWRssbYbyh/NCMA6NNv31q0HKCr/ZL+3KsNK8wJL
         zIgPLhcCMsjNEZSpdHJsAjTXcBCLW3c8Vy8lyKBkc7Q5hJMYgbr4Le8CFMZliDjyHu
         oc5eEJgHmqLnjN7X72GzXW1cWuVIjloaiU53GA1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 175/312] net: moxa: fix an error code
Date:   Fri,  8 May 2020 14:32:46 +0200
Message-Id: <20200508123136.803325883@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 1d3cd1773fddfdc9ffb0c2dec9a954c7a54bc207 upstream.

We accidentally return IS_ERR(priv->base) which is 1 instead of
PTR_ERR(priv->base) which is the error code.

Fixes: 6c821bd9edc9 ('net: Add MOXA ART SoCs ethernet driver')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/moxa/moxart_ether.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -460,9 +460,9 @@ static int moxart_mac_probe(struct platf
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	ndev->base_addr = res->start;
 	priv->base = devm_ioremap_resource(p_dev, res);
-	ret = IS_ERR(priv->base);
-	if (ret) {
+	if (IS_ERR(priv->base)) {
 		dev_err(p_dev, "devm_ioremap_resource failed\n");
+		ret = PTR_ERR(priv->base);
 		goto init_fail;
 	}
 


