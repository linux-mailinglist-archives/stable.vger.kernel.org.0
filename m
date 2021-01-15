Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779072F7A1D
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388118AbhAOMiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:38:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731350AbhAOMiG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:38:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E460B23339;
        Fri, 15 Jan 2021 12:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714246;
        bh=VAcuSrKBtj/JTJlwA/d2QKcyl/Avu9LKS2KE18ZMLpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wCsonvPKEkBOsmvcxJSOij5xGjBpnlRrkAQvoV43Q9BJNRqWID3uFpziZz/CNAnD8
         5yWMePrsZBBb7FxtaC7x59255dKM95UmpRB/XnV7ICkt1i4++/+AVXFvAkBE9R2zJC
         B0FVZV8fPzN6BB3SZgpJR7Aq2nvg/c54Xs5HOYwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 049/103] ionic: start queues before announcing link up
Date:   Fri, 15 Jan 2021 13:27:42 +0100
Message-Id: <20210115122008.431595108@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

commit 8f56bc4dc1011be6e2a53198b615fdc588b4ef6a upstream.

Change the order of operations in the link_up handling to be
sure that the queues are up and ready before we announce that
the link is up.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -123,6 +123,12 @@ static void ionic_link_status_check(stru
 	link_up = link_status == IONIC_PORT_OPER_STATUS_UP;
 
 	if (link_up) {
+		if (lif->netdev->flags & IFF_UP && netif_running(lif->netdev)) {
+			mutex_lock(&lif->queue_lock);
+			ionic_start_queues(lif);
+			mutex_unlock(&lif->queue_lock);
+		}
+
 		if (!netif_carrier_ok(netdev)) {
 			u32 link_speed;
 
@@ -132,12 +138,6 @@ static void ionic_link_status_check(stru
 				    link_speed / 1000);
 			netif_carrier_on(netdev);
 		}
-
-		if (lif->netdev->flags & IFF_UP && netif_running(lif->netdev)) {
-			mutex_lock(&lif->queue_lock);
-			ionic_start_queues(lif);
-			mutex_unlock(&lif->queue_lock);
-		}
 	} else {
 		if (netif_carrier_ok(netdev)) {
 			netdev_info(netdev, "Link down\n");


