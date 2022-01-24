Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19FE498BB7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345010AbiAXTPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:15:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43500 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344337AbiAXTOD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:14:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F147960BB9;
        Mon, 24 Jan 2022 19:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E208C36AE3;
        Mon, 24 Jan 2022 19:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051642;
        bh=28t1sweoB4qHEe4T76xab8j4fhECdC4c7ySIQE2cgDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e+Qtbu8CBTTVxA0q10fGAzfb0SBEGFvIeukKCD1wdr+1rf4KFD6N3RX/xzcvCG7Ed
         lZ28s0mwFnEoZbBc4aXuhWlLW48urr2GGiV7sSeiwDzLR7bc0VQ8sq2pA0Y512BEhL
         mnvkiVbHPHvn0Z4IUvnYrf/cs4KrX//okKdw/Tt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Brian Silverman <brian.silverman@bluerivertech.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.19 008/239] can: gs_usb: gs_can_start_xmit(): zero-initialize hf->{flags,reserved}
Date:   Mon, 24 Jan 2022 19:40:46 +0100
Message-Id: <20220124183943.377652679@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Silverman <brian.silverman@bluerivertech.com>

commit 89d58aebe14a365c25ba6645414afdbf4e41cea4 upstream.

No information is deliberately sent in hf->flags in host -> device
communications, but the open-source candleLight firmware echoes it
back, which can result in the GS_CAN_FLAG_OVERFLOW flag being set and
generating spurious ERRORFRAMEs.

While there also initialize the reserved member with 0.

Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Link: https://lore.kernel.org/all/20220106002952.25883-1-brian.silverman@bluerivertech.com
Link: https://github.com/candle-usb/candleLight_fw/issues/87
Cc: stable@vger.kernel.org
Signed-off-by: Brian Silverman <brian.silverman@bluerivertech.com>
[mkl: initialize the reserved member, too]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/gs_usb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -515,6 +515,8 @@ static netdev_tx_t gs_can_start_xmit(str
 
 	hf->echo_id = idx;
 	hf->channel = dev->channel;
+	hf->flags = 0;
+	hf->reserved = 0;
 
 	cf = (struct can_frame *)skb->data;
 


