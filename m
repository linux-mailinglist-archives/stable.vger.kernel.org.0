Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7872B483267
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbiACO1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:27:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbiACO0n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:26:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A12C061A32;
        Mon,  3 Jan 2022 06:26:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D250BCE110C;
        Mon,  3 Jan 2022 14:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1BFC36AEB;
        Mon,  3 Jan 2022 14:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219999;
        bh=W9ISIOUD7SyTTF9FdoaLgIB5PWBiYhZ1tKKPILimUG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rn3JTXlPuuBXZ1KU6Ysmw1d8l/dmZZh0wqLdtBN3QuZPah1dKRbqVTO58+qMuya/L
         5DBv/1uucENv+WL0SiaBqk7i7MKszQ86CVG/MFxS1P39IpHSaUh47Ka2jrQW5i+Fqh
         8BpnqkRDVQEKXZBIeU5yUTp4oTRbpDxSoLp1gbnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias-Christian Ott <ott@mirix.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 16/37] net: usb: pegasus: Do not drop long Ethernet frames
Date:   Mon,  3 Jan 2022 15:23:54 +0100
Message-Id: <20220103142052.382380790@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142051.883166998@linuxfoundation.org>
References: <20220103142051.883166998@linuxfoundation.org>
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
index b744c09346a7c..dda051c94fb4d 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -495,11 +495,11 @@ static void read_bulk_callback(struct urb *urb)
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



