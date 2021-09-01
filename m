Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447F23FD986
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 14:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244035AbhIAM13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:27:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244026AbhIAM12 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:27:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 732D660F92;
        Wed,  1 Sep 2021 12:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499192;
        bh=I/8/ZbWpVpbEdrVwOQYSSYv8537Th8fnrFZEP/HQ+Qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZN7/ZW4LJ3PKSI75up81qppvLSMCZMbVQAXnYLLhDokrqLUhy1889HHiOOA3KXIMg
         vWHor7IkXXT3TUk4rfQp9ij4khGQyy2SP6RC3ubzEQpuPnhpW45NiUqgqXmov6aYBj
         Xp4OnLeRDhmZpB0mNeAbCa+xnLd04ujI9nef5sBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.4 01/10] can: usb: esd_usb2: esd_usb2_rx_event(): fix the interchange of the CAN RX and TX error counters
Date:   Wed,  1 Sep 2021 14:26:15 +0200
Message-Id: <20210901122248.100559220@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122248.051808371@linuxfoundation.org>
References: <20210901122248.051808371@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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
@@ -236,8 +236,8 @@ static void esd_usb2_rx_event(struct esd
 	if (id == ESD_EV_CAN_ERROR_EXT) {
 		u8 state = msg->msg.rx.data[0];
 		u8 ecc = msg->msg.rx.data[1];
-		u8 txerr = msg->msg.rx.data[2];
-		u8 rxerr = msg->msg.rx.data[3];
+		u8 rxerr = msg->msg.rx.data[2];
+		u8 txerr = msg->msg.rx.data[3];
 
 		skb = alloc_can_err_skb(priv->netdev, &cf);
 		if (skb == NULL) {


