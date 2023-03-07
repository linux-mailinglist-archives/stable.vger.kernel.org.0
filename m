Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B34976AF2DB
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjCGS5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:57:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbjCGS4s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:56:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5F0B4F54
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:44:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 46626CE1C6A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F08AC433A8;
        Tue,  7 Mar 2023 18:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213670;
        bh=ZD2lhVTKv+fJfnyWpbsYZ/EwEqN+oNVOTFlEy8tigvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b7Co4vX9nxHFq5jBExuk5Ne2qwoRJLsyRs7L/mNS7vrmFX0AA/kYJRDK/U1X/E9Gd
         AJBckykhoADAhWLpFB1kkB4oHsJ+Z4YnM0/tA3q9YATvnjmtl497D6esv0Ek3RY2OR
         zvB5VITRIQozZ1C6ZGAqmO2quNFLGXJGrZZIDZLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 582/885] PM: domains: fix memory leak with using debugfs_lookup()
Date:   Tue,  7 Mar 2023 17:58:36 +0100
Message-Id: <20230307170027.649835623@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
2.39.2



