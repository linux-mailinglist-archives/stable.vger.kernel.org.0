Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 651D814BA62
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730673AbgA1OSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:18:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:42496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730497AbgA1OS3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:18:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBCDE24681;
        Tue, 28 Jan 2020 14:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221109;
        bh=ruJhuPX5YT8xB86h9cdA6e549MQ5UbUT38xZLIPdo6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yqiid1q7Y69jZ8DJDXmKqqP0AtiL5C/n7PuSImbVOBZX2vTmfoqowvoNbuewbgaJR
         YEmM2qvKcLX5dXpKfwpQJjxlojLDYwGgeFoDeGHiEzb0hgGQrMPgxUTrNC/HvG0QyU
         oukI5/0ePfrDnYljruTUf8D67nQQqIBBEbFBXQbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 092/271] regulator: wm831x-dcdc: Fix list of wm831x_dcdc_ilim from mA to uA
Date:   Tue, 28 Jan 2020 15:04:01 +0100
Message-Id: <20200128135859.439342897@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit c25d47888f0fb3d836d68322d4aea2caf31a75a6 ]

The wm831x_dcdc_ilim entries needs to be uA because it is used to compare
with min_uA and max_uA.
While at it also make the array const and change to use unsigned int.

Fixes: e4ee831f949a ("regulator: Add WM831x DC-DC buck convertor support")
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/wm831x-dcdc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 5a5bc4bb08d26..df591435d12a3 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -327,8 +327,8 @@ static int wm831x_buckv_get_voltage_sel(struct regulator_dev *rdev)
 }
 
 /* Current limit options */
-static u16 wm831x_dcdc_ilim[] = {
-	125, 250, 375, 500, 625, 750, 875, 1000
+static const unsigned int wm831x_dcdc_ilim[] = {
+	125000, 250000, 375000, 500000, 625000, 750000, 875000, 1000000
 };
 
 static int wm831x_buckv_set_current_limit(struct regulator_dev *rdev,
-- 
2.20.1



