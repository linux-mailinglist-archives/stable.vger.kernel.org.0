Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFAB2C9BE3
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390041AbgLAJNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:13:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:51286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390031AbgLAJM6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:12:58 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF27F21D7A;
        Tue,  1 Dec 2020 09:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813937;
        bh=cIPVjtn4KT75hCzCf+nComspBooSr9eqyKayp4WK43I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f4OtfwiKLgVC1KuizSoj2dkamkcXxdKgmP9WJR6Xtd8SPgkYkZyIBR8RGXRBgbAnS
         TY79KMZt1T+MdHruoXqBd5M8K2pa8BQs70G+9wQQul8XxwhN2d366Nqy4stfbOmTHm
         mRBIY8DT+dAq89ynObpEMfK5a0/lfKEgOoymcnQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 081/152] usb: cdns3: gadget: calculate TD_SIZE based on TD
Date:   Tue,  1 Dec 2020 09:53:16 +0100
Message-Id: <20201201084722.520693959@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

[ Upstream commit 40252dd7cf7cad81c784c695c36bc475b518f0ea ]

The TRB entry TD_SIZE is the packet number for the TD (request) but not the
each TRB, so it only needs to be assigned for the first TRB during the TD,
and the value of it is for TD too.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/gadget.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index dc5e6be3fd45a..6af6343c7c65a 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -1170,10 +1170,20 @@ static int cdns3_ep_run_transfer(struct cdns3_endpoint *priv_ep,
 
 	/* set incorrect Cycle Bit for first trb*/
 	control = priv_ep->pcs ? 0 : TRB_CYCLE;
+	trb->length = 0;
+	if (priv_dev->dev_ver >= DEV_VER_V2) {
+		u16 td_size;
+
+		td_size = DIV_ROUND_UP(request->length,
+				       priv_ep->endpoint.maxpacket);
+		if (priv_dev->gadget.speed == USB_SPEED_SUPER)
+			trb->length = TRB_TDL_SS_SIZE(td_size);
+		else
+			control |= TRB_TDL_HS_SIZE(td_size);
+	}
 
 	do {
 		u32 length;
-		u16 td_size = 0;
 
 		/* fill TRB */
 		control |= TRB_TYPE(TRB_NORMAL);
@@ -1185,20 +1195,12 @@ static int cdns3_ep_run_transfer(struct cdns3_endpoint *priv_ep,
 		else
 			length = request->sg[sg_iter].length;
 
-		if (likely(priv_dev->dev_ver >= DEV_VER_V2))
-			td_size = DIV_ROUND_UP(length,
-					       priv_ep->endpoint.maxpacket);
-		else if (priv_ep->flags & EP_TDLCHK_EN)
+		if (priv_ep->flags & EP_TDLCHK_EN)
 			total_tdl += DIV_ROUND_UP(length,
 					       priv_ep->endpoint.maxpacket);
 
-		trb->length = cpu_to_le32(TRB_BURST_LEN(priv_ep->trb_burst_size) |
+		trb->length |= cpu_to_le32(TRB_BURST_LEN(priv_ep->trb_burst_size) |
 					TRB_LEN(length));
-		if (priv_dev->gadget.speed == USB_SPEED_SUPER)
-			trb->length |= cpu_to_le32(TRB_TDL_SS_SIZE(td_size));
-		else
-			control |= TRB_TDL_HS_SIZE(td_size);
-
 		pcs = priv_ep->pcs ? TRB_CYCLE : 0;
 
 		/*
-- 
2.27.0



