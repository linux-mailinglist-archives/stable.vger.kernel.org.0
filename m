Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306B03FDB06
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344021AbhIAMhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:37:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344022AbhIAMfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:35:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AA2D6112E;
        Wed,  1 Sep 2021 12:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499597;
        bh=Ic/Ihy9eXVn6k6FBv6Ds/quKV3DMcpKvOsGlNAjXx64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mWhGL2PfuuKYIETHUcjVxNgYiwIqvzi2VvgkqLS/ykmGF+H2SsCTK3Y4VCWKDVEDS
         wYSH7GIBUaPMlNmuBD6yhHiOcIg75/qFwmnGJJxSPrLTjYaDtnhuzjUStR2NI7AKul
         1+klBBEohHhmRoozNpOziH6lJokEjcHQqi0eHbYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 012/103] can: usb: esd_usb2: esd_usb2_rx_event(): fix the interchange of the CAN RX and TX error counters
Date:   Wed,  1 Sep 2021 14:27:22 +0200
Message-Id: <20210901122300.946314524@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Mätje <stefan.maetje@esd.eu>

commit 044012b52029204900af9e4230263418427f4ba4 upstream.

This patch fixes the interchanged fetch of the CAN RX and TX error
counters from the ESD_EV_CAN_ERROR_EXT message. The RX error counter
is really in struct rx_msg::data[2] and the TX error counter is in
struct rx_msg::data[3].

Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
Link: https://lore.kernel.org/r/20210825215227.4947-2-stefan.maetje@esd.eu
Cc: stable@vger.kernel.org
Signed-off-by: Stefan Mätje <stefan.maetje@esd.eu>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/esd_usb2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -224,8 +224,8 @@ static void esd_usb2_rx_event(struct esd
 	if (id == ESD_EV_CAN_ERROR_EXT) {
 		u8 state = msg->msg.rx.data[0];
 		u8 ecc = msg->msg.rx.data[1];
-		u8 txerr = msg->msg.rx.data[2];
-		u8 rxerr = msg->msg.rx.data[3];
+		u8 rxerr = msg->msg.rx.data[2];
+		u8 txerr = msg->msg.rx.data[3];
 
 		skb = alloc_can_err_skb(priv->netdev, &cf);
 		if (skb == NULL) {


