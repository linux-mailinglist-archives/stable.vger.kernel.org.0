Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE585FA0C4
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 02:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbfKMBwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:52:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:40892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728220AbfKMBwS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:52:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8D55222CD;
        Wed, 13 Nov 2019 01:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609937;
        bh=0+tj+ChrT6Rg6cUA04EqBppN5Cmg4xlFOYO8ZyoCzEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YDPcyBhVgEOAgz+WglplywxKuam7xvENL4xyezbIhxJoXbpY7fsHgfCP3lRxa62y7
         IyF51fAoh8F3lDZVIg8x27M0k5mF+93YfiL3n7/x4fCyAppBk2iBTv0U9QkhoVc+lz
         yAdl/T5rAPDo5u/zULXTcWmpXgJFiylDkI4ln7So=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 080/209] OPP: Return error on error from dev_pm_opp_get_opp_count()
Date:   Tue, 12 Nov 2019 20:48:16 -0500
Message-Id: <20191113015025.9685-80-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 09f662f95306f3e3d47ab6842bc4b0bb868a80ad ]

Return error number instead of 0 on failures.

Fixes: a1e8c13600bf ("PM / OPP: "opp-hz" is optional for power domains")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index f3433bf47b100..1e80f9ec1aa6a 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -313,7 +313,7 @@ int dev_pm_opp_get_opp_count(struct device *dev)
 		count = PTR_ERR(opp_table);
 		dev_dbg(dev, "%s: OPP table not found (%d)\n",
 			__func__, count);
-		return 0;
+		return count;
 	}
 
 	count = _get_opp_count(opp_table);
-- 
2.20.1

