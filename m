Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE9271196F7
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfLJVaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:30:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:59154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728314AbfLJVJ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:09:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E2FB246A2;
        Tue, 10 Dec 2019 21:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012196;
        bh=QPjFK2EXgY9x+qBNXW4gGPYCxWQ3fUnbQphCK0+D+ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aE9NrNRHOmbOBO21R+xfWEkfVV7Wy6tk7hIEJcA5SVc8qkj1fId1FsDg159G6Pmqt
         oXi12gKq+h+Mhbc5Zft3sv61R8ERKOflvaB4Rl9EXxnAJqzwUPNX86MDJcMomMIF0w
         /bmbYpFm1kkk27PJ/QUmze2MFjPY1G2z+YIRh7qM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 150/350] media: st-mipid02: add a check for devm_gpiod_get_optional
Date:   Tue, 10 Dec 2019 16:04:15 -0500
Message-Id: <20191210210735.9077-111-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 81285b8d5cfbe..003ba22334cdf 100644
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

