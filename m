Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB9A10190E
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbfKSFWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:22:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:37976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727777AbfKSFWi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:22:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B33822318;
        Tue, 19 Nov 2019 05:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140958;
        bh=KJU+zhkG3Fh5JLQf/nv7CKz+c7E2hgigM4Sm19AJkwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LVD8msnEZwzrp1vKics98zEhe00XDP+mzFn5NHjCWqhCs9s57mJf74YmwLKPGN2xT
         UDrMhBWJGhlXoooZbJ2eA9wU2aUjT+tf5vKUlTCvN0jHmXc1nRsTxa4QdSH7yLrBgK
         zusH0xfkIYdfbMIprH+8nOUqqrvIX8TVNrckDBng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 06/48] net: gemini: add missed free_netdev
Date:   Tue, 19 Nov 2019 06:19:26 +0100
Message-Id: <20191119050953.205860839@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit 18d647ae74116bfee38953978501cea2960a0c25 ]

This driver forgets to free allocated netdev in remove like
what is done in probe failure.
Add the free to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cortina/gemini.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2527,6 +2527,7 @@ static int gemini_ethernet_port_remove(s
 	struct gemini_ethernet_port *port = platform_get_drvdata(pdev);
 
 	gemini_port_remove(port);
+	free_netdev(port->netdev);
 	return 0;
 }
 


