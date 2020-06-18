Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2A81FDAC4
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgFRBIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:08:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726986AbgFRBIM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:08:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD35621D7B;
        Thu, 18 Jun 2020 01:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442492;
        bh=pvXFFlikRX1sr0H7u04Pi2QjezLjA5EYEWdtSY9EDks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MnJTmIZWeMZk1tYbtjRiCc4iC1FDfRsOyhoZn4OJXKgcI7D8fZ91lC901QYWE/My+
         saGoRCFV3hcNy53YpPjC4IALdZUnMypHmqgby+Le/waop6xm4KZV0Nzm+XohFL8Ehu
         ToX5dZcFOrQu6taC2zAg1vGtKR7XXEKEKputDraY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 005/388] rtc: rc5t619: Fix an ERR_PTR vs NULL check
Date:   Wed, 17 Jun 2020 21:01:42 -0400
Message-Id: <20200618010805.600873-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 11ddbdfb68e4f9791e4bd4f8d7c87d3f19670967 ]

The devm_kzalloc() function returns NULL on error, it doesn't return
error pointers so this check doesn't work.

Fixes: 540d1e15393d ("rtc: rc5t619: Add Ricoh RC5T619 RTC driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20200407092852.GI68494@mwanda
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-rc5t619.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-rc5t619.c b/drivers/rtc/rtc-rc5t619.c
index 24e386ecbc7e..dd1a20977478 100644
--- a/drivers/rtc/rtc-rc5t619.c
+++ b/drivers/rtc/rtc-rc5t619.c
@@ -356,10 +356,8 @@ static int rc5t619_rtc_probe(struct platform_device *pdev)
 	int err;
 
 	rtc = devm_kzalloc(dev, sizeof(*rtc), GFP_KERNEL);
-	if (IS_ERR(rtc)) {
-		err = PTR_ERR(rtc);
+	if (!rtc)
 		return -ENOMEM;
-	}
 
 	rtc->rn5t618 = rn5t618;
 
-- 
2.25.1

