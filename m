Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504F14996DB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343608AbiAXVH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:07:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52752 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444838AbiAXVBi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:01:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21ED0611C8;
        Mon, 24 Jan 2022 21:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDA1C340E5;
        Mon, 24 Jan 2022 21:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058097;
        bh=YuuSrqYlWfqBWeMQ4MbvsTRyHLnB3n4XxO178j8t/cY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wTWlIEJHUj+SvR86COfrF5+QtM6FCY8NVkyYJvtfAIPSZ5IW00TUEtKV+DxJUJGX0
         X2BW5ridq/ZrGibioCzuFr4qizkkUfc0k3rkgyO4ymPRVp+9hQW9bvGpawyuCAQMeQ
         h2ohs/jRLrpH9pcRw1NRCXvUwgCkl9toF6aAqj0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0180/1039] net: dsa: rtl8365mb: set RGMII RX delay in steps of 0.3 ns
Date:   Mon, 24 Jan 2022 19:32:49 +0100
Message-Id: <20220124184131.329846146@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

[ Upstream commit ef136837aaf6f37f2dec78551671a6883f868d69 ]

A contact at Realtek has clarified what exactly the units of RGMII RX
delay are. The answer is that the unit of RX delay is "about 0.3 ns".
Take this into account when parsing rx-internal-delay-ps by
approximating the closest step value. Delays of more than 2.1 ns are
rejected.

This obviously contradicts the previous assumption in the driver that a
step value of 4 was "about 2 ns", but Realtek also points out that it is
easy to find more than one RX delay step value which makes RGMII work.

Fixes: 4af2950c50c8 ("net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-VC")
Cc: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Acked-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/rtl8365mb.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/rtl8365mb.c b/drivers/net/dsa/rtl8365mb.c
index 078ca4cd71605..48c0e3e466001 100644
--- a/drivers/net/dsa/rtl8365mb.c
+++ b/drivers/net/dsa/rtl8365mb.c
@@ -767,7 +767,8 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_smi *smi, int port,
 	 *     0 = no delay, 1 = 2 ns delay
 	 *   RX delay:
 	 *     0 = no delay, 7 = maximum delay
-	 *     No units are specified, but there are a total of 8 steps.
+	 *     Each step is approximately 0.3 ns, so the maximum delay is about
+	 *     2.1 ns.
 	 *
 	 * The vendor driver also states that this must be configured *before*
 	 * forcing the external interface into a particular mode, which is done
@@ -778,10 +779,6 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_smi *smi, int port,
 	 * specified. We ignore the detail of the RGMII interface mode
 	 * (RGMII_{RXID, TXID, etc.}), as this is considered to be a PHY-only
 	 * property.
-	 *
-	 * For the RX delay, we assume that a register value of 4 corresponds to
-	 * 2 ns. But this is just an educated guess, so ignore all other values
-	 * to avoid too much confusion.
 	 */
 	if (!of_property_read_u32(dn, "tx-internal-delay-ps", &val)) {
 		val = val / 1000; /* convert to ns */
@@ -794,13 +791,13 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_smi *smi, int port,
 	}
 
 	if (!of_property_read_u32(dn, "rx-internal-delay-ps", &val)) {
-		val = val / 1000; /* convert to ns */
+		val = DIV_ROUND_CLOSEST(val, 300); /* convert to 0.3 ns step */
 
-		if (val == 0 || val == 2)
-			rx_delay = val * 2;
+		if (val <= 7)
+			rx_delay = val;
 		else
 			dev_warn(smi->dev,
-				 "EXT port RX delay must be 0 to 2 ns\n");
+				 "EXT port RX delay must be 0 to 2.1 ns\n");
 	}
 
 	ret = regmap_update_bits(
-- 
2.34.1



