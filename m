Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9328B412026
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355100AbhITRwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:52:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353796AbhITRrK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:47:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06D9B61BA2;
        Mon, 20 Sep 2021 17:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157846;
        bh=rrVp7Iewfcp/5F7sFERnaaZZGjTiu3GaDuurNOLr644=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0GTvKniGMPqZd5e+JxHQZ170xGj/OjJR0LUulbPet7yBlPO0Z5GQqB+2VTJyUUClQ
         leAziDLQ1X7hxZ2dhDdcb0KiS9XS6wIolQCMLY4h8HPRL4KBhJavPXtfFkTfomLBOa
         uxJkyh+78RxBpzxoVx0MrjT0h2omXTMo6twVo3Js=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 4.19 145/293] power: supply: max17042: handle fails of reading status register
Date:   Mon, 20 Sep 2021 18:41:47 +0200
Message-Id: <20210920163938.243532700@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
 drivers/power/supply/max17042_battery.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -856,8 +856,12 @@ static irqreturn_t max17042_thread_handl
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


