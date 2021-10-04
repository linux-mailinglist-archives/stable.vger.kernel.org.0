Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46F5420CAF
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbhJDNJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:09:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234880AbhJDNGw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:06:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDB7661A10;
        Mon,  4 Oct 2021 13:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352491;
        bh=J24wOe4xyhUCDLUreq5i644+FCLl3h8HW+498wR9LDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kbtwhe8LbMO8rE6nhTz7O2EVxiltfHRAjy8/QNiERKa+MJYxe+SlGvTAeOlr5feXj
         ojB25NRxXy/UwktQy2Nge8s+RBNHEgafk7n1qkBDAFqnJ9HbD+PiayBDULw6TiCImb
         cBDbcgHCMD+FwV+wsm+r7sJaapT+Ulx5WFRqEeM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 70/75] usb: hso: remove the bailout parameter
Date:   Mon,  4 Oct 2021 14:52:45 +0200
Message-Id: <20211004125033.888169475@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125031.530773667@linuxfoundation.org>
References: <20211004125031.530773667@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

commit dcb713d53e2eadf42b878c12a471e74dc6ed3145 upstream.

There are two invocation sites of hso_free_net_device. After
refactoring hso_create_net_device, this parameter is useless.
Remove the bailout in the hso_free_net_device and change the invocation
sites of this function.

Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/hso.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2367,7 +2367,7 @@ static int remove_net_device(struct hso_
 }
 
 /* Frees our network device */
-static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
+static void hso_free_net_device(struct hso_device *hso_dev)
 {
 	int i;
 	struct hso_net *hso_net = dev2net(hso_dev);
@@ -2390,7 +2390,7 @@ static void hso_free_net_device(struct h
 	kfree(hso_net->mux_bulk_tx_buf);
 	hso_net->mux_bulk_tx_buf = NULL;
 
-	if (hso_net->net && !bailout)
+	if (hso_net->net)
 		free_netdev(hso_net->net);
 
 	kfree(hso_dev);
@@ -3142,7 +3142,7 @@ static void hso_free_interface(struct us
 				rfkill_unregister(rfk);
 				rfkill_destroy(rfk);
 			}
-			hso_free_net_device(network_table[i], false);
+			hso_free_net_device(network_table[i]);
 		}
 	}
 }


