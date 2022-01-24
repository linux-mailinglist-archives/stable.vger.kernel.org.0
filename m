Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8CC498ADB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242637AbiAXTH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346259AbiAXTFO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:05:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB40C0613EF;
        Mon, 24 Jan 2022 11:01:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EAA1B81215;
        Mon, 24 Jan 2022 19:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58EDCC340E5;
        Mon, 24 Jan 2022 19:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050857;
        bh=32uOvvkf5PwtZBQ1zKQge2AigcWs01gd5KpLT3qG+qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iDScEU6juax4DqtQ9EK38rAhRgiwpp6908atMOQwgfeMmkhiMJ4hgKkZn/hXG25j1
         UrQcXES4k8KgaTgPmhXp5gaUw4HARzpVHzRbMtAvFjcNlOn8IgFP9onrDHVRqgwlPp
         reIMGJnVtiDkN4rU14pV2YZii6rSz5QbvdHz6ap8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 134/157] net: axienet: Wait for PhyRstCmplt after core reset
Date:   Mon, 24 Jan 2022 19:43:44 +0100
Message-Id: <20220124183937.028790889@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

commit b400c2f4f4c53c86594dd57098970d97d488bfde upstream.

When resetting the device, wait for the PhyRstCmplt bit to be set
in the interrupt status register before continuing initialization, to
ensure that the core is actually ready. When using an external PHY, this
also ensures we do not start trying to access the PHY while it is still
in reset. The PHY reset is initiated by the core reset which is
triggered just above, but remains asserted for 5ms after the core is
reset according to the documentation.

The MgtRdy bit could also be waited for, but unfortunately when using
7-series devices, the bit does not appear to work as documented (it
seems to behave as some sort of link state indication and not just an
indication the transceiver is ready) so it can't really be relied on for
this purpose.

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -278,6 +278,16 @@ static int axienet_dma_bd_init(struct ne
 	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET,
 			  cr | XAXIDMA_CR_RUNSTOP_MASK);
 
+	/* Wait for PhyRstCmplt bit to be set, indicating the PHY reset has finished */
+	ret = read_poll_timeout(axienet_ior, value,
+				value & XAE_INT_PHYRSTCMPLT_MASK,
+				DELAY_OF_ONE_MILLISEC, 50000, false, lp,
+				XAE_IS_OFFSET);
+	if (ret) {
+		dev_err(lp->dev, "%s: timeout waiting for PhyRstCmplt\n", __func__);
+		return ret;
+	}
+
 	return 0;
 out:
 	axienet_dma_bd_release(ndev);


