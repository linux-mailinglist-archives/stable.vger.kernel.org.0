Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF1A3E7E66
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbhHJRdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231822AbhHJRcs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:32:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F15F60F35;
        Tue, 10 Aug 2021 17:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616746;
        bh=ERX0QMlh4p07jgq2Pb5VAZYDdbT8+gREyoer7GZBAsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BR/F+WVTzifaV8kI6F7JGN4IRon/E7Q2LRS3kCo77QWXxfsHfSXlqpVe5tCjETv+7
         Kw40Jkop6+EJuNpE3Ms+Xos0RP29lhWJtAt2hI5L2IUnFEKBlBiS/stA+oMxNshQsP
         Rr0tnG7jXm4iyDZIa0zftFu+bWke8ZI5ORIZ/er0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Maxim Devaev <mdevaev@gmail.com>
Subject: [PATCH 4.19 28/54] usb: gadget: f_hid: added GET_IDLE and SET_IDLE handlers
Date:   Tue, 10 Aug 2021 19:30:22 +0200
Message-Id: <20210810172945.099464175@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
References: <20210810172944.179901509@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Devaev <mdevaev@gmail.com>

commit afcff6dc690e24d636a41fd4bee6057e7c70eebd upstream.

The USB HID standard declares mandatory support for GET_IDLE and SET_IDLE
requests for Boot Keyboard. Most hosts can handle their absence, but others
like some old/strange UEFIs and BIOSes consider this a critical error
and refuse to work with f_hid.

This primitive implementation of saving and returning idle is sufficient
to meet the requirements of the standard and these devices.

Acked-by: Felipe Balbi <balbi@kernel.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Maxim Devaev <mdevaev@gmail.com>
Link: https://lore.kernel.org/r/20210721180351.129450-1-mdevaev@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_hid.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -41,6 +41,7 @@ struct f_hidg {
 	unsigned char			bInterfaceSubClass;
 	unsigned char			bInterfaceProtocol;
 	unsigned char			protocol;
+	unsigned char			idle;
 	unsigned short			report_desc_length;
 	char				*report_desc;
 	unsigned short			report_length;
@@ -529,6 +530,14 @@ static int hidg_setup(struct usb_functio
 		goto respond;
 		break;
 
+	case ((USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE) << 8
+		  | HID_REQ_GET_IDLE):
+		VDBG(cdev, "get_idle\n");
+		length = min_t(unsigned int, length, 1);
+		((u8 *) req->buf)[0] = hidg->idle;
+		goto respond;
+		break;
+
 	case ((USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE) << 8
 		  | HID_REQ_SET_REPORT):
 		VDBG(cdev, "set_report | wLength=%d\n", ctrl->wLength);
@@ -552,6 +561,14 @@ static int hidg_setup(struct usb_functio
 		goto stall;
 		break;
 
+	case ((USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE) << 8
+		  | HID_REQ_SET_IDLE):
+		VDBG(cdev, "set_idle\n");
+		length = 0;
+		hidg->idle = value;
+		goto respond;
+		break;
+
 	case ((USB_DIR_IN | USB_TYPE_STANDARD | USB_RECIP_INTERFACE) << 8
 		  | USB_REQ_GET_DESCRIPTOR):
 		switch (value >> 8) {
@@ -779,6 +796,7 @@ static int hidg_bind(struct usb_configur
 	hidg_interface_desc.bInterfaceSubClass = hidg->bInterfaceSubClass;
 	hidg_interface_desc.bInterfaceProtocol = hidg->bInterfaceProtocol;
 	hidg->protocol = HID_REPORT_PROTOCOL;
+	hidg->idle = 1;
 	hidg_ss_in_ep_desc.wMaxPacketSize = cpu_to_le16(hidg->report_length);
 	hidg_ss_in_comp_desc.wBytesPerInterval =
 				cpu_to_le16(hidg->report_length);


