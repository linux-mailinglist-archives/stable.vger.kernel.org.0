Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627213A6441
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbhFNLWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:22:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236055AbhFNLUK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 883DE61992;
        Mon, 14 Jun 2021 10:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667916;
        bh=QZXp/cKN5WhzPCysf7z0qlKymyI6A6qSwpLFuPMD6lQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NTwv1FSfgUXNb72LtC2LMFJQUDNN7YoYdkSCselIm6JfmT/YvANV5hFLsMpWVwXn9
         6wItEcTcpKtFwObkuejrTPIDkX/lgXa7QK0RDIfU9IGfxS++461o1kse8i1lqLsy5+
         ZJ4AIFyhRY/exI0N6YR7pcCdD/6FWwtl9tYOtbj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aswath Govindraju <a-govindraju@ti.com>,
        Sanket Parmar <sparmar@cadence.com>,
        Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 5.12 124/173] usb: cdns3: Enable TDL_CHK only for OUT ep
Date:   Mon, 14 Jun 2021 12:27:36 +0200
Message-Id: <20210614102702.298119408@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sanket Parmar <sparmar@cadence.com>

commit d6eef886903c4bb5af41b9a31d4ba11dc7a6f8e8 upstream.

ZLP gets stuck if TDL_CHK bit is set and TDL_FROM_TRB is used
as TDL source for IN endpoints. To fix it, TDL_CHK is only
enabled for OUT endpoints.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Reported-by: Aswath Govindraju <a-govindraju@ti.com>
Signed-off-by: Sanket Parmar <sparmar@cadence.com>
Link: https://lore.kernel.org/r/1621263912-13175-1-git-send-email-sparmar@cadence.com
Signed-off-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-gadget.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -2006,7 +2006,7 @@ static void cdns3_configure_dmult(struct
 		else
 			mask = BIT(priv_ep->num);
 
-		if (priv_ep->type != USB_ENDPOINT_XFER_ISOC) {
+		if (priv_ep->type != USB_ENDPOINT_XFER_ISOC  && !priv_ep->dir) {
 			cdns3_set_register_bit(&regs->tdl_from_trb, mask);
 			cdns3_set_register_bit(&regs->tdl_beh, mask);
 			cdns3_set_register_bit(&regs->tdl_beh2, mask);
@@ -2045,15 +2045,13 @@ int cdns3_ep_config(struct cdns3_endpoin
 	case USB_ENDPOINT_XFER_INT:
 		ep_cfg = EP_CFG_EPTYPE(USB_ENDPOINT_XFER_INT);
 
-		if ((priv_dev->dev_ver == DEV_VER_V2 && !priv_ep->dir) ||
-		    priv_dev->dev_ver > DEV_VER_V2)
+		if (priv_dev->dev_ver >= DEV_VER_V2 && !priv_ep->dir)
 			ep_cfg |= EP_CFG_TDL_CHK;
 		break;
 	case USB_ENDPOINT_XFER_BULK:
 		ep_cfg = EP_CFG_EPTYPE(USB_ENDPOINT_XFER_BULK);
 
-		if ((priv_dev->dev_ver == DEV_VER_V2  && !priv_ep->dir) ||
-		    priv_dev->dev_ver > DEV_VER_V2)
+		if (priv_dev->dev_ver >= DEV_VER_V2 && !priv_ep->dir)
 			ep_cfg |= EP_CFG_TDL_CHK;
 		break;
 	default:


