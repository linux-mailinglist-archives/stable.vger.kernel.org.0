Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B11411A73
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244108AbhITQuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:50:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229672AbhITQtV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:49:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A7AE61283;
        Mon, 20 Sep 2021 16:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156474;
        bh=r1akpp0OlgBWPvRWUx9JtgJT8PLpL2XcHjM93vivU/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KSvWr1Z7Y6zquQeifPjfF0cVHGKw7z3QTYoxnWqshGpGQxFeDwUL4sg5MWYdxjhKS
         nbx3VC5uml3w/EOhriPoi0UJtJi4KAZN1NHiVKXrIIT9SB1VC4LuPMv1vuyPr37MCA
         LrG6+nA8I05IS3e/7ABI1iNaNgO1Yu42xphDNLs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 4.4 075/133] power: supply: max17042: handle fails of reading status register
Date:   Mon, 20 Sep 2021 18:42:33 +0200
Message-Id: <20210920163915.101183496@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

commit 54784ffa5b267f57161eb8fbb811499f22a0a0bf upstream.

Reading status register can fail in the interrupt handler.  In such
case, the regmap_read() will not store anything useful under passed
'val' variable and random stack value will be used to determine type of
interrupt.

Handle the regmap_read() failure to avoid handling interrupt type and
triggering changed power supply event based on random stack value.

Fixes: 39e7213edc4f ("max17042_battery: Support regmap to access device's registers")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/max17042_battery.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -760,8 +760,12 @@ static irqreturn_t max17042_thread_handl
 {
 	struct max17042_chip *chip = dev;
 	u32 val;
+	int ret;
+
+	ret = regmap_read(chip->regmap, MAX17042_STATUS, &val);
+	if (ret)
+		return IRQ_HANDLED;
 
-	regmap_read(chip->regmap, MAX17042_STATUS, &val);
 	if ((val & STATUS_INTR_SOCMIN_BIT) ||
 		(val & STATUS_INTR_SOCMAX_BIT)) {
 		dev_info(&chip->client->dev, "SOC threshold INTR\n");


