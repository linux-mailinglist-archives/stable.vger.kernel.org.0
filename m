Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726656A31CD
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 16:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbjBZPG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 10:06:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbjBZPFj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 10:05:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E679220552;
        Sun, 26 Feb 2023 06:56:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4F2A60C74;
        Sun, 26 Feb 2023 14:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33BBEC433B4;
        Sun, 26 Feb 2023 14:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422900;
        bh=zwmTiw4jNGEI+6WAvCEtRzDSNB+DvOn5KyjyWJ48JgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JQdYV6X5LaI0+bKdyID4twOil94hQgzC3oWFh86yOt2KwUEWxuBYvlpDNRGucbOMX
         bCu2FNXb/TCXDoYOumz6IDImoZ0mvCnYGU+oxh8s2t9GgxZ2QN9blAEcXeOkNeabWE
         g+WtW/4duAraS/FMs6R4qZBwEuhcJa3nMX1gb7ZInGpQSsB0dEG073d0/mU0bLZdJw
         OTtaeD9eeLecN6dnHt4HNWKld+7o11NnQmsSpSpI9g/iiKM5rFhMohhf2xqu8+Dqk1
         R+Y23Srt0DuHyOqQjYVuiTXOPOo8cuMl3G7wgtXN/NrSc5RTuc3Yuwe9Ur84hZrVvy
         NI/ia46Akg1gA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        khilman@kernel.org, pavel@ucw.cz, len.brown@intel.com,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 39/49] PM: domains: fix memory leak with using debugfs_lookup()
Date:   Sun, 26 Feb 2023 09:46:39 -0500
Message-Id: <20230226144650.826470-39-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144650.826470-1-sashal@kernel.org>
References: <20230226144650.826470-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 0b6200e1e9f53dabdc30d0f6c51af9a5f664d32b ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/domain.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index 6471b559230e9..b411201f75bfb 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -220,13 +220,10 @@ static void genpd_debug_add(struct generic_pm_domain *genpd);
 
 static void genpd_debug_remove(struct generic_pm_domain *genpd)
 {
-	struct dentry *d;
-
 	if (!genpd_debugfs_dir)
 		return;
 
-	d = debugfs_lookup(genpd->name, genpd_debugfs_dir);
-	debugfs_remove(d);
+	debugfs_lookup_and_remove(genpd->name, genpd_debugfs_dir);
 }
 
 static void genpd_update_accounting(struct generic_pm_domain *genpd)
-- 
2.39.0

