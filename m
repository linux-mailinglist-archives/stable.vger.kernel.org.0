Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCD42F13C3
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732102AbhAKNOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:14:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:32916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732096AbhAKNOY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:14:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCD2F22BE9;
        Mon, 11 Jan 2021 13:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370823;
        bh=xsKO8t/e+1b3rFZNiVBhfHad4FQE+u7ji4PamRaXiOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uM6KbH6SydFk1SQuI6/21N0f6odaaHBMQiON6EVqgMF5lssdnglOzELz0WX48SEg/
         zmqze9v0L4cAoTJcr5HaQmC5Lgow26n4FfXfMYdWsR4M0d6QGBz8Y9P+azh0Xg1oAD
         qp6fCqIYnNzHcq88Dx3USPVBaeg6nQKxgu4DghDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH 5.10 002/145] iavf: fix double-release of rtnl_lock
Date:   Mon, 11 Jan 2021 14:00:26 +0100
Message-Id: <20210111130048.625683287@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit f1340265726e0edf8a8cef28e665b28ad6302ce9 ]

This code does not jump to exit on an error in iavf_lan_add_device(),
so the rtnl_unlock() from the normal path will follow.

Fixes: b66c7bc1cd4d ("iavf: Refactor init state machine")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1834,11 +1834,9 @@ static int iavf_init_get_resources(struc
 	netif_tx_stop_all_queues(netdev);
 	if (CLIENT_ALLOWED(adapter)) {
 		err = iavf_lan_add_device(adapter);
-		if (err) {
-			rtnl_unlock();
+		if (err)
 			dev_info(&pdev->dev, "Failed to add VF to client API service list: %d\n",
 				 err);
-		}
 	}
 	dev_info(&pdev->dev, "MAC address: %pM\n", adapter->hw.mac.addr);
 	if (netdev->features & NETIF_F_GRO)


