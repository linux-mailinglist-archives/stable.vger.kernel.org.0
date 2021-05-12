Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDBB537C99F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238518AbhELQUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:20:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235430AbhELQOQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:14:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CD2E6144F;
        Wed, 12 May 2021 15:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834114;
        bh=eAikVfT7g1iI26ky+W7FRy9jZDn+90ZjTe7RKbYCq3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oq+mwNRNVxQkZVpXwgZ93lxFlc6/LmF+vSxFN3smcOhlho3DvyGRlmnZF43++jj2u
         KM4oELh8N7OgyTKU5bbxTd5Sk2dK43LmVyiC3wcgaipmY81Rf1Uioy1GlgYMDDhtq5
         0TsNVMafhZmcnjt+IzbKTEQOMo1CV9dyrUvz+8LU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hanna Hawa <hhhawa@amazon.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Drew Fustini <drew@beagleboard.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 414/601] pinctrl: pinctrl-single: fix pcs_pin_dbg_show() when bits_per_mux is not zero
Date:   Wed, 12 May 2021 16:48:11 +0200
Message-Id: <20210512144841.468529996@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hanna Hawa <hhhawa@amazon.com>

[ Upstream commit bd85125ea88513f637a62a72e8949c579c5c0a87 ]

A System Error (SError, followed by kernel panic) was detected when
trying to print the supported pins in a pinctrl device which supports
multiple pins per register. This change fixes the pcs_pin_dbg_show() in
pinctrl-single driver when bits_per_mux is not zero. In addition move
offset calculation and pin offset in register to common function.

Fixes: 4e7e8017a80e ("pinctrl: pinctrl-single: enhance to configure multiple pins of different modules")
Signed-off-by: Hanna Hawa <hhhawa@amazon.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Drew Fustini <drew@beagleboard.org>
Link: https://lore.kernel.org/r/20210319152133.28705-4-hhhawa@amazon.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-single.c | 55 ++++++++++++++++++++------------
 1 file changed, 35 insertions(+), 20 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 539543898c89..12cc4eb18637 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -270,20 +270,44 @@ static void __maybe_unused pcs_writel(unsigned val, void __iomem *reg)
 	writel(val, reg);
 }
 
+static unsigned int pcs_pin_reg_offset_get(struct pcs_device *pcs,
+					   unsigned int pin)
+{
+	unsigned int mux_bytes = pcs->width / BITS_PER_BYTE;
+
+	if (pcs->bits_per_mux) {
+		unsigned int pin_offset_bytes;
+
+		pin_offset_bytes = (pcs->bits_per_pin * pin) / BITS_PER_BYTE;
+		return (pin_offset_bytes / mux_bytes) * mux_bytes;
+	}
+
+	return pin * mux_bytes;
+}
+
+static unsigned int pcs_pin_shift_reg_get(struct pcs_device *pcs,
+					  unsigned int pin)
+{
+	return (pin % (pcs->width / pcs->bits_per_pin)) * pcs->bits_per_pin;
+}
+
 static void pcs_pin_dbg_show(struct pinctrl_dev *pctldev,
 					struct seq_file *s,
 					unsigned pin)
 {
 	struct pcs_device *pcs;
-	unsigned val, mux_bytes;
+	unsigned int val;
 	unsigned long offset;
 	size_t pa;
 
 	pcs = pinctrl_dev_get_drvdata(pctldev);
 
-	mux_bytes = pcs->width / BITS_PER_BYTE;
-	offset = pin * mux_bytes;
+	offset = pcs_pin_reg_offset_get(pcs, pin);
 	val = pcs->read(pcs->base + offset);
+
+	if (pcs->bits_per_mux)
+		val &= pcs->fmask << pcs_pin_shift_reg_get(pcs, pin);
+
 	pa = pcs->res->start + offset;
 
 	seq_printf(s, "%zx %08x %s ", pa, val, DRIVER_NAME);
@@ -384,7 +408,6 @@ static int pcs_request_gpio(struct pinctrl_dev *pctldev,
 	struct pcs_device *pcs = pinctrl_dev_get_drvdata(pctldev);
 	struct pcs_gpiofunc_range *frange = NULL;
 	struct list_head *pos, *tmp;
-	int mux_bytes = 0;
 	unsigned data;
 
 	/* If function mask is null, return directly. */
@@ -392,29 +415,27 @@ static int pcs_request_gpio(struct pinctrl_dev *pctldev,
 		return -ENOTSUPP;
 
 	list_for_each_safe(pos, tmp, &pcs->gpiofuncs) {
+		u32 offset;
+
 		frange = list_entry(pos, struct pcs_gpiofunc_range, node);
 		if (pin >= frange->offset + frange->npins
 			|| pin < frange->offset)
 			continue;
-		mux_bytes = pcs->width / BITS_PER_BYTE;
 
-		if (pcs->bits_per_mux) {
-			int byte_num, offset, pin_shift;
+		offset = pcs_pin_reg_offset_get(pcs, pin);
 
-			byte_num = (pcs->bits_per_pin * pin) / BITS_PER_BYTE;
-			offset = (byte_num / mux_bytes) * mux_bytes;
-			pin_shift = pin % (pcs->width / pcs->bits_per_pin) *
-				    pcs->bits_per_pin;
+		if (pcs->bits_per_mux) {
+			int pin_shift = pcs_pin_shift_reg_get(pcs, pin);
 
 			data = pcs->read(pcs->base + offset);
 			data &= ~(pcs->fmask << pin_shift);
 			data |= frange->gpiofunc << pin_shift;
 			pcs->write(data, pcs->base + offset);
 		} else {
-			data = pcs->read(pcs->base + pin * mux_bytes);
+			data = pcs->read(pcs->base + offset);
 			data &= ~pcs->fmask;
 			data |= frange->gpiofunc;
-			pcs->write(data, pcs->base + pin * mux_bytes);
+			pcs->write(data, pcs->base + offset);
 		}
 		break;
 	}
@@ -726,14 +747,8 @@ static int pcs_allocate_pin_table(struct pcs_device *pcs)
 	for (i = 0; i < pcs->desc.npins; i++) {
 		unsigned offset;
 		int res;
-		int byte_num;
 
-		if (pcs->bits_per_mux) {
-			byte_num = (pcs->bits_per_pin * i) / BITS_PER_BYTE;
-			offset = (byte_num / mux_bytes) * mux_bytes;
-		} else {
-			offset = i * mux_bytes;
-		}
+		offset = pcs_pin_reg_offset_get(pcs, i);
 		res = pcs_add_pin(pcs, offset);
 		if (res < 0) {
 			dev_err(pcs->dev, "error adding pins: %i\n", res);
-- 
2.30.2



