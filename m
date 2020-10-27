Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41AF629B247
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761206AbgJ0Oi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:38:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761219AbgJ0Oi1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:38:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB9D522258;
        Tue, 27 Oct 2020 14:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809507;
        bh=KwQVP6idZI3sOEzjKdmZNiIVexsuZ20Ywy6l5KikilY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zacvkPMzQeoHLe8lM+Dh944omzuMLoqCGYSN1zo59bjid4Ghh0V0d1b3fpDUMBpyE
         /TTbxhWzpfq+0y39vNaoljxN+7axHS3dHPzG1aQDCA2sJQmRIiD/Av7aipZf4ZdNeO
         i9q2NMQrywnz6il9q1vBlyzMUVvFhPyaWsc8trMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 180/408] usb: gadget: u_ether: enable qmult on SuperSpeed Plus as well
Date:   Tue, 27 Oct 2020 14:51:58 +0100
Message-Id: <20201027135503.448103081@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
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
index fbe96ef1ac7a4..891e9f7f40d59 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -93,7 +93,7 @@ struct eth_dev {
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



