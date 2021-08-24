Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6AF03F543D
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbhHXAyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:54:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233564AbhHXAyp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:54:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECB9A613D2;
        Tue, 24 Aug 2021 00:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766442;
        bh=uICdctrZDG7chxVYHm4pT2aNQKVTK9JiuHzWHULc8xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TgrqWrSwtOsexHyziIKdE9CNcpEnwREFPnCX29jVHTSWyUuVNuEccNx7UddZZlx3b
         SxOiHO7T+g9FxlFFKJYrG0WBGVtXtR2YosIs5S+SjI610SE9vJU4WgsT0fRLuaemKt
         jVZAzlEympdaDc48OBPm9Fkf5+I2aoTy2HZ4mSC2yzEgBYkBlXAMqgPsrsKBFFkBLJ
         lKbnHABcCr9xMJTF/LHG/7Xf31j2WTDiGp2v/xwjV1sQcDAlDIi6zrjLY095/slpna
         c28IUAWldDuXX931mwnwWbsIK25dy8vTYqKeNF1GRPUO+mXZnZfh73+E9oDM9BOtTZ
         95tTdQ4Sp+pCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 04/26] opp: remove WARN when no valid OPPs remain
Date:   Mon, 23 Aug 2021 20:53:34 -0400
Message-Id: <20210824005356.630888-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005356.630888-1-sashal@kernel.org>
References: <20210824005356.630888-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

[ Upstream commit 335ffab3ef864539e814b9a2903b0ae420c1c067 ]

This WARN can be triggered per-core and the stack trace is not useful.
Replace it with plain dev_err(). Fix a comment while at it.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/of.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/opp/of.c b/drivers/opp/of.c
index c582a9ca397b..01feeba78426 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -985,8 +985,9 @@ static int _of_add_opp_table_v2(struct device *dev, struct opp_table *opp_table)
 		}
 	}
 
-	/* There should be one of more OPP defined */
-	if (WARN_ON(!count)) {
+	/* There should be one or more OPPs defined */
+	if (!count) {
+		dev_err(dev, "%s: no supported OPPs", __func__);
 		ret = -ENOENT;
 		goto remove_static_opp;
 	}
-- 
2.30.2

