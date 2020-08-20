Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C93824B228
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgHTJYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:24:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:32798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726934AbgHTJYp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:24:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33F0022CA1;
        Thu, 20 Aug 2020 09:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915484;
        bh=gH6ZWWhpXfkRGKnL4proMvWVQJYS9zSHuJPaoWuUJqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VNmyo/FkcuQN6KrEpoV7b7i3jK73qtu+vogLVhM+TfodxNwTPdzySEKBCgXmDAD04
         w4ONZwVg0n9vR2sYzXv2rLl399dX7DpPHS6B3ZL/siDWYkikAKHQfl+Jtx9YMjs8IS
         yf0VMAwm3PGf+KQDL+aj4X3eMdKEZ0l0VGpPGzjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.8 005/232] genirq: Unlock irq descriptor after errors
Date:   Thu, 20 Aug 2020 11:17:36 +0200
Message-Id: <20200820091612.970077562@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

commit f107cee94ba4d2c7357fde59a1d84346c73d4958 upstream.

In irq_set_irqchip_state(), the irq descriptor is not unlocked after an
error is encountered. While that should never happen in practice, a buggy
driver may trigger it. This would result in a lockup, so fix it.

Fixes: 1d0326f352bb ("genirq: Check irq_data_get_irq_chip() return value before use")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200811180012.80269-1-linux@roeck-us.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/irq/manage.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -2735,8 +2735,10 @@ int irq_set_irqchip_state(unsigned int i
 
 	do {
 		chip = irq_data_get_irq_chip(data);
-		if (WARN_ON_ONCE(!chip))
-			return -ENODEV;
+		if (WARN_ON_ONCE(!chip)) {
+			err = -ENODEV;
+			goto out_unlock;
+		}
 		if (chip->irq_set_irqchip_state)
 			break;
 #ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
@@ -2749,6 +2751,7 @@ int irq_set_irqchip_state(unsigned int i
 	if (data)
 		err = chip->irq_set_irqchip_state(data, which, val);
 
+out_unlock:
 	irq_put_desc_busunlock(desc, flags);
 	return err;
 }


