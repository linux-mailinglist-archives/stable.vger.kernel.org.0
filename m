Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2E0212F13E
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbgABWOq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:14:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:55166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727955AbgABWOp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:14:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B4A722314;
        Thu,  2 Jan 2020 22:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003285;
        bh=eFSrbM0YLx7ixvZ4o7BDvCfWiEf9hFG1YCjCboxeDWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xJTSd7pam8Gjs6SNl3qIVs6kh7eS13xEdDagSX2P0la7RcLmVsfiL3k9VRly3pO9Y
         7K0UTaVN/F0Kheq494JyndbyFIqqlTQAmuQakT0WtVQ8BE2PBDR3Ls3kUWGKXO0ZB0
         HQ1ehDcui9/IgMN/Z8tDQqvHTGrkFmYYamWd/lTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/191] gpio/mpc8xxx: fix qoriq GPIO reading
Date:   Thu,  2 Jan 2020 23:06:19 +0100
Message-Id: <20200102215840.304056588@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 787b64a43f7acacf8099329ea08872e663f1e74f ]

Qoriq requires the IBE register to be set to enable GPIO inputs to be
read.  Set it.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/E1iX3HC-00069N-0T@rmk-PC.armlinux.org.uk
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mpc8xxx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index 16a47de29c94..b863421ae730 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -386,6 +386,9 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 
 	gc->to_irq = mpc8xxx_gpio_to_irq;
 
+	if (of_device_is_compatible(np, "fsl,qoriq-gpio"))
+		gc->write_reg(mpc8xxx_gc->regs + GPIO_IBE, 0xffffffff);
+
 	ret = gpiochip_add_data(gc, mpc8xxx_gc);
 	if (ret) {
 		pr_err("%pOF: GPIO chip registration failed with status %d\n",
-- 
2.20.1



