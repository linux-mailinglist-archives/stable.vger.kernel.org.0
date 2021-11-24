Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C4445C0AF
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347603AbhKXNKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:10:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:52052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348374AbhKXNJN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:09:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED134613A6;
        Wed, 24 Nov 2021 12:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757625;
        bh=uTUEgtGmdnuDM44r+Dbj6sUNCh0HtYOfDpYvHUjqdho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E4hxYZE+VXe06IR7d85nlApxcdsRufFQD88fxvdK53chWNhzBJV5lwHTU1go7+xm9
         dNcnG1qlEHBmZlBIyEYssocHC8tDYFVeg85E0TSVxFpVDN2WsFyKwZdSHXdRZgs+Dd
         oqE1Eay4huJmSm5O2wUIZc8Hi9+2RWMzCru81bos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Beomho Seo <beomho.seo@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Jakob Hauser <jahau@rocketmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: =?UTF-8?q?=5BPATCH=204=2E19=20191/323=5D=20=3D=3FUTF-8=3Fq=3Fpower=3A=3D20supply=3A=3D20rt5033=3D5Fbattery=3A=3D20Change=3D20voltage=3F=3D=20=3D=3FUTF-8=3Fq=3F=3D20values=3D20to=3D20=3DC2=3DB5V=3F=3D?=
Date:   Wed, 24 Nov 2021 12:56:21 +0100
Message-Id: <20211124115725.391756768@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakob Hauser <jahau@rocketmail.com>

[ Upstream commit bf895295e9a73411889816f1a0c1f4f1a2d9c678 ]

Currently the rt5033_battery driver provides voltage values in mV. It
should be µV as stated in Documentation/power/power_supply_class.rst.

Fixes: b847dd96e659 ("power: rt5033_battery: Add RT5033 Fuel gauge device driver")
Cc: Beomho Seo <beomho.seo@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Jakob Hauser <jahau@rocketmail.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/rt5033_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/rt5033_battery.c b/drivers/power/supply/rt5033_battery.c
index 9310b85f3405e..7eec7014086d8 100644
--- a/drivers/power/supply/rt5033_battery.c
+++ b/drivers/power/supply/rt5033_battery.c
@@ -63,7 +63,7 @@ static int rt5033_battery_get_watt_prop(struct i2c_client *client,
 	regmap_read(battery->regmap, regh, &msb);
 	regmap_read(battery->regmap, regl, &lsb);
 
-	ret = ((msb << 4) + (lsb >> 4)) * 1250 / 1000;
+	ret = ((msb << 4) + (lsb >> 4)) * 1250;
 
 	return ret;
 }
-- 
2.33.0



