Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2382E2B64C4
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732093AbgKQNtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:49:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:43918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732090AbgKQNdm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:33:42 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86C46207BC;
        Tue, 17 Nov 2020 13:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620021;
        bh=kJ9D4gPCppPR2jdULZdI/Hn5d/8VvmaLfUWrzlAUvnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ML0LAsYX+/f/RH2m0QDvI8FEHZ1spdRdeE6REVydWJwzB49IfZxp5lvPbAhrmRWGM
         1YNzL8OyJ5II0s0Eqfe8n8HKipU7okB+vBJ2u4GNrbq1e+harpu/iICHQ9s9ewQ7x2
         qbjYPMh5c3LPBJaYPUY6TSpYoMG9IYztlmYU0guI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 081/255] opp: Reduce the size of critical section in _opp_table_kref_release()
Date:   Tue, 17 Nov 2020 14:03:41 +0100
Message-Id: <20201117122142.895520931@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



