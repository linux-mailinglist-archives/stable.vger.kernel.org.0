Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53330582D6C
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241154AbiG0Q5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241156AbiG0Q5K (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:57:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E74D65D7E;
        Wed, 27 Jul 2022 09:36:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B12F561ABC;
        Wed, 27 Jul 2022 16:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7EFC433C1;
        Wed, 27 Jul 2022 16:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939780;
        bh=/DE94iSpnRoKGxTdCHkKpVV3Z0O7VoGmiHYgXKyAVEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fIa/ee4nhwb0sccE4Q4N6MfrFrRsHEp7SK/SVtva8D2H7oJOERLlLzPG9shUrQMcN
         jq1Fx5dTe3uAIkt6+KoIRzaEoPPXTgdYrp2vXdtK0xeYfbNcCneSPYXYb5oAOM9eNz
         0IVinTZl21JCN0JD1UjnNHbbfBa7DdwNWaTfI9Q8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jose Alonso <joalonsof@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 102/105] net: usb: ax88179_178a needs FLAG_SEND_ZLP
Date:   Wed, 27 Jul 2022 18:11:28 +0200
Message-Id: <20220727161016.205108299@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jose Alonso <joalonsof@gmail.com>

commit 36a15e1cb134c0395261ba1940762703f778438c upstream.

The extra byte inserted by usbnet.c when
 (length % dev->maxpacket == 0) is causing problems to device.

This patch sets FLAG_SEND_ZLP to avoid this.

Tested with: 0b95:1790 ASIX Electronics Corp. AX88179 Gigabit Ethernet

Problems observed:
======================================================================
1) Using ssh/sshfs. The remote sshd daemon can abort with the message:
   "message authentication code incorrect"
   This happens because the tcp message sent is corrupted during the
   USB "Bulk out". The device calculate the tcp checksum and send a
   valid tcp message to the remote sshd. Then the encryption detects
   the error and aborts.
2) NETDEV WATCHDOG: ... (ax88179_178a): transmit queue 0 timed out
3) Stop normal work without any log message.
   The "Bulk in" continue receiving packets normally.
   The host sends "Bulk out" and the device responds with -ECONNRESET.
   (The netusb.c code tx_complete ignore -ECONNRESET)
Under normal conditions these errors take days to happen and in
intense usage take hours.

A test with ping gives packet loss, showing that something is wrong:
ping -4 -s 462 {destination}	# 462 = 512 - 42 - 8
Not all packets fail.
My guess is that the device tries to find another packet starting
at the extra byte and will fail or not depending on the next
bytes (old buffer content).
======================================================================

Signed-off-by: Jose Alonso <joalonsof@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ax88179_178a.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1796,7 +1796,7 @@ static const struct driver_info ax88179_
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1809,7 +1809,7 @@ static const struct driver_info ax88178a
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1822,7 +1822,7 @@ static const struct driver_info cypress_
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1835,7 +1835,7 @@ static const struct driver_info dlink_du
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1848,7 +1848,7 @@ static const struct driver_info sitecom_
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1861,7 +1861,7 @@ static const struct driver_info samsung_
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1874,7 +1874,7 @@ static const struct driver_info lenovo_i
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1887,7 +1887,7 @@ static const struct driver_info belkin_i
 	.link_reset = ax88179_link_reset,
 	.reset	= ax88179_reset,
 	.stop	= ax88179_stop,
-	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags	= FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1900,7 +1900,7 @@ static const struct driver_info toshiba_
 	.link_reset = ax88179_link_reset,
 	.reset	= ax88179_reset,
 	.stop = ax88179_stop,
-	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags	= FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1913,7 +1913,7 @@ static const struct driver_info mct_info
 	.link_reset = ax88179_link_reset,
 	.reset	= ax88179_reset,
 	.stop	= ax88179_stop,
-	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags	= FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };


