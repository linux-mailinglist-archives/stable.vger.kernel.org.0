Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD4C6AA548
	for <lists+stable@lfdr.de>; Sat,  4 Mar 2023 00:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbjCCXDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 18:03:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbjCCXDo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 18:03:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364BD4FA94;
        Fri,  3 Mar 2023 15:03:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0D2DB81A3F;
        Fri,  3 Mar 2023 21:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF67C43446;
        Fri,  3 Mar 2023 21:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677880076;
        bh=L0GDlOFJh1U+yOBJ5nphKgt60E01OaTI0l1WVeilfBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fLjQBXwRRMdk3ZmaSt5J4D/fASyLVT+3fysLDdjsfjhtovN3gMpBbO0cZDWjJEu57
         Nf6LyhVW+Mkd09go5OSgL6j3K+98MJctn/PaCRE14h2kcxiyJRrlv5Ju6RsuzCHQh7
         +B2z+bnfgNTAzPCPr4EjmnLXInJKEMwRNnfZPYCRMkYID7XMQHPpDJgP1OpNBj3scQ
         O0glO/Taz30tdECVKmdUwl8kHB0lmoSd2h0HeynQcS/3e5KK5iYijqHRMNHpXXhDTe
         NAvUQlrixGztyNbarQ2x5KMN+ezp0MaFHLtaLsIshYbPRGNY38QRcH/5kldRryv8b/
         t7qIiHu7kj1Tw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 24/30] kernel/power/energy_model.c: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:47:09 -0500
Message-Id: <20230303214715.1452256-24-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214715.1452256-1-sashal@kernel.org>
References: <20230303214715.1452256-1-sashal@kernel.org>
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

[ Upstream commit a0bc3f78d0fffa8be1a73bf945a43bfe1c2871c1 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <len.brown@intel.com>
Link: https://lore.kernel.org/r/20230202151515.2309543-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/energy_model.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/power/energy_model.c b/kernel/power/energy_model.c
index 119b929dcff0f..334173fe6940e 100644
--- a/kernel/power/energy_model.c
+++ b/kernel/power/energy_model.c
@@ -72,10 +72,7 @@ static void em_debug_create_pd(struct device *dev)
 
 static void em_debug_remove_pd(struct device *dev)
 {
-	struct dentry *debug_dir;
-
-	debug_dir = debugfs_lookup(dev_name(dev), rootdir);
-	debugfs_remove_recursive(debug_dir);
+	debugfs_lookup_and_remove(dev_name(dev), rootdir);
 }
 
 static int __init em_debug_init(void)
-- 
2.39.2

