Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 692CF101776
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730812AbfKSFoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:44:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:39382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730810AbfKSFoH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:44:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D4382075E;
        Tue, 19 Nov 2019 05:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142246;
        bh=P1FjpGRx03FnQqJWFKgSmYOTodXQiTL/vTeWA3+7KQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZE0K6kC4vLsGxmvzotpJon3ZInvNK5MRrB7w6JFmEQ71VjPybL3S9II5G8MVn8/Ox
         Win6P7+BOX8VGy4euUZWfpsmJtmvuArjrav/d9YAnuJwPVQeXrn9AYVrZz2hKoHx6z
         E2Moel1U+SpN00qrPwX1jsIS/CzF+oeXXzcyKqrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.14 017/239] Input: synaptics-rmi4 - clear IRQ enables for F54
Date:   Tue, 19 Nov 2019 06:16:57 +0100
Message-Id: <20191119051300.999187394@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

commit 549766ac2ac1f6c8bb85906bbcea759541bb19a2 upstream.

The driver for F54 just polls the status and doesn't even have a IRQ
handler registered. Make sure to disable all F54 IRQs, so we don't crash
the kernel on a nonexistent handler.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Link: https://lore.kernel.org/r/20191105114402.6009-1-l.stach@pengutronix.de
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/rmi4/rmi_f54.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/rmi4/rmi_f54.c
+++ b/drivers/input/rmi4/rmi_f54.c
@@ -619,7 +619,7 @@ static int rmi_f54_config(struct rmi_fun
 {
 	struct rmi_driver *drv = fn->rmi_dev->driver;
 
-	drv->set_irq_bits(fn->rmi_dev, fn->irq_mask);
+	drv->clear_irq_bits(fn->rmi_dev, fn->irq_mask);
 
 	return 0;
 }


