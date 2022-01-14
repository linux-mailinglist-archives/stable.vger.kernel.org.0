Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84BC48E60C
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237866AbiANIW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240317AbiANIVf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:21:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36554C061751;
        Fri, 14 Jan 2022 00:21:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8B8761E36;
        Fri, 14 Jan 2022 08:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC93C36AE9;
        Fri, 14 Jan 2022 08:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148490;
        bh=jlGfr1kFuovHKauLgNuqptQsEupk2mZKFS8sVqP2bqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AbSk4VUukJS2n6hwUhOnpf2EZSkF/olw7MUOYOdQFezEEEKL0FokEmjTD7Sd9U0ZZ
         ogBnZCYi6uIjvWyscqzKwrgEvRALg71GkrfIr69vXAPLODBZiVEwN6cMAboNiDz43F
         wzCOwMGgwqzmgiwTs5qRncvw08xLQRgIrqxpE9LU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Brian Silverman <brian.silverman@bluerivertech.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 33/41] can: gs_usb: gs_can_start_xmit(): zero-initialize hf->{flags,reserved}
Date:   Fri, 14 Jan 2022 09:16:33 +0100
Message-Id: <20220114081546.268378329@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081545.158363487@linuxfoundation.org>
References: <20220114081545.158363487@linuxfoundation.org>
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
@@ -508,6 +508,8 @@ static netdev_tx_t gs_can_start_xmit(str
 
 	hf->echo_id = idx;
 	hf->channel = dev->channel;
+	hf->flags = 0;
+	hf->reserved = 0;
 
 	cf = (struct can_frame *)skb->data;
 


