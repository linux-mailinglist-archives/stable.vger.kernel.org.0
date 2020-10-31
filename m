Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10042A1661
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgJaLo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:44:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727811AbgJaLo4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:44:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B99592074F;
        Sat, 31 Oct 2020 11:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144696;
        bh=WeHnhktlaLP40UbvEfH3d86BOIfU0gD+BrC+KSdjyrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DLEopV65oVu3FhzKN58gi619l54f24ALdQDG8q1erpCnE9g1uRpZu3K9ysZY6Ecnr
         cBv3HS6DEzdXLAc0hEquxHNJL9v4IKtQ/OVXDKdMvXGcZYoBMSC9+JMhwCczsMTmN1
         kHJ5qO7KDvbWzu7Bp1PgtZ0f0hoJu9GV44F+X1lc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julia Lawall <julia.lawall@inria.fr>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 46/74] ravb: Fix bit fields checking in ravb_hwtstamp_get()
Date:   Sat, 31 Oct 2020 12:36:28 +0100
Message-Id: <20201031113502.253289737@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
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
@@ -1747,12 +1747,16 @@ static int ravb_hwtstamp_get(struct net_
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


