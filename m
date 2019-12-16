Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99F4B121641
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731208AbfLPSPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:15:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:36280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731362AbfLPSPY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:15:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83EFC206EC;
        Mon, 16 Dec 2019 18:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520123;
        bh=fpAEy/YlMC1GNufn/ZFQUk52cY7rvvFsflZbfotl9z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z66iI0iK7+TLPlq7nZr2vWsFmN83Hb9TQ/Xgx6kLSs8WJBAYYyaAO0HcfVQXv19e1
         +MuL3tl6VWHL7LJh6YPnCYh6frvoXWpNZfDi4/IB9P3SigXo+vknCTUkO8foM1phY9
         15YIhuB4a3m4OGndWsO5lDLOOTcPRsJAD4Lfr2HY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tilman Schmidt <tilman@imap.cc>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 025/177] staging: gigaset: fix illegal free on probe errors
Date:   Mon, 16 Dec 2019 18:48:01 +0100
Message-Id: <20191216174820.085000505@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 84f60ca7b326ed8c08582417493982fe2573a9ad upstream.

The driver failed to initialise its receive-buffer pointer, something
which could lead to an illegal free on late probe errors.

Fix this by making sure to clear all driver data at allocation.

Fixes: 2032e2c2309d ("usb_gigaset: code cleanup")
Cc: stable <stable@vger.kernel.org>     # 2.6.33
Cc: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191202085610.12719-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/isdn/gigaset/usb-gigaset.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/staging/isdn/gigaset/usb-gigaset.c
+++ b/drivers/staging/isdn/gigaset/usb-gigaset.c
@@ -571,8 +571,7 @@ static int gigaset_initcshw(struct cards
 {
 	struct usb_cardstate *ucs;
 
-	cs->hw.usb = ucs =
-		kmalloc(sizeof(struct usb_cardstate), GFP_KERNEL);
+	cs->hw.usb = ucs = kzalloc(sizeof(struct usb_cardstate), GFP_KERNEL);
 	if (!ucs) {
 		pr_err("out of memory\n");
 		return -ENOMEM;
@@ -584,9 +583,6 @@ static int gigaset_initcshw(struct cards
 	ucs->bchars[3] = 0;
 	ucs->bchars[4] = 0x11;
 	ucs->bchars[5] = 0x13;
-	ucs->bulk_out_buffer = NULL;
-	ucs->bulk_out_urb = NULL;
-	ucs->read_urb = NULL;
 	tasklet_init(&cs->write_tasklet,
 		     gigaset_modem_fill, (unsigned long) cs);
 


