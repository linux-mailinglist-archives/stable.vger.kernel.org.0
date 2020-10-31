Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8809F2A158E
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgJaLfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:35:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbgJaLfr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:35:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF22C20791;
        Sat, 31 Oct 2020 11:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144147;
        bh=6SBh8zVV0znelh6YRk7fTPVve7Ihj0UtpV7z8FVnwrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2j2dhgbs4YkbCdLt6tw3QD9uIRanZd6Y44hmQrDFNRhPojBqr7rIKxLIEF79YL3p
         69LjC993J9mVvGC3uMTkmwmHSEt0Is1JUf45EMkdJshV1iBxnrN5Jv/grEFxgqvwa8
         /zaLjTaGx1/qFEzToRFMJgtZ7sTwFEAvd8DUb18U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julia Lawall <julia.lawall@inria.fr>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 22/49] ravb: Fix bit fields checking in ravb_hwtstamp_get()
Date:   Sat, 31 Oct 2020 12:35:18 +0100
Message-Id: <20201031113456.517150565@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113455.439684970@linuxfoundation.org>
References: <20201031113455.439684970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Gabbasov <andrew_gabbasov@mentor.com>

[ Upstream commit 68b9f0865b1ef545da180c57d54b82c94cb464a4 ]

In the function ravb_hwtstamp_get() in ravb_main.c with the existing
values for RAVB_RXTSTAMP_TYPE_V2_L2_EVENT (0x2) and RAVB_RXTSTAMP_TYPE_ALL
(0x6)

if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_V2_L2_EVENT)
	config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
else if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_ALL)
	config.rx_filter = HWTSTAMP_FILTER_ALL;

if the test on RAVB_RXTSTAMP_TYPE_ALL should be true,
it will never be reached.

This issue can be verified with 'hwtstamp_config' testing program
(tools/testing/selftests/net/hwtstamp_config.c). Setting filter type
to ALL and subsequent retrieving it gives incorrect value:

$ hwtstamp_config eth0 OFF ALL
flags = 0
tx_type = OFF
rx_filter = ALL
$ hwtstamp_config eth0
flags = 0
tx_type = OFF
rx_filter = PTP_V2_L2_EVENT

Correct this by converting if-else's to switch.

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Signed-off-by: Andrew Gabbasov <andrew_gabbasov@mentor.com>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
Link: https://lore.kernel.org/r/20201026102130.29368-1-andrew_gabbasov@mentor.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/renesas/ravb_main.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1741,12 +1741,16 @@ static int ravb_hwtstamp_get(struct net_
 	config.flags = 0;
 	config.tx_type = priv->tstamp_tx_ctrl ? HWTSTAMP_TX_ON :
 						HWTSTAMP_TX_OFF;
-	if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_V2_L2_EVENT)
+	switch (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE) {
+	case RAVB_RXTSTAMP_TYPE_V2_L2_EVENT:
 		config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
-	else if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_ALL)
+		break;
+	case RAVB_RXTSTAMP_TYPE_ALL:
 		config.rx_filter = HWTSTAMP_FILTER_ALL;
-	else
+		break;
+	default:
 		config.rx_filter = HWTSTAMP_FILTER_NONE;
+	}
 
 	return copy_to_user(req->ifr_data, &config, sizeof(config)) ?
 		-EFAULT : 0;


