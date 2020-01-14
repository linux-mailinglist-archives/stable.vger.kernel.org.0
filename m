Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF09113A6DD
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729190AbgANKPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:15:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:46482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732469AbgANKLY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:11:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C706A24682;
        Tue, 14 Jan 2020 10:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996684;
        bh=fU+uoKOXpuBcf++EMnv2Fo9GfhZpAn5vxVCa+VZOIWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SoRf1YikQ6C8SZ5bIbprFJsRZ+36zpNpoL5Y1OVi63h1uSSRjfuBSJxtY3wzsQaEA
         vSqeOQ75RVwtkRf7IiG4r00Wyq6BdM5lb82PlpCLcQAX5uHXA2JwMUey1DtMqRbH3N
         DuXQ4j6W/EaLWCDoMo1Da1AzZkdR/699c2xXCPKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Bin Liu <b-liu@ti.com>
Subject: [PATCH 4.9 19/31] usb: musb: Disable pullup at init
Date:   Tue, 14 Jan 2020 11:02:11 +0100
Message-Id: <20200114094343.516551634@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094334.725604663@linuxfoundation.org>
References: <20200114094334.725604663@linuxfoundation.org>
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
@@ -2317,6 +2317,9 @@ musb_init_controller(struct device *dev,
 	musb_platform_disable(musb);
 	musb_generic_disable(musb);
 
+	/* MUSB_POWER_SOFTCONN might be already set, JZ4740 does this. */
+	musb_writeb(musb->mregs, MUSB_POWER, 0);
+
 	/* Init IRQ workqueue before request_irq */
 	INIT_DELAYED_WORK(&musb->irq_work, musb_irq_work);
 	INIT_DELAYED_WORK(&musb->deassert_reset_work, musb_deassert_reset);


