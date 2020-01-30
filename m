Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16C2714E167
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730782AbgA3SoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:44:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:53168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730747AbgA3SoJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:44:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CA69205F4;
        Thu, 30 Jan 2020 18:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409849;
        bh=vLl1+z6hqSi6GBnz1nn3dYlO3YxHBtltxog8ULeao+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GF/SgxRUfudmheeUDcPxkDEird7+8cVuX9UP8IENeFRTXp/c7XgE2K/8RvQB8iUIs
         VMKWEQab3pnemUGSRvRQw3ChzGgiaWOto9HzOmiK1JytNmjWpbGd6hk0ZxvpKgZzcA
         64qRtprSeyUD/b1t/6Ux2Bh+axQ0u+MXTTgniKHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 006/110] USB: serial: ir-usb: add missing endpoint sanity check
Date:   Thu, 30 Jan 2020 19:37:42 +0100
Message-Id: <20200130183614.848488156@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 2988a8ae7476fe9535ab620320790d1714bdad1d upstream.

Add missing endpoint sanity check to avoid dereferencing a NULL-pointer
on open() in case a device lacks a bulk-out endpoint.

Note that prior to commit f4a4cbb2047e ("USB: ir-usb: reimplement using
generic framework") the oops would instead happen on open() if the
device lacked a bulk-in endpoint and on write() if it lacked a bulk-out
endpoint.

Fixes: f4a4cbb2047e ("USB: ir-usb: reimplement using generic framework")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ir-usb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/ir-usb.c
+++ b/drivers/usb/serial/ir-usb.c
@@ -195,6 +195,9 @@ static int ir_startup(struct usb_serial
 	struct usb_irda_cs_descriptor *irda_desc;
 	int rates;
 
+	if (serial->num_bulk_in < 1 || serial->num_bulk_out < 1)
+		return -ENODEV;
+
 	irda_desc = irda_usb_find_class_desc(serial, 0);
 	if (!irda_desc) {
 		dev_err(&serial->dev->dev,


