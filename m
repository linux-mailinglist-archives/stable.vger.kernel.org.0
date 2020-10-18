Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB85291E09
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730388AbgJRTtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:49:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729552AbgJRTVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:21:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7696222E7;
        Sun, 18 Oct 2020 19:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048903;
        bh=x1IGtqNi66+N71baZWo3oPu/0C1iftvwJaW5fsiVJZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oGAAYO0qlquwzQJnbM1DiyWNdPqcFfWVKIYPyjNCMha6kv5wGZVLT5wcB6sEOM8ya
         oIcD4lshV6maj8iKxlVwdY55LuGxBFofYs62RnZfSMGYxwvN/u5cP1oMBCTk13B9Qw
         K4aAiyd/gGJ7i/F9gIJDytffixMPDOvhfr6gltBQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 064/101] opp: Prevent memory leak in dev_pm_opp_attach_genpd()
Date:   Sun, 18 Oct 2020 15:19:49 -0400
Message-Id: <20201018192026.4053674-64-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit cb60e9602cce1593eb1e9cdc8ee562815078a354 ]

If dev_pm_opp_attach_genpd() is called multiple times (once for each CPU
sharing the table), then it would result in unwanted behavior like
memory leak, attaching the domain multiple times, etc.

Handle that by checking and returning earlier if the domains are already
attached. Now that dev_pm_opp_detach_genpd() can get called multiple
times as well, we need to protect that too.

Note that the virtual device pointers aren't returned in this case, as
they may become unavailable to some callers during the middle of the
operation.

Reported-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index 91dcad982d362..11d192fb2e813 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -1918,6 +1918,9 @@ static void _opp_detach_genpd(struct opp_table *opp_table)
 {
 	int index;
 
+	if (!opp_table->genpd_virt_devs)
+		return;
+
 	for (index = 0; index < opp_table->required_opp_count; index++) {
 		if (!opp_table->genpd_virt_devs[index])
 			continue;
@@ -1964,6 +1967,9 @@ struct opp_table *dev_pm_opp_attach_genpd(struct device *dev,
 	if (!opp_table)
 		return ERR_PTR(-ENOMEM);
 
+	if (opp_table->genpd_virt_devs)
+		return opp_table;
+
 	/*
 	 * If the genpd's OPP table isn't already initialized, parsing of the
 	 * required-opps fail for dev. We should retry this after genpd's OPP
-- 
2.25.1

