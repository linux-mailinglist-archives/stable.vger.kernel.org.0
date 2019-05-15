Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28ABF1F3D7
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbfEOLA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:00:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727564AbfEOLA4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:00:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 357AB21743;
        Wed, 15 May 2019 11:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918055;
        bh=TRquG3RLKPEL7QWXdp2ChQjNqiQnwglD5+M20SN+v34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W/9Fsh76XqQR6B1zENLV1e5geZDl1HaUzurF8KSaBcq740ZLWQsw0tJ+KgfUNT+xa
         Uf4hyxYZK/27Qk1qrS50Iyk7zGGig76sxNcukBsjJr4v464m6eWy5ri6C90CeWFDSV
         utvXX/eNp2E7qzoEFWDLhLw27ipbb87jLMk7Zgko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 3.18 76/86] USB: serial: use variable for status
Date:   Wed, 15 May 2019 12:55:53 +0200
Message-Id: <20190515090655.472717758@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090642.339346723@linuxfoundation.org>
References: <20190515090642.339346723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3161da970d38cd6ed2ba8cadec93874d1d06e11e ]

This patch turns status in a variable read once from the URB.
The long term plan is to deliver status to the callback.
In addition it makes the code a bit more elegant.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/generic.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index c44b911937e8d..a648fdca938a2 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -350,6 +350,7 @@ void usb_serial_generic_read_bulk_callback(struct urb *urb)
 	struct usb_serial_port *port = urb->context;
 	unsigned char *data = urb->transfer_buffer;
 	unsigned long flags;
+	int status = urb->status;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(port->read_urbs); ++i) {
@@ -360,22 +361,22 @@ void usb_serial_generic_read_bulk_callback(struct urb *urb)
 
 	dev_dbg(&port->dev, "%s - urb %d, len %d\n", __func__, i,
 							urb->actual_length);
-	switch (urb->status) {
+	switch (status) {
 	case 0:
 		break;
 	case -ENOENT:
 	case -ECONNRESET:
 	case -ESHUTDOWN:
 		dev_dbg(&port->dev, "%s - urb stopped: %d\n",
-							__func__, urb->status);
+							__func__, status);
 		return;
 	case -EPIPE:
 		dev_err(&port->dev, "%s - urb stopped: %d\n",
-							__func__, urb->status);
+							__func__, status);
 		return;
 	default:
 		dev_dbg(&port->dev, "%s - nonzero urb status: %d\n",
-							__func__, urb->status);
+							__func__, status);
 		goto resubmit;
 	}
 
@@ -399,6 +400,7 @@ void usb_serial_generic_write_bulk_callback(struct urb *urb)
 {
 	unsigned long flags;
 	struct usb_serial_port *port = urb->context;
+	int status = urb->status;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(port->write_urbs); ++i) {
@@ -410,22 +412,22 @@ void usb_serial_generic_write_bulk_callback(struct urb *urb)
 	set_bit(i, &port->write_urbs_free);
 	spin_unlock_irqrestore(&port->lock, flags);
 
-	switch (urb->status) {
+	switch (status) {
 	case 0:
 		break;
 	case -ENOENT:
 	case -ECONNRESET:
 	case -ESHUTDOWN:
 		dev_dbg(&port->dev, "%s - urb stopped: %d\n",
-							__func__, urb->status);
+							__func__, status);
 		return;
 	case -EPIPE:
 		dev_err_console(port, "%s - urb stopped: %d\n",
-							__func__, urb->status);
+							__func__, status);
 		return;
 	default:
 		dev_err_console(port, "%s - nonzero urb status: %d\n",
-							__func__, urb->status);
+							__func__, status);
 		goto resubmit;
 	}
 
-- 
2.20.1



