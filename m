Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5242ABD55
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730169AbgKIM6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 07:58:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:52876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730158AbgKIM6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 07:58:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18C9320789;
        Mon,  9 Nov 2020 12:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926719;
        bh=kOandtB1ZMev2Spg8KASy1z02WsLM2ai2Cy10DWXrx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R6QHAwXBge6T/ti3YMExfezJlPpBcoMa/ox5BH7OaFSg4NMSMqbi3UMrokIlmhuQw
         DTm9EeJjR9ayZpp4RDvBaETcd2aLgc9+D56udGxqZHaEWhoZOB8i9bykYDgQRlzsTy
         jLGxUlN83GU9BStlnfcd4lpKdDrSJ7gmn7Yvv7jA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Jurack <james.jurack@ametek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.4 67/86] gianfar: Account for Tx PTP timestamp in the skb headroom
Date:   Mon,  9 Nov 2020 13:55:14 +0100
Message-Id: <20201109125023.994044097@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125020.852643676@linuxfoundation.org>
References: <20201109125020.852643676@linuxfoundation.org>
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
@@ -1385,7 +1385,7 @@ static int gfar_probe(struct platform_de
 
 	if (dev->features & NETIF_F_IP_CSUM ||
 	    priv->device_flags & FSL_GIANFAR_DEV_HAS_TIMER)
-		dev->needed_headroom = GMAC_FCB_LEN;
+		dev->needed_headroom = GMAC_FCB_LEN + GMAC_TXPAL_LEN;
 
 	/* Initializing some of the rx/tx queue level parameters */
 	for (i = 0; i < priv->num_tx_queues; i++) {


