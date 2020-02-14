Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD8C15F1C6
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731400AbgBNPz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:55:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:36542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731771AbgBNPz0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:55:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97E342467C;
        Fri, 14 Feb 2020 15:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695726;
        bh=9bpJw+BGlm+ozrpPpsGfyfMVr5eMgWl1Iod/H0eoXC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jUIf5KLjk41Sgworc7BYzkNMTyuSN0TlyTI2vGgs0NZtOVXkLb7V/M/UxnShkh3uj
         GjRyqH2zoQ15agGgx/vgYgMsDv4zS08b2A91B4p8zPM5HGavvb67nMStKT++cudyBz
         SWn9r7tfE1WCuWs2fhZKlr/u4QDei11Bsv5H/KsY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Chen Zhou <chenzhou10@huawei.com>,
        Li Yang <leoyang.li@nxp.com>, Sasha Levin <sashal@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 302/542] soc: fsl: qe: remove set but not used variable 'mm_gc'
Date:   Fri, 14 Feb 2020 10:44:54 -0500
Message-Id: <20200214154854.6746-302-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 6e62bd36e9ad85a22d92b1adce6a0336ea549733 ]

drivers/soc/fsl/qe/gpio.c: In function qe_pin_request:
drivers/soc/fsl/qe/gpio.c:163:26: warning: variable mm_gc set but not used [-Wunused-but-set-variable]

commit 1e714e54b5ca ("powerpc: qe_lib-gpio: use gpiochip data pointer")
left behind this unused variable.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Li Yang <leoyang.li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/qe/gpio.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/soc/fsl/qe/gpio.c b/drivers/soc/fsl/qe/gpio.c
index f0c29ed8f0ff1..807df73728fc7 100644
--- a/drivers/soc/fsl/qe/gpio.c
+++ b/drivers/soc/fsl/qe/gpio.c
@@ -160,7 +160,6 @@ struct qe_pin *qe_pin_request(struct device_node *np, int index)
 {
 	struct qe_pin *qe_pin;
 	struct gpio_chip *gc;
-	struct of_mm_gpio_chip *mm_gc;
 	struct qe_gpio_chip *qe_gc;
 	int err;
 	unsigned long flags;
@@ -186,7 +185,6 @@ struct qe_pin *qe_pin_request(struct device_node *np, int index)
 		goto err0;
 	}
 
-	mm_gc = to_of_mm_gpio_chip(gc);
 	qe_gc = gpiochip_get_data(gc);
 
 	spin_lock_irqsave(&qe_gc->lock, flags);
-- 
2.20.1

