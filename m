Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4D4F7CAB
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730255AbfKKSsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:48:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:41614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729865AbfKKSsb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:48:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BB0E20674;
        Mon, 11 Nov 2019 18:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498110;
        bh=xFBlIuhONq+naCWyfL6jszbnWwxREMT+IEYwbtlTFTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=THdsZqC93Agg3FmpAO9lwe3GkUHuVi/dBVRoXK/T5VfpYauLtn4s0jKyayMbAzHU5
         eB1xqob5sPEp9xKChccAdVWfQ5F0XnkdVfTOhysmZyVzMz1h8GPNTezdC3OBoxVkDf
         VlENLJ098pgC9KaV7n/hae5NWMXMDamdZypLTfBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Tranchetti <stranche@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 006/193] net: qualcomm: rmnet: Fix potential UAF when unregistering
Date:   Mon, 11 Nov 2019 19:26:28 +0100
Message-Id: <20191111181500.307705719@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Tranchetti <stranche@codeaurora.org>

[ Upstream commit e7a86c687e64ab24f88330ad24ecc9442ce40c5a ]

During the exit/unregistration process of the RmNet driver, the function
rmnet_unregister_real_device() is called to handle freeing the driver's
internal state and removing the RX handler on the underlying physical
device. However, the order of operations this function performs is wrong
and can lead to a use after free of the rmnet_port structure.

Before calling netdev_rx_handler_unregister(), this port structure is
freed with kfree(). If packets are received on any RmNet devices before
synchronize_net() completes, they will attempt to use this already-freed
port structure when processing the packet. As such, before cleaning up any
other internal state, the RX handler must be unregistered in order to
guarantee that no further packets will arrive on the device.

Fixes: ceed73a2cf4a ("drivers: net: ethernet: qualcomm: rmnet: Initial implementation")
Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -57,10 +57,10 @@ static int rmnet_unregister_real_device(
 	if (port->nr_rmnet_devs)
 		return -EINVAL;
 
-	kfree(port);
-
 	netdev_rx_handler_unregister(real_dev);
 
+	kfree(port);
+
 	/* release reference on real_dev */
 	dev_put(real_dev);
 


