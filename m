Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74DC14093B8
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241525AbhIMOXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245091AbhIMOVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:21:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C43D61B30;
        Mon, 13 Sep 2021 13:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540824;
        bh=kcinne14G5IndLRIRNUaom7LEpancf9khhgZghhw1YY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=12TN5ddhkgFP5w7A56I3dICi+s4M6JbENzk/OFcVWxsUoZABChO672Qp1OB0JI6PN
         Co34PiveHsnkC41vVSzXS5d/B2Hw3gWXuRlHaUR18B1+hcG39xhCV0d9ywG7WtIbAl
         7ceP3uKX/zR0/sBR0CtWXg2lnkjdiL+vAXVHf6pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Robinson <pbrobinson@gmail.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 049/334] power: supply: cw2015: use dev_err_probe to allow deferred probe
Date:   Mon, 13 Sep 2021 15:11:43 +0200
Message-Id: <20210913131115.090249449@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Robinson <pbrobinson@gmail.com>

[ Upstream commit ad1abe476995d97bfe7546ea91bb4f3dcdfbf3ab ]

Deal with deferred probe using dev_err_probe so the error is handled
and avoid logging lots probe defer information like the following:

[    9.125121] cw2015 4-0062: Failed to register power supply
[    9.211131] cw2015 4-0062: Failed to register power supply

Fixes: b4c7715c10c1 ("power: supply: add CellWise cw2015 fuel gauge driver")
Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cw2015_battery.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/cw2015_battery.c b/drivers/power/supply/cw2015_battery.c
index d110597746b0..091868e9e9e8 100644
--- a/drivers/power/supply/cw2015_battery.c
+++ b/drivers/power/supply/cw2015_battery.c
@@ -679,7 +679,9 @@ static int cw_bat_probe(struct i2c_client *client)
 						    &cw2015_bat_desc,
 						    &psy_cfg);
 	if (IS_ERR(cw_bat->rk_bat)) {
-		dev_err(cw_bat->dev, "Failed to register power supply\n");
+		/* try again if this happens */
+		dev_err_probe(&client->dev, PTR_ERR(cw_bat->rk_bat),
+			"Failed to register power supply\n");
 		return PTR_ERR(cw_bat->rk_bat);
 	}
 
-- 
2.30.2



