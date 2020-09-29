Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEFEF27CCAA
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733231AbgI2MiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:38:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728783AbgI2LR1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:17:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BEE8206A5;
        Tue, 29 Sep 2020 11:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378246;
        bh=yj/lYPazjcLxTYPDL2xayjRqc9FZe9CiFPn3FykP1nQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2HulgX1x78HrRo/58cvcCT07BfD9xNCGJUUgbFNXt4hMuxNiJf1UbTKdP7MRLjsPN
         O2yUz9tPx1552ip1KZdW06+cFKpUbgF9MMHK4eafWbm0jbPVCodiXv0li2B5XHqjp/
         ncbfeDip24M8y/nLqQMLGsCcJCu/lnfnhVp6Gxog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Bakker <xc-racer2@live.ca>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 112/166] power: supply: max17040: Correct voltage reading
Date:   Tue, 29 Sep 2020 13:00:24 +0200
Message-Id: <20200929105940.791432575@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Bakker <xc-racer2@live.ca>

[ Upstream commit 0383024f811aa469df258039807810fc3793a105 ]

According to the datasheet available at (1), the bottom four
bits are always zero and the actual voltage is 1.25x this value
in mV.  Since the kernel API specifies that voltages should be in
uV, it should report 1250x the shifted value.

1) https://datasheets.maximintegrated.com/en/ds/MAX17040-MAX17041.pdf

Signed-off-by: Jonathan Bakker <xc-racer2@live.ca>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/max17040_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/max17040_battery.c b/drivers/power/supply/max17040_battery.c
index 33c40f79d23d5..2c35c13ad546f 100644
--- a/drivers/power/supply/max17040_battery.c
+++ b/drivers/power/supply/max17040_battery.c
@@ -109,7 +109,7 @@ static void max17040_get_vcell(struct i2c_client *client)
 
 	vcell = max17040_read_reg(client, MAX17040_VCELL);
 
-	chip->vcell = vcell;
+	chip->vcell = (vcell >> 4) * 1250;
 }
 
 static void max17040_get_soc(struct i2c_client *client)
-- 
2.25.1



