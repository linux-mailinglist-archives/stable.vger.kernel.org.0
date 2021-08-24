Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8DA3F54FA
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234240AbhHXA6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:58:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234239AbhHXAzU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:55:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F9E661504;
        Tue, 24 Aug 2021 00:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766475;
        bh=ZZcorKwKzcJ2Pe7iZyvuFq8GrwRmhRqlcU1yR0JcaVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V+1vliQWFcGy/IUZNl53df86vyxnvNmoORGgCyOvxHgfKZs7+z2SnLKKmiyc3rhJL
         6QUnjJC1YmcK85UcByPvkQ+NVWBHlRM2LBfEzRgrai7fppyXaTRXxg7/KE8lqrTZh2
         BL/nLRtKW8/ep9g7ql2f2bSBGj3I+K937O+HsCIWpw1zmwmttEYlhh87q1xujMc8of
         FA7I2shk1rKRTvqwT9hDGyF291IQ31vlyj8TBb0wHIOmq+Uyzi+odID3q1c7mk23qG
         j3ZViADP4KVt1L4HmwN0odg7OmJkbHjTMOjT5P5vOr8HV9oOrnjEr3HzraJm+1jRLB
         yZHokqyPFSoXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 02/18] opp: remove WARN when no valid OPPs remain
Date:   Mon, 23 Aug 2021 20:54:16 -0400
Message-Id: <20210824005432.631154-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005432.631154-1-sashal@kernel.org>
References: <20210824005432.631154-1-sashal@kernel.org>
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
index 363277b31ecb..d92a1bfe1690 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -870,8 +870,9 @@ static int _of_add_opp_table_v2(struct device *dev, struct opp_table *opp_table)
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

