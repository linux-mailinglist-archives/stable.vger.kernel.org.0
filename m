Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281BF23F9B0
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgHHXhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727850AbgHHXhL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:37:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F231F206C3;
        Sat,  8 Aug 2020 23:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929830;
        bh=0AgMrIP7GP2rYQZIrGzD4CARHK1GDj4u+58ZN43cdUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tODXCzQGtLJCBotl1l3dqedb3xpFFVlk1JUDfhkIZc+uJpjJCNmYyZuSqQerHOmST
         kEf56fe2QMLexvygchBNVV4PL80ZaoOioDBD9YayJ2KoGRiLwJAQPfpa4vMNWywnXo
         IGh6nDVjfkULlwEi9W5gGVkr7qF7JWZ7N0+r8Uno=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Jianmin Lv <lvjianmin@loongson.cn>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 62/72] irqchip/loongson-liointc: Fix potential dead lock
Date:   Sat,  8 Aug 2020 19:35:31 -0400
Message-Id: <20200808233542.3617339-62-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233542.3617339-1-sashal@kernel.org>
References: <20200808233542.3617339-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

