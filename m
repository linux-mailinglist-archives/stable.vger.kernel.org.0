Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35060328E81
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241651AbhCATcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:32:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:48632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241535AbhCAT0p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:26:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35748652D5;
        Mon,  1 Mar 2021 17:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620306;
        bh=P+8iDqsVqhEpxgRJHtOxliIYjrl8ulY/Fx+XDMTY+NA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O0LhKV45NtkxvOHFDfpYkPGAXKsCsVk4svjfxH7yo04Crc/0GWNaR+vO54Z22NiR/
         ByXSfbiv2tapGlGdffhClDCq/t6wCMOayO7GVGICf67MSpXeZtImQa7EFCzntkhRXw
         4y90ev9orDRMLkxX8/e8ooqofcGuDqPRLl2mFduw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Geis <pgwipeout@gmail.com>,
        Nicolas Chauvet <kwizart@gmail.com>,
        Matt Merhar <mattmerhar@protonmail.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 075/775] opp: Correct debug message in _opp_add_static_v2()
Date:   Mon,  1 Mar 2021 17:04:03 +0100
Message-Id: <20210301161205.384112948@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit d7b9d9b31a3e55dcc9b5c289abfafe31efa5b5c4 ]

The debug message always prints rate=0 instead of a proper value, fix it.

Fixes: 6c591eec67cb ("OPP: Add helpers for reading the binding properties")
Tested-by: Peter Geis <pgwipeout@gmail.com>
Tested-by: Nicolas Chauvet <kwizart@gmail.com>
Tested-by: Matt Merhar <mattmerhar@protonmail.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
[ Viresh: Added Fixes tag ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/of.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/opp/of.c b/drivers/opp/of.c
index 03cb387236c4c..d0c0336be39b4 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -755,7 +755,6 @@ static struct dev_pm_opp *_opp_add_static_v2(struct opp_table *opp_table,
 		struct device *dev, struct device_node *np)
 {
 	struct dev_pm_opp *new_opp;
-	u64 rate = 0;
 	u32 val;
 	int ret;
 	bool rate_not_available = false;
@@ -772,7 +771,8 @@ static struct dev_pm_opp *_opp_add_static_v2(struct opp_table *opp_table,
 
 	/* Check if the OPP supports hardware's hierarchy of versions or not */
 	if (!_opp_is_supported(dev, opp_table, np)) {
-		dev_dbg(dev, "OPP not supported by hardware: %llu\n", rate);
+		dev_dbg(dev, "OPP not supported by hardware: %lu\n",
+			new_opp->rate);
 		goto free_opp;
 	}
 
-- 
2.27.0



