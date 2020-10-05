Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7FB283ADE
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728564AbgJEPiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:38:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727423AbgJEPbm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:31:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD23420663;
        Mon,  5 Oct 2020 15:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911902;
        bh=lX9O4hxvxd90v1IeDiyJoQVpOMMiA7ft8aBH2MqUH60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZ/jrYY1v9qbsdd7VuZbsh532eV+CpWP3mMvTv1aE7efpgGWf31q7Ag0tmKNTSmfe
         2C0nWPV0Gm4UZDOsjw4b8+ECqHAQWG+t9d0lniczNnu8ezSy+X7uGyXdqp71Zr4lG6
         pRQhB7MHY7irzM46xHbNASYfc70LlwXANB1c6dKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>,
        Xu Kai <xukai@nationalchip.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 24/85] clocksource/drivers/timer-gx6605s: Fixup counter reload
Date:   Mon,  5 Oct 2020 17:26:20 +0200
Message-Id: <20201005142115.894409200@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

[ Upstream commit bc6717d55d07110d8f3c6d31ec2af50c11b07091 ]

When the timer counts to the upper limit, an overflow interrupt is
generated, and the count is reset with the value in the TIME_INI
register. But the software expects to start counting from 0 when
the count overflows, so it forces TIME_INI to 0 to solve the
potential interrupt storm problem.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Tested-by: Xu Kai <xukai@nationalchip.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/1597735877-71115-1-git-send-email-guoren@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-gx6605s.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/timer-gx6605s.c b/drivers/clocksource/timer-gx6605s.c
index 80d0939d040b5..8d386adbe8009 100644
--- a/drivers/clocksource/timer-gx6605s.c
+++ b/drivers/clocksource/timer-gx6605s.c
@@ -28,6 +28,7 @@ static irqreturn_t gx6605s_timer_interrupt(int irq, void *dev)
 	void __iomem *base = timer_of_base(to_timer_of(ce));
 
 	writel_relaxed(GX6605S_STATUS_CLR, base + TIMER_STATUS);
+	writel_relaxed(0, base + TIMER_INI);
 
 	ce->event_handler(ce);
 
-- 
2.25.1



