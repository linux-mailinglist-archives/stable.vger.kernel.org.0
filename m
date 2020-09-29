Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE3427C813
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731634AbgI2L6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:58:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730349AbgI2Lll (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:41:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2EB62083B;
        Tue, 29 Sep 2020 11:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379700;
        bh=ie++nir9f+2nD4AZK2bbGTkmWoKC3p+A/hsee9XYrIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f0e+L0QKq5zmvXdPbaDP6bFIhUPjChpuUb6rbrcPIY2A5cwG989qMbObYgcpkGRoc
         g9x90OM8qNVsX74y9QonU3gqsYBde+qFbFPljSua0V5dGW4QptizaWgrfaB4akm/XK
         eL1zoCOF50xh2qczETYdShaKAJgmGitfsDk9l1D0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Bakker <xc-racer2@live.ca>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 252/388] power: supply: max17040: Correct voltage reading
Date:   Tue, 29 Sep 2020 12:59:43 +0200
Message-Id: <20200929110022.681056757@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
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
index 62499018e68bf..2e845045a3fc0 100644
--- a/drivers/power/supply/max17040_battery.c
+++ b/drivers/power/supply/max17040_battery.c
@@ -105,7 +105,7 @@ static void max17040_get_vcell(struct i2c_client *client)
 
 	vcell = max17040_read_reg(client, MAX17040_VCELL);
 
-	chip->vcell = vcell;
+	chip->vcell = (vcell >> 4) * 1250;
 }
 
 static void max17040_get_soc(struct i2c_client *client)
-- 
2.25.1



