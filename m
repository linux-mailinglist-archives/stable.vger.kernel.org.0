Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E49412C785
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730444AbfL2RnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:43:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:50386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730441AbfL2RnO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:43:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3498208C4;
        Sun, 29 Dec 2019 17:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641394;
        bh=gzIBJEAK6Dy0AaVuvIWRkwkKKXwWO6V+SUWrWLjoxSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YpPhfNyI+MSGvp952vQYKwYv4bOIUATn2SWx7ce8DPoZTcuyh6+AqzlJMtcr2GTS8
         y+HTatMDeV8KARV1GHkoV17rG6B5LDfv1XzCT8UVVEAaW0+xhwuwU6+JCLytUxPBhe
         rNu6HN5mmm02KXbxhJRoWcYDWTPewdsC1HsTQU1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arthur Kiyanovski <akiyano@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 020/434] net: ena: fix default tx interrupt moderation interval
Date:   Sun, 29 Dec 2019 18:21:13 +0100
Message-Id: <20191229172703.499527188@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

[ Upstream commit 05785adf6e570a068adf0502b61fe2b521d7f0ca ]

Current default non-adaptive tx interrupt moderation interval is 196 us.
This value is too high and might cause the tx queue to fill up.

In this commit we set the default non-adaptive tx interrupt moderation
interval to 64 us in order to:
1. Reduce the probability of the queue filling-up (when compared to the
   current default value of 196 us).
2. Reduce unnecessary tx interrupt overhead (which happens if we set the
   default tx interval to 0).
   We determined experimentally that 64 us is an optimal value that
   reduces interrupt rate by more than 20% without affecting performance.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amazon/ena/ena_com.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -72,7 +72,7 @@
 /*****************************************************************************/
 /* ENA adaptive interrupt moderation settings */
 
-#define ENA_INTR_INITIAL_TX_INTERVAL_USECS		196
+#define ENA_INTR_INITIAL_TX_INTERVAL_USECS		64
 #define ENA_INTR_INITIAL_RX_INTERVAL_USECS		0
 #define ENA_DEFAULT_INTR_DELAY_RESOLUTION		1
 


