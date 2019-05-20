Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A58E23375
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387434AbfETMRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:17:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387413AbfETMRA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:17:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A568213F2;
        Mon, 20 May 2019 12:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354619;
        bh=/i0L0JKA+iBWngfkDkWpnXkwBJ6zp/hZP3orqZ9dooU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lu5JZbdQ4esP0CrJx7aHTGBR2CZEmebQpzrGKpxIdNWDdnMiyqsf77hXOhs5ZUX0C
         2Ab4QEilnis7pwSOxf1T8HPe2ga4/EIJ1gilg9cuvNSfbAY415oIpozju4WRL3OGAI
         957fvytGurAUbMW8i4OxTiR3c9MVFH47xs3U93n8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 4.9 08/44] power: supply: axp288_charger: Fix unchecked return value
Date:   Mon, 20 May 2019 14:13:57 +0200
Message-Id: <20190520115232.016025272@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115230.720347034@linuxfoundation.org>
References: <20190520115230.720347034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavo@embeddedor.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/power/supply/axp288_charger.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/power/supply/axp288_charger.c
+++ b/drivers/power/supply/axp288_charger.c
@@ -899,6 +899,10 @@ static int axp288_charger_probe(struct p
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


