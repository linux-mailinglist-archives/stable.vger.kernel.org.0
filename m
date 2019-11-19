Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 294E9101339
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbfKSFXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:23:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:39166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727998AbfKSFX3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:23:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1F8621939;
        Tue, 19 Nov 2019 05:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141009;
        bh=+BL0pUyYlX6NeVD4sRr5Ez7iDil4JFeIxWyHoBfyd/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0zxpKvCO6F+UOlGj6GU0RralHe4boinEYgnUb9S0VfjUlBhmXvU0qsG2tNK12k72I
         CNT4yQeYwXcvYg6uxHsnVcOHCOknQNa+KeSTZNI9/rcmS5UcoWq9NO7j4aINQZzeU2
         IRIsPvTMZ4rMIY8KVTTneKEroSQsBTZF1fKdjnto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 006/422] net: gemini: add missed free_netdev
Date:   Tue, 19 Nov 2019 06:13:23 +0100
Message-Id: <20191119051400.621181134@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
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
@@ -2530,6 +2530,7 @@ static int gemini_ethernet_port_remove(s
 	struct gemini_ethernet_port *port = platform_get_drvdata(pdev);
 
 	gemini_port_remove(port);
+	free_netdev(port->netdev);
 	return 0;
 }
 


