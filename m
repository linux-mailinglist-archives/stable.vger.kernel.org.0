Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA2C41450AD
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733128AbgAVJkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:40:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:58448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733093AbgAVJkA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:40:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41EF724684;
        Wed, 22 Jan 2020 09:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685999;
        bh=8RETVQuAXn2HyyP19HzJkh3vyAlFaWvJzhqQrOIOj0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ee+8nND/zhhqPbdoSG4T6N43ACwHqO4yU6Twn6Akadd+OcPFMYMjXd37Qf/EhLv89
         pm5LB3Pje26i+UBaK4H/zXQkpeYFypQabEpJaq0PZ43v2z3aXNQRWjTrTwL04K+U0y
         qMmcV0M0jtBb6UsmGkJG4GNdZaTRu+BScOPiIBiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 32/65] USB: serial: io_edgeport: handle unbound ports on URB completion
Date:   Wed, 22 Jan 2020 10:29:17 +0100
Message-Id: <20200122092755.401719162@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092750.976732974@linuxfoundation.org>
References: <20200122092750.976732974@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit e37d1aeda737a20b1846a91a3da3f8b0f00cf690 ]

Check for NULL port data in the shared interrupt and bulk completion
callbacks to avoid dereferencing a NULL pointer in case a device sends
data for a port device which isn't bound to a driver (e.g. due to a
malicious device having unexpected endpoints or after an allocation
failure on port probe).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/io_edgeport.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index 8810de817095..3705b64ab948 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -720,7 +720,7 @@ static void edge_interrupt_callback(struct urb *urb)
 			if (txCredits) {
 				port = edge_serial->serial->port[portNumber];
 				edge_port = usb_get_serial_port_data(port);
-				if (edge_port->open) {
+				if (edge_port && edge_port->open) {
 					spin_lock_irqsave(&edge_port->ep_lock,
 							  flags);
 					edge_port->txCredits += txCredits;
@@ -1847,7 +1847,7 @@ static void process_rcvd_data(struct edgeport_serial *edge_serial,
 			if (rxLen && edge_serial->rxPort < serial->num_ports) {
 				port = serial->port[edge_serial->rxPort];
 				edge_port = usb_get_serial_port_data(port);
-				if (edge_port->open) {
+				if (edge_port && edge_port->open) {
 					dev_dbg(dev, "%s - Sending %d bytes to TTY for port %d\n",
 						__func__, rxLen,
 						edge_serial->rxPort);
-- 
2.20.1



