Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C392ACE39
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731778AbgKJDxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:53:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:53870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731631AbgKJDx2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:53:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3765920781;
        Tue, 10 Nov 2020 03:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980408;
        bh=kJ9D4gPCppPR2jdULZdI/Hn5d/8VvmaLfUWrzlAUvnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=THbT3XMava+DbKbEbtSSr6HKe0yu1xNNUAVTeCKWZL23ecL/2xOz/hdDAML7c+bdf
         jc2WyYvVVHslzAh282inJy8Eeu3LoygdRe7aDXHQTP2RqJwXvTfcNY0t7O0Dtl4AgP
         noBF6IWy9iLqUX4eE445cKRsqDEckO+TumTT+ZOQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 06/55] opp: Reduce the size of critical section in _opp_table_kref_release()
Date:   Mon,  9 Nov 2020 22:52:29 -0500
Message-Id: <20201110035318.423757-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035318.423757-1-sashal@kernel.org>
References: <20201110035318.423757-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit e0df59de670b48a923246fae1f972317b84b2764 ]

There is a lot of stuff here which can be done outside of the big
opp_table_lock, do that. This helps avoiding few circular dependency
lockdeps around debugfs and interconnects.

Reported-by: Rob Clark <robdclark@gmail.com>
Reported-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index 1a95ad40795be..a963df7bd2749 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -1160,6 +1160,10 @@ static void _opp_table_kref_release(struct kref *kref)
 	struct opp_device *opp_dev, *temp;
 	int i;
 
+	/* Drop the lock as soon as we can */
+	list_del(&opp_table->node);
+	mutex_unlock(&opp_table_lock);
+
 	_of_clear_opp_table(opp_table);
 
 	/* Release clk */
@@ -1187,10 +1191,7 @@ static void _opp_table_kref_release(struct kref *kref)
 
 	mutex_destroy(&opp_table->genpd_virt_dev_lock);
 	mutex_destroy(&opp_table->lock);
-	list_del(&opp_table->node);
 	kfree(opp_table);
-
-	mutex_unlock(&opp_table_lock);
 }
 
 void dev_pm_opp_put_opp_table(struct opp_table *opp_table)
-- 
2.27.0

