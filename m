Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6C6408E6C
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241303AbhIMNdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:33:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242679AbhIMN3x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:29:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2E05610D2;
        Mon, 13 Sep 2021 13:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539476;
        bh=JdhKrN9hnvrcZAnXyTjQPj8s49YOGY/IFTfdPUdDjXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WheeCUMiQvg+PnYaTZfHoeGRw6kAneA0yRKlD8yXpjBUd5HDePNnhsBvlUJhHOFVC
         g8HRxbdr9FVJwOPPQ4AO+13w73zNPNQXOnn7sY9fVEqb1RyF1QsB3jes2Zb40qlTog
         2OrXeB/w7hGn7S0P9boc0ZaGkgJ+nMlSXR4YJdQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Robinson <pbrobinson@gmail.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/236] power: supply: cw2015: use dev_err_probe to allow deferred probe
Date:   Mon, 13 Sep 2021 15:12:25 +0200
Message-Id: <20210913131101.715688753@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
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
index 0146f1bfc29b..de1fa71be1e8 100644
--- a/drivers/power/supply/cw2015_battery.c
+++ b/drivers/power/supply/cw2015_battery.c
@@ -673,7 +673,9 @@ static int cw_bat_probe(struct i2c_client *client)
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



