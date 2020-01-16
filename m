Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18FCC13E376
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388306AbgAPRCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:02:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:54696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388303AbgAPRCO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:02:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44EF72081E;
        Thu, 16 Jan 2020 17:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194134;
        bh=0JFl9aWLKC71Gk5dPOObiZY7H/47oVRdIQLA7yf0cs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Nix6HeXk53lSTHlxPtFU55tlS2IAdeVmmYQHKKcMz4C1WYK3o+s8n5WvJbwFIZCt
         r0bu8RjOzoThSATFpG3YqVu+KViO9WxDbTu6YgU0r8hR5N24mLBTXrjqQkzQ5ZYKxb
         tlGbKzqJHAWqJOUb6SF25mJSjW88aq0aQIql+RXc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Axel Lin <axel.lin@ingics.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 4.19 223/671] regulator: wm831x-dcdc: Fix list of wm831x_dcdc_ilim from mA to uA
Date:   Thu, 16 Jan 2020 11:52:12 -0500
Message-Id: <20200116165940.10720-106-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 5a5bc4bb08d2..df591435d12a 100644
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

