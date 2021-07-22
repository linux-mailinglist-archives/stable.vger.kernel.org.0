Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16383D28E1
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbhGVP7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:59:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233297AbhGVP6b (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:58:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F25C1613AA;
        Thu, 22 Jul 2021 16:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971946;
        bh=HZ2hCK24772BdC1XPK8ryMFfLupgbhwxHFtloaNIinU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NOBku04T07i8RHlauEfXR/bMn6i5+xQNxFIQOEfIOrU2Qshadir+uyiJMDIur4q5m
         2WB50NpAJcoE746wuIoJbFBlrMmwT7YLdmtMQPjp7DkG42vxeh64BiZvJXdDPh2K6s
         MkA3JT7fKi6FbuUVtR8Ifqe1Ls4YB25qqGVzh/FE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aswath Govindraju <a-govindraju@ti.com>,
        Sanket Parmar <sparmar@cadence.com>,
        Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 5.10 088/125] usb: cdns3: Enable TDL_CHK only for OUT ep
Date:   Thu, 22 Jul 2021 18:31:19 +0200
Message-Id: <20210722155627.611419075@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
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
 drivers/usb/cdns3/gadget.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
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


