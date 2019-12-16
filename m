Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D078E1217E4
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbfLPSDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:03:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:39914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729256AbfLPSDR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:03:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3DA0207FF;
        Mon, 16 Dec 2019 18:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519397;
        bh=U+Zy8WDW51twCqB13+h4TM2bIhnae75Z5rp9vowzhX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2LNTlPsCvMey0gLdjRtC6K5DRTbZqjyxWQEGs3zxmNyxdTWIL1iN+EFkhNI4HhPMA
         w/ENLHlSelYzsRQPHvJ4rC8j37fLXdL0Hju5+Z5x0G3e1DB5v9axfg9M3VW4QcGqEH
         8iN+vzzzK2hGGIMyWhRPMKlQfE40Rpq4DVVVXdII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tilman Schmidt <tilman@imap.cc>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 012/140] staging: gigaset: fix illegal free on probe errors
Date:   Mon, 16 Dec 2019 18:48:00 +0100
Message-Id: <20191216174753.117607514@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
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
 drivers/isdn/gigaset/usb-gigaset.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/isdn/gigaset/usb-gigaset.c
+++ b/drivers/isdn/gigaset/usb-gigaset.c
@@ -574,8 +574,7 @@ static int gigaset_initcshw(struct cards
 {
 	struct usb_cardstate *ucs;
 
-	cs->hw.usb = ucs =
-		kmalloc(sizeof(struct usb_cardstate), GFP_KERNEL);
+	cs->hw.usb = ucs = kzalloc(sizeof(struct usb_cardstate), GFP_KERNEL);
 	if (!ucs) {
 		pr_err("out of memory\n");
 		return -ENOMEM;
@@ -587,9 +586,6 @@ static int gigaset_initcshw(struct cards
 	ucs->bchars[3] = 0;
 	ucs->bchars[4] = 0x11;
 	ucs->bchars[5] = 0x13;
-	ucs->bulk_out_buffer = NULL;
-	ucs->bulk_out_urb = NULL;
-	ucs->read_urb = NULL;
 	tasklet_init(&cs->write_tasklet,
 		     gigaset_modem_fill, (unsigned long) cs);
 


