Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E64E328CF8
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240909AbhCATCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:02:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:58440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240711AbhCAS4f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:56:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6577D64F76;
        Mon,  1 Mar 2021 17:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618397;
        bh=AdJfc14SABWAcl9jlwqo6le6b5UrFd7+/jgOyfD5XNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGw9f/xSkAs16AauPXGc15g2SEUCKAVIMgB/DlSycc5e48oOLPlKkIVGmOL92g28i
         Mv3hz7x7FSNcPuqjDi8aN+0WnIqqlocBqSyrwYXGVtkbjvKxJLPqOzIwadNO/soQqW
         D7qc/2EuZ4Ku0HwJuZE1s0zQ7tv2ZGn9F4SI4UbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Geis <pgwipeout@gmail.com>,
        Nicolas Chauvet <kwizart@gmail.com>,
        Matt Merhar <mattmerhar@protonmail.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/663] opp: Correct debug message in _opp_add_static_v2()
Date:   Mon,  1 Mar 2021 17:05:21 +0100
Message-Id: <20210301161145.345939210@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index 9faeb83e4b326..363277b31ecbb 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -751,7 +751,6 @@ static struct dev_pm_opp *_opp_add_static_v2(struct opp_table *opp_table,
 		struct device *dev, struct device_node *np)
 {
 	struct dev_pm_opp *new_opp;
-	u64 rate = 0;
 	u32 val;
 	int ret;
 	bool rate_not_available = false;
@@ -768,7 +767,8 @@ static struct dev_pm_opp *_opp_add_static_v2(struct opp_table *opp_table,
 
 	/* Check if the OPP supports hardware's hierarchy of versions or not */
 	if (!_opp_is_supported(dev, opp_table, np)) {
-		dev_dbg(dev, "OPP not supported by hardware: %llu\n", rate);
+		dev_dbg(dev, "OPP not supported by hardware: %lu\n",
+			new_opp->rate);
 		goto free_opp;
 	}
 
-- 
2.27.0



