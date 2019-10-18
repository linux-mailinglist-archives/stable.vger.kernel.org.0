Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A972EDD1AC
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbfJRWFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:05:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729169AbfJRWFG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:05:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5569222D2;
        Fri, 18 Oct 2019 22:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436305;
        bh=y6VryHO5+naC1eaHPBvno9Wffqz7+nBh++FjpxSa67Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JwpBaNbOXEpNc+c0mmctL7h6iyjkjGVXDPSuUZl6rrQGfyMbDFtMAgMzwuqEAgGiJ
         ydss04adYbsZsJPMJ8wGWyxiTc+Rc4GAmGAPGsrZ7QX2OWGGrEGrQ3SXsifiOzoSIv
         LOV3ynvaadJpirrRdLgw2ra5rLtN0jNKbnmQYiaU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marco Felsch <m.felsch@pengutronix.de>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 76/89] iio: light: fix vcnl4000 devicetree hooks
Date:   Fri, 18 Oct 2019 18:03:11 -0400
Message-Id: <20191018220324.8165-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit 1436a78c63495dd94c8d4f84a76d78d5317d481b ]

Since commit ebd457d55911 ("iio: light: vcnl4000 add devicetree hooks")
the of_match_table is supported but the data shouldn't be a string.
Instead it shall be one of 'enum vcnl4000_device_ids'. Also the matching
logic for the vcnl4020 was wrong. Since the data retrieve mechanism is
still based on the i2c_device_id no failures did appeared till now.

Fixes: ebd457d55911 ("iio: light: vcnl4000 add devicetree hooks")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Angus Ainslie (Purism) angus@akkea.ca
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/vcnl4000.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/light/vcnl4000.c b/drivers/iio/light/vcnl4000.c
index 51421ac325177..f522cb863e8c8 100644
--- a/drivers/iio/light/vcnl4000.c
+++ b/drivers/iio/light/vcnl4000.c
@@ -398,19 +398,19 @@ static int vcnl4000_probe(struct i2c_client *client,
 static const struct of_device_id vcnl_4000_of_match[] = {
 	{
 		.compatible = "vishay,vcnl4000",
-		.data = "VCNL4000",
+		.data = (void *)VCNL4000,
 	},
 	{
 		.compatible = "vishay,vcnl4010",
-		.data = "VCNL4010",
+		.data = (void *)VCNL4010,
 	},
 	{
-		.compatible = "vishay,vcnl4010",
-		.data = "VCNL4020",
+		.compatible = "vishay,vcnl4020",
+		.data = (void *)VCNL4010,
 	},
 	{
 		.compatible = "vishay,vcnl4200",
-		.data = "VCNL4200",
+		.data = (void *)VCNL4200,
 	},
 	{},
 };
-- 
2.20.1

