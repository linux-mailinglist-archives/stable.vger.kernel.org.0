Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6812B1FB9F2
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732193AbgFPPqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:46:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732192AbgFPPqV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:46:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A614A20776;
        Tue, 16 Jun 2020 15:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322381;
        bh=OWTCT5TGO+j2Z/dlv3pknWTmKUwEHdX83YtwpWOdZO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pou+RKa+vJajRU7w+Zz8x8KlIxbRfWcuTY20iWGtY2jhD2LUy8DIp0OM2odo1UQpI
         u+u/Bh5FgEth8QbPN15guN17WhoBVvLmcsdQIJF42Z0FSzA6yrM+RJlpbKJ2fC5e3H
         9W75Q0b+u4VyxPJXyZb2uQ6LWJYlGkTTpTlztFd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 109/163] ionic: wait on queue start until after IFF_UP
Date:   Tue, 16 Jun 2020 17:34:43 +0200
Message-Id: <20200616153112.027507395@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit 976ee3b21119dcf5c6d96233d688a1453f29fa83 ]

The netif_running() test looks at __LINK_STATE_START which
gets set before ndo_open() is called, there is a window of
time between that and when the queues are actually ready to
be run.  If ionic_check_link_status() notices that the link is
up very soon after netif_running() becomes true, it might try
to run the queues before they are ready, causing all manner of
potential issues.  Since the netdev->flags IFF_UP isn't set
until after ndo_open() returns, we can wait for that before
we allow ionic_check_link_status() to start the queues.

On the way back to close, __LINK_STATE_START is cleared before
calling ndo_stop(), and IFF_UP is cleared after.  Both of
these need to be true in order to safely stop the queues
from ionic_check_link_status().

Fixes: 49d3b493673a ("ionic: disable the queues on link down")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -105,7 +105,7 @@ static void ionic_link_status_check(stru
 			netif_carrier_on(netdev);
 		}
 
-		if (netif_running(lif->netdev))
+		if (lif->netdev->flags & IFF_UP && netif_running(lif->netdev))
 			ionic_start_queues(lif);
 	} else {
 		if (netif_carrier_ok(netdev)) {
@@ -113,7 +113,7 @@ static void ionic_link_status_check(stru
 			netif_carrier_off(netdev);
 		}
 
-		if (netif_running(lif->netdev))
+		if (lif->netdev->flags & IFF_UP && netif_running(lif->netdev))
 			ionic_stop_queues(lif);
 	}
 


