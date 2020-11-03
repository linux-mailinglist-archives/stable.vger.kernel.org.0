Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B2C2A58A2
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731520AbgKCVx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:53:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:35250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731152AbgKCUqL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:46:11 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1FDE223EA;
        Tue,  3 Nov 2020 20:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436371;
        bh=rbLD5qhuR3s16Kk5KifQ4op4H/krzoXrgx3FxIbsuL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TmSwvriDK7XUrCcCtNTvsz9aJHxCLJ5qeGv/P2x695gHe0qHNyfrqxf+U9BwhkB5X
         WfSbWcjG8iKkqvZ4onF/6tXiFTfpbMZNh8NG8EbjSwxhjdzlAMUrU6RtoNHHrYyaxu
         KnD0USC+6mpgPqcCz7htTTSSyxCLAOx87y1fUQ+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huacai Chen <chenhc@lemote.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.9 183/391] irqchip/loongson-htvec: Fix initial interrupt clearing
Date:   Tue,  3 Nov 2020 21:33:54 +0100
Message-Id: <20201103203359.233194998@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhc@lemote.com>

commit 1d1e5630de78f7253ac24b92cee6427c3ff04d56 upstream.

In htvec_reset() only the first group of initial interrupts is cleared.
This sometimes causes spurious interrupts, so let's clear all groups.

While at it, fix the nearby comment that to match the reality of what
the driver does.

Fixes: 818e915fbac518e8c78e1877 ("irqchip: Add Loongson HyperTransport Vector support")
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1599819978-13999-2-git-send-email-chenhc@lemote.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/irqchip/irq-loongson-htvec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/irqchip/irq-loongson-htvec.c
+++ b/drivers/irqchip/irq-loongson-htvec.c
@@ -151,7 +151,7 @@ static void htvec_reset(struct htvec *pr
 	/* Clear IRQ cause registers, mask all interrupts */
 	for (idx = 0; idx < priv->num_parents; idx++) {
 		writel_relaxed(0x0, priv->base + HTVEC_EN_OFF + 4 * idx);
-		writel_relaxed(0xFFFFFFFF, priv->base);
+		writel_relaxed(0xFFFFFFFF, priv->base + 4 * idx);
 	}
 }
 
@@ -172,7 +172,7 @@ static int htvec_of_init(struct device_n
 		goto free_priv;
 	}
 
-	/* Interrupt may come from any of the 4 interrupt line */
+	/* Interrupt may come from any of the 8 interrupt lines */
 	for (i = 0; i < HTVEC_MAX_PARENT_IRQ; i++) {
 		parent_irq[i] = irq_of_parse_and_map(node, i);
 		if (parent_irq[i] <= 0)


