Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 262622C0AFE
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731384AbgKWMee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:34:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:46280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731378AbgKWMec (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:34:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EBDC208DB;
        Mon, 23 Nov 2020 12:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134871;
        bh=fbKZ/v1f/Y69Fi5kPOfTz3hmzaxaZOrXbwLaHvmEm0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rnah4LZtmuKp5kZCwgR+NJOhV5g07yTd0PCphcXHgpuFCxqyyzsDTTeUz6fcolymP
         FMm7WHTvjBqHsorGYuV6hD4tC5HOZSriq2YO96GSjMEIbf/sNsAcruP0TUWH+pv9qy
         399mgy7vSAyeTloGabba4wvPPokWxiUAHlPACJ1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Tranchetti <stranche@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 020/158] net: qualcomm: rmnet: Fix incorrect receive packet handling during cleanup
Date:   Mon, 23 Nov 2020 13:20:48 +0100
Message-Id: <20201123121820.910719364@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

[ Upstream commit fc70f5bf5e525dde81565f0a30d5e39168062eba ]

During rmnet unregistration, the real device rx_handler is first cleared
followed by the removal of rx_handler_data after the rcu synchronization.

Any packets in the receive path may observe that the rx_handler is NULL.
However, there is no check when dereferencing this value to use the
rmnet_port information.

This fixes following splat by adding the NULL check.

Unable to handle kernel NULL pointer dereference at virtual
address 000000000000000d
pc : rmnet_rx_handler+0x124/0x284
lr : rmnet_rx_handler+0x124/0x284
 rmnet_rx_handler+0x124/0x284
 __netif_receive_skb_core+0x758/0xd74
 __netif_receive_skb+0x50/0x17c
 process_backlog+0x15c/0x1b8
 napi_poll+0x88/0x284
 net_rx_action+0xbc/0x23c
 __do_softirq+0x20c/0x48c

Fixes: ceed73a2cf4a ("drivers: net: ethernet: qualcomm: rmnet: Initial implementation")
Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Link: https://lore.kernel.org/r/1605298325-3705-1-git-send-email-subashab@codeaurora.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -188,6 +188,11 @@ rx_handler_result_t rmnet_rx_handler(str
 
 	dev = skb->dev;
 	port = rmnet_get_port_rcu(dev);
+	if (unlikely(!port)) {
+		atomic_long_inc(&skb->dev->rx_nohandler);
+		kfree_skb(skb);
+		goto done;
+	}
 
 	switch (port->rmnet_mode) {
 	case RMNET_EPMODE_VND:


