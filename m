Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 116A41A1D70
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 10:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgDHIaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 04:30:22 -0400
Received: from mo-csw1514.securemx.jp ([210.130.202.153]:36958 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgDHIaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 04:30:22 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id 0388UKDC002224; Wed, 8 Apr 2020 17:30:20 +0900
X-Iguazu-Qid: 34ts1iCWJmDTmG0XiS
X-Iguazu-QSIG: v=2; s=0; t=1586334619; q=34ts1iCWJmDTmG0XiS; m=S5Xg22/+a/vhX0Pyi5Nhzma+AjOm04bPoVAu2JQLCq8=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1510) id 0388UJlE002437;
        Wed, 8 Apr 2020 17:30:19 +0900
Received: from enc01.localdomain ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id 0388UJmn029574
        for <stable@vger.kernel.org>; Wed, 8 Apr 2020 17:30:19 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.localdomain  with ESMTP id 0388UIPU005614
        for <stable@vger.kernel.org>; Wed, 8 Apr 2020 17:30:19 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Subject: [PATCH for 4.4.y] power: supply: axp288_charger: Fix unchecked return value
Date:   Wed,  8 Apr 2020 17:30:18 +0900
X-TSB-HOP: ON
Message-Id: <20200408083018.4153116-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

commit c3422ad5f84a66739ec6a37251ca27638c85b6be upstream.

Currently there is no check on platform_get_irq() return value
in case it fails, hence never actually reporting any errors and
causing unexpected behavior when using such value as argument
for function regmap_irq_get_virq().

Fix this by adding a proper check, a message reporting any errors
and returning *pirq*

Addresses-Coverity-ID: 1443940 ("Improper use of negative value")
Fixes: 843735b788a4 ("power: axp288_charger: axp288 charger driver")
Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/power/axp288_charger.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/power/axp288_charger.c b/drivers/power/axp288_charger.c
index e4d569f57acc9..0c6fed79c363b 100644
--- a/drivers/power/axp288_charger.c
+++ b/drivers/power/axp288_charger.c
@@ -883,6 +883,10 @@ static int axp288_charger_probe(struct platform_device *pdev)
 	/* Register charger interrupts */
 	for (i = 0; i < CHRG_INTR_END; i++) {
 		pirq = platform_get_irq(info->pdev, i);
+		if (pirq < 0) {
+			dev_err(&pdev->dev, "Failed to get IRQ: %d\n", pirq);
+			return pirq;
+		}
 		info->irq[i] = regmap_irq_get_virq(info->regmap_irqc, pirq);
 		if (info->irq[i] < 0) {
 			dev_warn(&info->pdev->dev,
-- 
2.26.0

