Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3DF29AE48
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 14:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1753156AbgJ0N6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 09:58:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753150AbgJ0N6j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 09:58:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8685B2072D;
        Tue, 27 Oct 2020 13:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807119;
        bh=fL/+WdbDyFdl/Fk6youU4FX5YvcA2hwU4Pl6/5DP41M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gBBeB+kPhurEt8o8Hq5GT882ulSeRRf/aaxZyJGdYTaU/jRO8PdLSVi1pTbsgnQwt
         miKEi3U1ZMY5Zt08j50Rx7WSkexxjGwH7bLSw9psmcaxX5rgns+6I3fhu7mqiIetE/
         gmOwX+LQg093TyXzgRvof/TYU9wDji2JKyOFLODA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 049/112] usb: gadget: u_ether: enable qmult on SuperSpeed Plus as well
Date:   Tue, 27 Oct 2020 14:49:19 +0100
Message-Id: <20201027134902.883085050@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Colitti <lorenzo@google.com>

[ Upstream commit 4eea21dc67b0c6ba15ae41b1defa113a680a858e ]

The u_ether driver has a qmult setting that multiplies the
transmit queue length (which by default is 2).

The intent is that it should be enabled at high/super speed, but
because the code does not explicitly check for USB_SUPER_PLUS,
it is disabled at that speed.

Fix this by ensuring that the queue multiplier is enabled for any
wired link at high speed or above. Using >= for USB_SPEED_*
constants seems correct because it is what the gadget_is_xxxspeed
functions do.

The queue multiplier substantially helps performance at higher
speeds. On a direct SuperSpeed Plus link to a Linux laptop,
iperf3 single TCP stream:

Before (qmult=1): 1.3 Gbps
After  (qmult=5): 3.2 Gbps

Fixes: 04617db7aa68 ("usb: gadget: add SS descriptors to Ethernet gadget")
Reviewed-by: Maciej Żenczykowski <maze@google.com>
Signed-off-by: Lorenzo Colitti <lorenzo@google.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/u_ether.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/u_ether.c b/drivers/usb/gadget/function/u_ether.c
index e69f20b2a3f44..46c50135ef9f7 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -96,7 +96,7 @@ struct eth_dev {
 static inline int qlen(struct usb_gadget *gadget, unsigned qmult)
 {
 	if (gadget_is_dualspeed(gadget) && (gadget->speed == USB_SPEED_HIGH ||
-					    gadget->speed == USB_SPEED_SUPER))
+					    gadget->speed >= USB_SPEED_SUPER))
 		return qmult * DEFAULT_QLEN;
 	else
 		return DEFAULT_QLEN;
-- 
2.25.1



