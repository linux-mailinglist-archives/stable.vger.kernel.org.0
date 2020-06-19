Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736012017BD
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388551AbgFSQmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:42:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388539AbgFSOoM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:44:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 127A021707;
        Fri, 19 Jun 2020 14:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577852;
        bh=NTJMUJCxpHMDa8d4wYRp0uqp9B3nj5/p/FcbB5VR9ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N7A5+iGZ8LgAQ5dMvXYmZpwjIw1wrtqiXy5a9msvFR7isRFDoZ14r2pDNAKyQcUnA
         RbgX1GIMxCKmxBpo2ATn3eHiJOnUZtMRLOAAgrvL9Cg+tQFfszVBvFMJmV7YCXaLys
         MlFhIoxcxOVd9tx+9auuvlt9VMxt+yHhhGmpmkEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Bakker <xc-racer2@live.ca>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 4.9 115/128] pinctrl: samsung: Save/restore eint_mask over suspend for EINT_TYPE GPIOs
Date:   Fri, 19 Jun 2020 16:33:29 +0200
Message-Id: <20200619141626.213304694@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141620.148019466@linuxfoundation.org>
References: <20200619141620.148019466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Bakker <xc-racer2@live.ca>

commit f354157a7d184db430c1a564c506434e33b1bec5 upstream.

Currently, for EINT_TYPE GPIOs, the CON and FLTCON registers
are saved and restored over a suspend/resume cycle.  However, the
EINT_MASK registers are not.

On S5PV210 at the very least, these registers are not retained over
suspend, leading to the interrupts remaining masked upon resume and
therefore no interrupts being triggered for the device.  There should
be no effect on any SoCs that do retain these registers as theoretically
we would just be re-writing what was already there.

Fixes: 7ccbc60cd9c2 ("pinctrl: exynos: Handle suspend/resume of GPIO EINT registers")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Bakker <xc-racer2@live.ca>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/samsung/pinctrl-exynos.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/pinctrl/samsung/pinctrl-exynos.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -289,6 +289,7 @@ struct exynos_eint_gpio_save {
 	u32 eint_con;
 	u32 eint_fltcon0;
 	u32 eint_fltcon1;
+	u32 eint_mask;
 };
 
 /*
@@ -585,10 +586,13 @@ static void exynos_pinctrl_suspend_bank(
 						+ 2 * bank->eint_offset);
 	save->eint_fltcon1 = readl(regs + EXYNOS_GPIO_EFLTCON_OFFSET
 						+ 2 * bank->eint_offset + 4);
+	save->eint_mask = readl(regs + bank->irq_chip->eint_mask
+						+ bank->eint_offset);
 
 	pr_debug("%s: save     con %#010x\n", bank->name, save->eint_con);
 	pr_debug("%s: save fltcon0 %#010x\n", bank->name, save->eint_fltcon0);
 	pr_debug("%s: save fltcon1 %#010x\n", bank->name, save->eint_fltcon1);
+	pr_debug("%s: save    mask %#010x\n", bank->name, save->eint_mask);
 }
 
 static void exynos_pinctrl_suspend(struct samsung_pinctrl_drv_data *drvdata)
@@ -617,6 +621,9 @@ static void exynos_pinctrl_resume_bank(
 	pr_debug("%s: fltcon1 %#010x => %#010x\n", bank->name,
 			readl(regs + EXYNOS_GPIO_EFLTCON_OFFSET
 			+ 2 * bank->eint_offset + 4), save->eint_fltcon1);
+	pr_debug("%s:    mask %#010x => %#010x\n", bank->name,
+			readl(regs + bank->irq_chip->eint_mask
+			+ bank->eint_offset), save->eint_mask);
 
 	writel(save->eint_con, regs + EXYNOS_GPIO_ECON_OFFSET
 						+ bank->eint_offset);
@@ -624,6 +631,8 @@ static void exynos_pinctrl_resume_bank(
 						+ 2 * bank->eint_offset);
 	writel(save->eint_fltcon1, regs + EXYNOS_GPIO_EFLTCON_OFFSET
 						+ 2 * bank->eint_offset + 4);
+	writel(save->eint_mask, regs + bank->irq_chip->eint_mask
+						+ bank->eint_offset);
 }
 
 static void exynos_pinctrl_resume(struct samsung_pinctrl_drv_data *drvdata)


