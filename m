Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1476B27C85C
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731514AbgI2MBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:01:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730555AbgI2Lkn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:40:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4584F221EC;
        Tue, 29 Sep 2020 11:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379626;
        bh=KlyB1V7trltBZqapT92xp/ft/alNfcd/5PzlcK1on1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OpwZv2q24KWOknWZIGOhYC++iyq6eYg9BQtG0zTz/K9k2Q2HDBqa+3FDJOu8eoCyl
         1Rl7NInMMevqJcwTgMDAsN7KH25nsPx5JT9FvBSKBnQxYVYPuifbmswI3Z5pgqi5l2
         HzuXZGmz/veUfkXIoKpIXtoAmDf1aAyleJzRgPvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 246/388] devlink: Fix reporters recovery condition
Date:   Tue, 29 Sep 2020 12:59:37 +0200
Message-Id: <20200929110022.389390315@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

[ Upstream commit bea0c5c942d3b4e9fb6ed45f6a7de74c6b112437 ]

Devlink health core conditions the reporter's recovery with the
expiration of the grace period. This is not relevant for the first
recovery. Explicitly demand that the grace period will only apply to
recoveries other than the first.

Fixes: c8e1da0bf923 ("devlink: Add health report functionality")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/devlink.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 5667cae57072f..26c8993a17ae0 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4823,6 +4823,7 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
 {
 	enum devlink_health_reporter_state prev_health_state;
 	struct devlink *devlink = reporter->devlink;
+	unsigned long recover_ts_threshold;
 
 	/* write a log message of the current error */
 	WARN_ON(!msg);
@@ -4832,10 +4833,12 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
 	reporter->health_state = DEVLINK_HEALTH_REPORTER_STATE_ERROR;
 
 	/* abort if the previous error wasn't recovered */
+	recover_ts_threshold = reporter->last_recovery_ts +
+			       msecs_to_jiffies(reporter->graceful_period);
 	if (reporter->auto_recover &&
 	    (prev_health_state != DEVLINK_HEALTH_REPORTER_STATE_HEALTHY ||
-	     jiffies - reporter->last_recovery_ts <
-	     msecs_to_jiffies(reporter->graceful_period))) {
+	     (reporter->last_recovery_ts && reporter->recovery_count &&
+	      time_is_after_jiffies(recover_ts_threshold)))) {
 		trace_devlink_health_recover_aborted(devlink,
 						     reporter->ops->name,
 						     reporter->health_state,
-- 
2.25.1



