Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBC112C696
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731474AbfL2Rsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:48:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:59946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731482AbfL2Rsd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:48:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F21D3206DB;
        Sun, 29 Dec 2019 17:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641713;
        bh=abY7+N8N2VKwTKxhqMieCLr8hhyeXeu2UWpxBQVb9r8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mEkCRSHQKOhyxFevY6UxQG2JIMu6a680SBxhFnTI49H4q5hPu9qEjzk/BjxEfSb0f
         3h0o9Rx6PrrjNusW5qAN5NrZM3jJ9OZb55KDKI5VD06Y6MhlzXi5vW6+apRbbfOHey
         B+BM/Ol1Zr8V/oMlY2A/zrf4mkgESRM4sOd2KBvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 179/434] media: st-mipid02: add a check for devm_gpiod_get_optional
Date:   Sun, 29 Dec 2019 18:23:52 +0100
Message-Id: <20191229172713.705108421@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit 61c03b631b74a38ab53753f3ee971a55886d4843 ]

mipid02_probe misses a check for devm_gpiod_get_optional and may miss
the failure.
Add a check to fix the problem.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/st-mipid02.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/i2c/st-mipid02.c b/drivers/media/i2c/st-mipid02.c
index 81285b8d5cfb..003ba22334cd 100644
--- a/drivers/media/i2c/st-mipid02.c
+++ b/drivers/media/i2c/st-mipid02.c
@@ -971,6 +971,11 @@ static int mipid02_probe(struct i2c_client *client)
 	bridge->reset_gpio = devm_gpiod_get_optional(dev, "reset",
 						     GPIOD_OUT_HIGH);
 
+	if (IS_ERR(bridge->reset_gpio)) {
+		dev_err(dev, "failed to get reset GPIO\n");
+		return PTR_ERR(bridge->reset_gpio);
+	}
+
 	ret = mipid02_get_regulators(bridge);
 	if (ret) {
 		dev_err(dev, "failed to get regulators %d", ret);
-- 
2.20.1



