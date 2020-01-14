Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A65F113A66D
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732452AbgANKL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:11:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:46578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731618AbgANKL1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:11:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6097C20678;
        Tue, 14 Jan 2020 10:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996686;
        bh=cjlnCtikVhdsPP03FSvBdeIWwsBF8I4ietu7C61I0N8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PVZb/cOnIMoXzYmjkR2C3ZvUCALNSjumufQsE+g9wm1RBvBBjEGLrufXa/ss2vX54
         8f74eaZZo8IrAg6e3m9Yg+uNwI/d0eqQb5LgbQL1CQ7FKBijxVyTwxkFxobIvIQX6H
         rgcNHW/AhC8LfK5uwDedthvITXIe7la+PPGf1878=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Artur Rojek <contact@artur-rojek.eu>, Bin Liu <b-liu@ti.com>
Subject: [PATCH 4.9 20/31] usb: musb: dma: Correct parameter passed to IRQ handler
Date:   Tue, 14 Jan 2020 11:02:12 +0100
Message-Id: <20200114094343.709242477@linuxfoundation.org>
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

commit c80d0f4426c7fdc7efd6ae8d8b021dcfc89b4254 upstream.

The IRQ handler was passed a pointer to a struct dma_controller, but the
argument was then casted to a pointer to a struct musb_dma_controller.

Fixes: 427c4f333474 ("usb: struct device - replace bus_id with dev_name(), dev_set_name()")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Tested-by: Artur Rojek <contact@artur-rojek.eu>
Cc: stable@vger.kernel.org
Signed-off-by: Bin Liu <b-liu@ti.com>
Link: https://lore.kernel.org/r/20191216161844.772-2-b-liu@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/musbhsdma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/musb/musbhsdma.c
+++ b/drivers/usb/musb/musbhsdma.c
@@ -399,7 +399,7 @@ struct dma_controller *musbhs_dma_contro
 	controller->controller.channel_abort = dma_channel_abort;
 
 	if (request_irq(irq, dma_controller_irq, 0,
-			dev_name(musb->controller), &controller->controller)) {
+			dev_name(musb->controller), controller)) {
 		dev_err(dev, "request_irq %d failed!\n", irq);
 		musb_dma_controller_destroy(&controller->controller);
 


