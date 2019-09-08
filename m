Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66EB3ACE1E
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732567AbfIHMvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:51:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732558AbfIHMvT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:51:19 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB5DA20863;
        Sun,  8 Sep 2019 12:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947079;
        bh=849ghA3tHGvQiAT6aMSTPsQUQKktl4Z5P9iopykH5GU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0vYPywalov4mLVF4FomsbLOiBxPCTQxH34QPmMYZ17B09wM9eMLS+NxrAE2G+4oXS
         cWmc3Y3dPMDEdasphUbtKfuPvnJJa/rIk8O3RdqGUtS/0viWjYZMjFW1PnUW/Yypik
         CqAXN4lL4x8mwx+NuP0OlCcQU1BtU+rjEmsHS5ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 11/94] r8152: remove calling netif_napi_del
Date:   Sun,  8 Sep 2019 13:41:07 +0100
Message-Id: <20190908121150.756359393@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>

[ Upstream commit 973dc6cfc0e2c43ff29ca5645ceaf1ae694ea110 ]

Remove unnecessary use of netif_napi_del. This also avoids to call
napi_disable() after netif_napi_del().

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/r8152.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -5309,7 +5309,6 @@ static int rtl8152_probe(struct usb_inte
 	return 0;
 
 out1:
-	netif_napi_del(&tp->napi);
 	usb_set_intfdata(intf, NULL);
 out:
 	free_netdev(netdev);
@@ -5327,7 +5326,6 @@ static void rtl8152_disconnect(struct us
 		if (udev->state == USB_STATE_NOTATTACHED)
 			set_bit(RTL8152_UNPLUG, &tp->flags);
 
-		netif_napi_del(&tp->napi);
 		unregister_netdev(tp->netdev);
 		cancel_delayed_work_sync(&tp->hw_phy_work);
 		tp->rtl_ops.unload(tp);


