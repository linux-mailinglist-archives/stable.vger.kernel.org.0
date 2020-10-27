Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D6529B7CA
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1796287AbgJ0PRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:17:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793936AbgJ0PQe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:16:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3CBD22264;
        Tue, 27 Oct 2020 15:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811793;
        bh=x1IGtqNi66+N71baZWo3oPu/0C1iftvwJaW5fsiVJZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YT2osN7A5F2bwBbbFpEy5iLmprkyu9N96qFOafFdK58Mk9LpTKluqHxL84bXZ7nxT
         ZLaOECLMSnBQyt6tAFHfuYLdC1rlYCUXpKj7Edq0l+Q9l6T8c4uo/cRBgS2i6t9ES7
         pyGJvUm0utCCq4tnl248UJTDF1XpNxBiJN/26hD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 587/633] opp: Prevent memory leak in dev_pm_opp_attach_genpd()
Date:   Tue, 27 Oct 2020 14:55:30 +0100
Message-Id: <20201027135550.346493993@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



