Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC8F4090D0
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343604AbhIMNzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:55:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:40464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244226AbhIMNxj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:53:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6F31619E0;
        Mon, 13 Sep 2021 13:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540094;
        bh=kcinne14G5IndLRIRNUaom7LEpancf9khhgZghhw1YY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rz4/aALaQRdppdNB07n5UZHtjRdlgftgbHWZqfRvQEFQ45CP4CvlE4NnZWz2IN/nl
         VHQ+1xpgHJ2k0O2Yw/rSgtJlyER9m9+gO85F5Orl6Oax9MbOx9MdwJbyjCsSGM2j8N
         Yb9grrugtH5QFYKOyC17O/fsM20cyf4b/QTsD0oc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Robinson <pbrobinson@gmail.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 048/300] power: supply: cw2015: use dev_err_probe to allow deferred probe
Date:   Mon, 13 Sep 2021 15:11:49 +0200
Message-Id: <20210913131110.963350093@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
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



