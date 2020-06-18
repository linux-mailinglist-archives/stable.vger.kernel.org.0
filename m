Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76E711FE8EA
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgFRCvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:51:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727931AbgFRBIu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:08:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DD9B2193E;
        Thu, 18 Jun 2020 01:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442530;
        bh=cuJrbmG3TmaVXuupUw8nPnl9fKIu2qpNoPb6EAre7wY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kqzskD90jYAIk7ndPRK5zUtMnByL2NytNBP0qQeiCgATasuD2X2OUCdYq/k/ausgg
         BXGQsFUpR5T8gFlIK4lFzUbNZ630vJ0FcWjmI4QS5kkdB918t0S+dyCHBTzEQtwJPE
         g998y8EQFN+PaHKvhmGi4+XkkC3LG6epNYUkXQ0A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiushi Wu <wu000273@umn.edu>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 033/388] rtc: mc13xxx: fix a double-unlock issue
Date:   Wed, 17 Jun 2020 21:02:10 -0400
Message-Id: <20200618010805.600873-33-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit 8816cd726a4fee197af2d851cbe25991ae19ea14 ]

In function mc13xxx_rtc_probe, the mc13xxx_unlock() is called
before rtc_register_device(). But in the error path of
rtc_register_device(), the mc13xxx_unlock() is called again,
which causes a double-unlock problem. Thus add a call of the
function “mc13xxx_lock” in an if branch for the completion
of the exception handling.

Fixes: e4ae7023e182a ("rtc: mc13xxx: set range")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Link: https://lore.kernel.org/r/20200503182235.1652-1-wu000273@umn.edu
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mc13xxx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-mc13xxx.c b/drivers/rtc/rtc-mc13xxx.c
index afce2c0b4bd6..d6802e6191cb 100644
--- a/drivers/rtc/rtc-mc13xxx.c
+++ b/drivers/rtc/rtc-mc13xxx.c
@@ -308,8 +308,10 @@ static int __init mc13xxx_rtc_probe(struct platform_device *pdev)
 	mc13xxx_unlock(mc13xxx);
 
 	ret = rtc_register_device(priv->rtc);
-	if (ret)
+	if (ret) {
+		mc13xxx_lock(mc13xxx);
 		goto err_irq_request;
+	}
 
 	return 0;
 
-- 
2.25.1

