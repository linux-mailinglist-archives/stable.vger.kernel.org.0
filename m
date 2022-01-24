Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C90449889C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245275AbiAXSsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:48:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47516 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245301AbiAXSsh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:48:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1F43614CF;
        Mon, 24 Jan 2022 18:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B0FC340E5;
        Mon, 24 Jan 2022 18:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050116;
        bh=zXZqooNsn6dotO0Osq4gZQFYjp/nmPUV2HQM6evi2vw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TysifGG6tEOtOVAj5GRQHun4Ca9P2CbluWEUnaP6u/HHG5ONumSRErajKrA509cM1
         rreOiy3yw8IqxEFCgRO9N97ayZPlV5t4TBbpBZ4gM272e5LxvOED4uVxSM6u+Ty39P
         ySFgjQzZi+urjWVOOOf5Oglh+UiW2wA+aaG7sbd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Brian Silverman <brian.silverman@bluerivertech.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.4 006/114] can: gs_usb: gs_can_start_xmit(): zero-initialize hf->{flags,reserved}
Date:   Mon, 24 Jan 2022 19:41:41 +0100
Message-Id: <20220124183927.297779769@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
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
@@ -491,6 +491,8 @@ static netdev_tx_t gs_can_start_xmit(str
 
 	hf->echo_id = idx;
 	hf->channel = dev->channel;
+	hf->flags = 0;
+	hf->reserved = 0;
 
 	cf = (struct can_frame *)skb->data;
 


