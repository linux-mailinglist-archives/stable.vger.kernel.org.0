Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2522F1622
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731117AbhAKNtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:49:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:57080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731105AbhAKNKE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:10:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 356D62250F;
        Mon, 11 Jan 2021 13:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370588;
        bh=SFdCxK+xwbydU7AWWzGIYYkfI9DiNJX2c/s24L5vk64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wH0GZYMUkHW63pC76JzVd4eq0tdFv/UlTshTZ5frjg5Kdzl5MU4HdipksMaCdsGlx
         kLjDoa97qcONzkkGEoe4scjSmKL1IeypbBKvyaYXh3GTbjRZHNqTlBlGx3bzvhq1zi
         qhGmFDSzMZgs59MrYKZVrFiuv5dudeRHyIKhxE/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH 5.4 11/92] iavf: fix double-release of rtnl_lock
Date:   Mon, 11 Jan 2021 14:01:15 +0100
Message-Id: <20210111130039.703655025@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
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
@@ -1844,11 +1844,9 @@ static int iavf_init_get_resources(struc
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


