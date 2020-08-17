Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D7C247738
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbgHQTqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:46:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729325AbgHQPVK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:21:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A4DD206FA;
        Mon, 17 Aug 2020 15:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677670;
        bh=0AgMrIP7GP2rYQZIrGzD4CARHK1GDj4u+58ZN43cdUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hXmx4InzSSspEJgvTaNBMq5TRu9ySLZKTzsozoy3jL86SnYSzw4KaEBZRXObPMR4P
         RZjkEVDWqiKUkofTSzNC2wNtfCYjrNZY7wXWDVyLfT/ohi3CoxkLZlXTUCMjX8T1RH
         /Uq6SN0jvzbbpgea2qTNY5K7gmYR8pO54G/cfCgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianmin Lv <lvjianmin@loongson.cn>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 066/464] irqchip/loongson-liointc: Fix potential dead lock
Date:   Mon, 17 Aug 2020 17:10:19 +0200
Message-Id: <20200817143836.927187075@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit fa03587cad9bd32aa552377de4f05c50181a35a8 ]

In the function liointc_set_type(), we need to call the function
irq_gc_unlock_irqrestore() before returning.

Fixes: dbb152267908 ("irqchip: Add driver for Loongson I/O Local Interrupt Controller")
Reported-by: Jianmin Lv <lvjianmin@loongson.cn>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/1594087972-21715-8-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-loongson-liointc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-loongson-liointc.c b/drivers/irqchip/irq-loongson-liointc.c
index 63b61474a0cc2..6ef86a334c62d 100644
--- a/drivers/irqchip/irq-loongson-liointc.c
+++ b/drivers/irqchip/irq-loongson-liointc.c
@@ -114,6 +114,7 @@ static int liointc_set_type(struct irq_data *data, unsigned int type)
 		liointc_set_bit(gc, LIOINTC_REG_INTC_POL, mask, false);
 		break;
 	default:
+		irq_gc_unlock_irqrestore(gc, flags);
 		return -EINVAL;
 	}
 	irq_gc_unlock_irqrestore(gc, flags);
-- 
2.25.1



