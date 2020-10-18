Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0B2291D32
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733152AbgJRTnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:43:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730353AbgJRTXe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:23:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F4352137B;
        Sun, 18 Oct 2020 19:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049014;
        bh=Yq5QBUFmeAJ3CnHOsKM943tqU9OSR3p5eyu+0akTefI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dioys7jrski5gsTjvEQdJHVHpzIIEt3bXsVf3LvFXGaw79E/IrQPk8Yck49up4YVl
         0FhkyDHX11xRNVBaivm1IPlSTDhsZx6xcTRIuhQd9sr8kzmn0321rS5cjxIhEnaXnT
         j/9og9ViT9EZNBJ/OU/n8mv1djjAtZg5FK0/I2wo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 49/80] opp: Prevent memory leak in dev_pm_opp_attach_genpd()
Date:   Sun, 18 Oct 2020 15:22:00 -0400
Message-Id: <20201018192231.4054535-49-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192231.4054535-1-sashal@kernel.org>
References: <20201018192231.4054535-1-sashal@kernel.org>
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
index 29dfaa591f8b0..8867bab72e171 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -1796,6 +1796,9 @@ static void _opp_detach_genpd(struct opp_table *opp_table)
 {
 	int index;
 
+	if (!opp_table->genpd_virt_devs)
+		return;
+
 	for (index = 0; index < opp_table->required_opp_count; index++) {
 		if (!opp_table->genpd_virt_devs[index])
 			continue;
@@ -1842,6 +1845,9 @@ struct opp_table *dev_pm_opp_attach_genpd(struct device *dev,
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

