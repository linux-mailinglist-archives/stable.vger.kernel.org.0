Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739564832AD
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbiACOaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:30:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60140 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233950AbiACO2t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:28:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12A88B80EF8;
        Mon,  3 Jan 2022 14:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46425C36AED;
        Mon,  3 Jan 2022 14:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220126;
        bh=DcEoLIOeKHLVIZWfoAdonwiWILIcJmFCb6nMri3I/xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bfk2FVQH7R2rJd9oX+5I1INXqiT4uYa+uFYv+1u4XBPcA1kC07XJ5bEOfTXukYgTl
         +XS8qpLgaGx+ic+e87BylHW63Wh8T7sVHuOMnHgYiRytcpXA32AkdbwyrohG3JoTZv
         J5aLcuG5DuQTx/YLSYeKiCn0IbdLHHPRqTcfVo6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias-Christian Ott <ott@mirix.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 19/48] net: usb: pegasus: Do not drop long Ethernet frames
Date:   Mon,  3 Jan 2022 15:23:56 +0100
Message-Id: <20220103142054.128694915@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142053.466768714@linuxfoundation.org>
References: <20220103142053.466768714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias-Christian Ott <ott@mirix.org>

[ Upstream commit ca506fca461b260ab32952b610c3d4aadc6c11fd ]

The D-Link DSB-650TX (2001:4002) is unable to receive Ethernet frames
that are longer than 1518 octets, for example, Ethernet frames that
contain 802.1Q VLAN tags.

The frames are sent to the pegasus driver via USB but the driver
discards them because they have the Long_pkt field set to 1 in the
received status report. The function read_bulk_callback of the pegasus
driver treats such received "packets" (in the terminology of the
hardware) as errors but the field simply does just indicate that the
Ethernet frame (MAC destination to FCS) is longer than 1518 octets.

It seems that in the 1990s there was a distinction between
"giant" (> 1518) and "runt" (< 64) frames and the hardware includes
flags to indicate this distinction. It seems that the purpose of the
distinction "giant" frames was to not allow infinitely long frames due
to transmission errors and to allow hardware to have an upper limit of
the frame size. However, the hardware already has such limit with its
2048 octet receive buffer and, therefore, Long_pkt is merely a
convention and should not be treated as a receive error.

Actually, the hardware is even able to receive Ethernet frames with 2048
octets which exceeds the claimed limit frame size limit of the driver of
1536 octets (PEGASUS_MTU).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Matthias-Christian Ott <ott@mirix.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/pegasus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 2a748a924f838..138279bbb544b 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -518,11 +518,11 @@ static void read_bulk_callback(struct urb *urb)
 		goto goon;
 
 	rx_status = buf[count - 2];
-	if (rx_status & 0x1e) {
+	if (rx_status & 0x1c) {
 		netif_dbg(pegasus, rx_err, net,
 			  "RX packet error %x\n", rx_status);
 		net->stats.rx_errors++;
-		if (rx_status & 0x06)	/* long or runt	*/
+		if (rx_status & 0x04)	/* runt	*/
 			net->stats.rx_length_errors++;
 		if (rx_status & 0x08)
 			net->stats.rx_crc_errors++;
-- 
2.34.1



