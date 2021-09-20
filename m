Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814E4411A1C
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240067AbhITQrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:47:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242058AbhITQrM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:47:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56B69611AE;
        Mon, 20 Sep 2021 16:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156345;
        bh=onUe9Tx0CiO6YpwNg8NIYuxQVQQT1EWhaSNkiyKwy+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0VCWt5m6ta9JlTGgeHccpdE37GloNMMDQyWrvI+GFK/QbnIBa25Cy8slfPQLQZ+iT
         s11rNDrBq8UFIihZA51tsN5pC2CYoNxNclsPqtfGYuUY1DjN4hbVupcrNvW3siKL3h
         BFB6Cwh479fkyg2oZyriTw9O8oqD4+4aW0pb+Ur4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keerthy <j-keerthy@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.4 017/133] PM / wakeirq: Enable dedicated wakeirq for suspend
Date:   Mon, 20 Sep 2021 18:41:35 +0200
Message-Id: <20210920163913.176418675@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

commit c84345597558349474f55be2b7d4093256e42884 upstream.

We currently rely on runtime PM to enable dedicated wakeirq for suspend.
This assumption fails in the following two cases:

1. If the consumer driver does not have runtime PM implemented, the
   dedicated wakeirq never gets enabled for suspend

2. If the consumer driver has runtime PM implemented, but does not idle
   in suspend

Let's fix the issue by always enabling the dedicated wakeirq during
suspend.

Depends-on: bed570307ed7 (PM / wakeirq: Fix dedicated wakeirq for drivers not using autosuspend)
Fixes: 4990d4fe327b (PM / Wakeirq: Add automated device wake IRQ handling)
Reported-by: Keerthy <j-keerthy@ti.com>
Tested-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
[ tony@atomide.com: updated based on bed570307ed7, added description ]
Tested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/wakeirq.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/base/power/wakeirq.c
+++ b/drivers/base/power/wakeirq.c
@@ -319,8 +319,12 @@ void dev_pm_arm_wake_irq(struct wake_irq
 	if (!wirq)
 		return;
 
-	if (device_may_wakeup(wirq->dev))
+	if (device_may_wakeup(wirq->dev)) {
+		if (wirq->status & WAKE_IRQ_DEDICATED_ALLOCATED)
+			enable_irq(wirq->irq);
+
 		enable_irq_wake(wirq->irq);
+	}
 }
 
 /**
@@ -335,6 +339,10 @@ void dev_pm_disarm_wake_irq(struct wake_
 	if (!wirq)
 		return;
 
-	if (device_may_wakeup(wirq->dev))
+	if (device_may_wakeup(wirq->dev)) {
 		disable_irq_wake(wirq->irq);
+
+		if (wirq->status & WAKE_IRQ_DEDICATED_ALLOCATED)
+			disable_irq_nosync(wirq->irq);
+	}
 }


