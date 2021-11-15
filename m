Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2504522AA
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348321AbhKPBPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:15:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:43002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244263AbhKOTMQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:12:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C93863275;
        Mon, 15 Nov 2021 18:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000391;
        bh=hI+1b2RSlrUmiEH5w1TT/EiHcYbHXU8DUzQOva243LE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c5Pg15X/3BZFM7uYVtk1FMdUlvaiKJrg0mDBoFjAKJ/IsfCzs6pkVMdj8PqwcJBmp
         U+HB4+8aVO6gm1nFAazlXp+EcUmTCYMQOB4ClVa7hTo060b+9RBl+MqFd4HEpzn7jZ
         5CNq2j8lxoEcFWMosoy5EzlAlB/lCupWxmryTc7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Beomho Seo <beomho.seo@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Jakob Hauser <jahau@rocketmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: =?UTF-8?q?=5BPATCH=205=2E14=20601/849=5D=20=3D=3FUTF-8=3Fq=3Fpower=3A=3D20supply=3A=3D20rt5033=3D5Fbattery=3A=3D20Change=3D20voltage=3F=3D=20=3D=3FUTF-8=3Fq=3F=3D20values=3D20to=3D20=3DC2=3DB5V=3F=3D?=
Date:   Mon, 15 Nov 2021 18:01:24 +0100
Message-Id: <20211115165440.588764794@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 9ad0afe83d1b7..7a23c70f48791 100644
--- a/drivers/power/supply/rt5033_battery.c
+++ b/drivers/power/supply/rt5033_battery.c
@@ -60,7 +60,7 @@ static int rt5033_battery_get_watt_prop(struct i2c_client *client,
 	regmap_read(battery->regmap, regh, &msb);
 	regmap_read(battery->regmap, regl, &lsb);
 
-	ret = ((msb << 4) + (lsb >> 4)) * 1250 / 1000;
+	ret = ((msb << 4) + (lsb >> 4)) * 1250;
 
 	return ret;
 }
-- 
2.33.0



