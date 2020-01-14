Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7132B13A623
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729893AbgANKJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:09:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:42638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729605AbgANKJh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:09:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5D0424676;
        Tue, 14 Jan 2020 10:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996577;
        bh=JwV7d1BbX+/9gDwxCu7WXxNWnznGLGCuF71qbgZ6FdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cT6hBdCUb9fNfikNsZ0MlKhHxzUFqTWDFECBMZDDM7xeVtVMWHzyYz5TYerSYoRrv
         v5/TSIGAegHnCrkrILIcajM2EKW71XAegkRUUAFhViIWXncVFmZHQXydVkQaKZ/KMj
         S27JXTLrANkEBAX7BGu0LdMJEARG/nBq/FxoDH2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Bin Liu <b-liu@ti.com>
Subject: [PATCH 4.14 18/39] usb: musb: Disable pullup at init
Date:   Tue, 14 Jan 2020 11:01:52 +0100
Message-Id: <20200114094343.179143771@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094336.210038037@linuxfoundation.org>
References: <20200114094336.210038037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit 96a0c12843109e5c4d5eb1e09d915fdd0ce31d25 upstream.

The pullup may be already enabled before the driver is initialized. This
happens for instance on JZ4740.

It has to be disabled at init time, as we cannot guarantee that a gadget
driver will be bound to the UDC.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Suggested-by: Bin Liu <b-liu@ti.com>
Cc: stable@vger.kernel.org
Signed-off-by: Bin Liu <b-liu@ti.com>
Link: https://lore.kernel.org/r/20200107152625.857-3-b-liu@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/musb_core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -2328,6 +2328,9 @@ musb_init_controller(struct device *dev,
 	musb_disable_interrupts(musb);
 	musb_writeb(musb->mregs, MUSB_DEVCTL, 0);
 
+	/* MUSB_POWER_SOFTCONN might be already set, JZ4740 does this. */
+	musb_writeb(musb->mregs, MUSB_POWER, 0);
+
 	/* Init IRQ workqueue before request_irq */
 	INIT_DELAYED_WORK(&musb->irq_work, musb_irq_work);
 	INIT_DELAYED_WORK(&musb->deassert_reset_work, musb_deassert_reset);


