Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E41499E46
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355776AbiAXWbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584635AbiAXWVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:21:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD81C0424F8;
        Mon, 24 Jan 2022 12:52:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6470B811FB;
        Mon, 24 Jan 2022 20:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EB3C340E5;
        Mon, 24 Jan 2022 20:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057553;
        bh=uKxrKBwurW6KlaBqJxOapnKslZue1woeqqPggQ2Rh0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eFckwEfGnTpzRR2yX9uMNtL9rU79ozIQcwPMdEhuBBXdbM2mjDPxyJvZuSkJ53+rc
         pJdPOkw0gFNnPLpX4gacFWPFR+vQ0xciMItDgvpHDYgs70nYl1f3CNiGPOB9tx6/Z0
         q8+WWUsSt+D/pv/dRanOCwpuEdjkcfRdksLD+DwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 829/846] net: mscc: ocelot: dont let phylink re-enable TX PAUSE on the NPI port
Date:   Mon, 24 Jan 2022 19:45:46 +0100
Message-Id: <20220124184129.502096589@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 33cb0ff30cff104e753f7882c99e54cf67ea7903 upstream.

Since commit b39648079db4 ("net: mscc: ocelot: disable flow control on
NPI interface"), flow control should be disabled on the DSA CPU port
when used in NPI mode.

However, the commit blamed in the Fixes: tag below broke this, because
it allowed felix_phylink_mac_link_up() to overwrite SYS_PAUSE_CFG_PAUSE_ENA
for the DSA CPU port.

This issue became noticeable since the device tree update from commit
8fcea7be5736 ("arm64: dts: ls1028a: mark internal links between Felix
and ENETC as capable of flow control").

The solution is to check whether this is the currently configured NPI
port from ocelot_phylink_mac_link_up(), and to not modify the statically
disabled PAUSE frame transmission if it is.

When the port is configured for lossless mode as opposed to tail drop
mode, but the link partner (DSA master) doesn't observe the transmitted
PAUSE frames, the switch termination throughput is much worse, as can be
seen below.

Before:

root@debian:~# iperf3 -c 192.168.100.2
Connecting to host 192.168.100.2, port 5201
[  5] local 192.168.100.1 port 37504 connected to 192.168.100.2 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  28.4 MBytes   238 Mbits/sec  357   22.6 KBytes
[  5]   1.00-2.00   sec  33.6 MBytes   282 Mbits/sec  426   19.8 KBytes
[  5]   2.00-3.00   sec  34.0 MBytes   285 Mbits/sec  343   21.2 KBytes
[  5]   3.00-4.00   sec  32.9 MBytes   276 Mbits/sec  354   22.6 KBytes
[  5]   4.00-5.00   sec  32.3 MBytes   271 Mbits/sec  297   18.4 KBytes
^C[  5]   5.00-5.06   sec  2.05 MBytes   270 Mbits/sec   45   19.8 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-5.06   sec   163 MBytes   271 Mbits/sec  1822             sender
[  5]   0.00-5.06   sec  0.00 Bytes  0.00 bits/sec                  receiver

After:

root@debian:~# iperf3 -c 192.168.100.2
Connecting to host 192.168.100.2, port 5201
[  5] local 192.168.100.1 port 49470 connected to 192.168.100.2 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   112 MBytes   941 Mbits/sec  259    143 KBytes
[  5]   1.00-2.00   sec   110 MBytes   920 Mbits/sec  329    144 KBytes
[  5]   2.00-3.00   sec   112 MBytes   936 Mbits/sec  255    144 KBytes
[  5]   3.00-4.00   sec   110 MBytes   927 Mbits/sec  355    105 KBytes
[  5]   4.00-5.00   sec   110 MBytes   926 Mbits/sec  350    156 KBytes
[  5]   5.00-6.00   sec   110 MBytes   925 Mbits/sec  305    148 KBytes
[  5]   6.00-7.00   sec   110 MBytes   924 Mbits/sec  320    143 KBytes
[  5]   7.00-8.00   sec   110 MBytes   925 Mbits/sec  273   97.6 KBytes
[  5]   8.00-9.00   sec   109 MBytes   913 Mbits/sec  299    141 KBytes
[  5]   9.00-10.00  sec   110 MBytes   922 Mbits/sec  287    146 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.08 GBytes   926 Mbits/sec  3032             sender
[  5]   0.00-10.00  sec  1.08 GBytes   925 Mbits/sec                  receiver

Fixes: de274be32cb2 ("net: dsa: felix: set TX flow control according to the phylink_mac_link_up resolution")
Reported-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mscc/ocelot.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -555,7 +555,10 @@ void ocelot_phylink_mac_link_up(struct o
 
 	ocelot_write_rix(ocelot, 0, ANA_POL_FLOWC, port);
 
-	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, tx_pause);
+	/* Don't attempt to send PAUSE frames on the NPI port, it's broken */
+	if (port != ocelot->npi)
+		ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA,
+				    tx_pause);
 
 	/* Undo the effects of ocelot_phylink_mac_link_down:
 	 * enable MAC module


