Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E56F3643C5
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240822AbhDSNVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:21:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241327AbhDSNU0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:20:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BEC761363;
        Mon, 19 Apr 2021 13:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838177;
        bh=MemWX/XZ/BxlCqrtI7r2iibDGG5fUEyWMFYJQH4/ZbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X7WhMPHR3HMACLDG5NSxk9jCMYXY2y0e14HIXWHAlowWLu6JDyhVDthQJZS2TNa3O
         ixoHXAYv+WWaszmp6MnQS+F53PeLvyZTWB1xwSQPxundp4nsh+HceaQv62hBIFQQAA
         ej0+FJX5QgwaYBBrmzcbKsEoKgWeXN0Z4c8WNx+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 069/103] net: davicom: Fix regulator not turned off on failed probe
Date:   Mon, 19 Apr 2021 15:06:20 +0200
Message-Id: <20210419130530.194641907@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 31457db3750c0b0ed229d836f2609fdb8a5b790e upstream.

When the probe fails, we must disable the regulator that was previously
enabled.

This patch is a follow-up to commit ac88c531a5b3
("net: davicom: Fix regulator not turned off on failed probe") which missed
one case.

Fixes: 7994fe55a4a2 ("dm9000: Add regulator and reset support to dm9000")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/davicom/dm9000.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1474,8 +1474,10 @@ dm9000_probe(struct platform_device *pde
 
 	/* Init network device */
 	ndev = alloc_etherdev(sizeof(struct board_info));
-	if (!ndev)
-		return -ENOMEM;
+	if (!ndev) {
+		ret = -ENOMEM;
+		goto out_regulator_disable;
+	}
 
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 


