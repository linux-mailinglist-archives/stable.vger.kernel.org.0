Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA502AB9B8
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732467AbgKINMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:12:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:37460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732486AbgKINL4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:11:56 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47F9D20789;
        Mon,  9 Nov 2020 13:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927516;
        bh=yuge6QRf6RvfhBJUmZ5ayBd+aH00cFRHmxhCz2mWPXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=azVMy2svP/1+IL8rOf1O3uIMBIlKCNCOEgeN2lS85f/lx7AmxbjsuK50mKKThnxTz
         SRVO06iObmn/xE1/hHe2pvHN9WIOHhcD59cm5VRSqgX28DbVI7Y6DQbA4DKzev0Cf4
         8q6w4mpZTVzWiuRDvuie/FtZ+efNRqocnjzN1q6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Jurack <james.jurack@ametek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 15/85] gianfar: Account for Tx PTP timestamp in the skb headroom
Date:   Mon,  9 Nov 2020 13:55:12 +0100
Message-Id: <20201109125023.317126449@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>

[ Upstream commit d6a076d68c6b5d6a5800f3990a513facb7016dea ]

When PTP timestamping is enabled on Tx, the controller
inserts the Tx timestamp at the beginning of the frame
buffer, between SFD and the L2 frame header. This means
that the skb provided by the stack is required to have
enough headroom otherwise a new skb needs to be created
by the driver to accommodate the timestamp inserted by h/w.
Up until now the driver was relying on the second option,
using skb_realloc_headroom() to create a new skb to accommodate
PTP frames. Turns out that this method is not reliable, as
reallocation of skbs for PTP frames along with the required
overhead (skb_set_owner_w, consume_skb) is causing random
crashes in subsequent skb_*() calls, when multiple concurrent
TCP streams are run at the same time on the same device
(as seen in James' report).
Note that these crashes don't occur with a single TCP stream,
nor with multiple concurrent UDP streams, but only when multiple
TCP streams are run concurrently with the PTP packet flow
(doing skb reallocation).
This patch enforces the first method, by requesting enough
headroom from the stack to accommodate PTP frames, and so avoiding
skb_realloc_headroom() & co, and the crashes no longer occur.
There's no reason not to set needed_headroom to a large enough
value to accommodate PTP frames, so in this regard this patch
is a fix.

Reported-by: James Jurack <james.jurack@ametek.com>
Fixes: bee9e58c9e98 ("gianfar:don't add FCB length to hard_header_len")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Link: https://lore.kernel.org/r/20201020173605.1173-1-claudiu.manoil@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/gianfar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -3369,7 +3369,7 @@ static int gfar_probe(struct platform_de
 
 	if (dev->features & NETIF_F_IP_CSUM ||
 	    priv->device_flags & FSL_GIANFAR_DEV_HAS_TIMER)
-		dev->needed_headroom = GMAC_FCB_LEN;
+		dev->needed_headroom = GMAC_FCB_LEN + GMAC_TXPAL_LEN;
 
 	/* Initializing some of the rx/tx queue level parameters */
 	for (i = 0; i < priv->num_tx_queues; i++) {


